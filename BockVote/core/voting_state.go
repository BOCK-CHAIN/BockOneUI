package core

import (
	"fmt"
	"sync"
	"time"

	"github.com/anthdm/projectx/crypto"
)

// VoterStatus represents the status of a voter registration
type VoterStatus byte

const (
	VoterStatusPending VoterStatus = iota
	VoterStatusApproved
	VoterStatusRejected
)

// CandidateStatus represents the status of a candidate registration
type CandidateStatus byte

const (
	CandidateStatusPending CandidateStatus = iota
	CandidateStatusApproved
	CandidateStatusRejected
)

// ElectionStatus represents the status of an election
type ElectionStatus byte

const (
	ElectionStatusPending ElectionStatus = iota
	ElectionStatusActive
	ElectionStatusEnded
)

// Voter represents a registered voter
type Voter struct {
	ID          string
	PublicKey   crypto.PublicKey
	IPFSDocHash string
	Status      VoterStatus
	Timestamp   int64
}

// Candidate represents a registered candidate
type Candidate struct {
	ID              string
	ElectionID      string
	PublicKey       crypto.PublicKey
	IPFSProfileHash string
	Status          CandidateStatus
	Timestamp       int64
	VoteCount       uint64
}

// Election represents an election
type Election struct {
	ID          string
	Title       string
	Description string
	StartTime   int64
	EndTime     int64
	AdminKey    crypto.PublicKey
	Status      ElectionStatus
	Timestamp   int64
	Candidates  map[string]*Candidate
	VoteCounts  map[string]uint64 // CandidateID -> vote count
}

// VotingState manages the state of voting-related data
type VotingState struct {
	mu        sync.RWMutex
	voters    map[string]*Voter          // VoterID -> Voter
	elections map[string]*Election       // ElectionID -> Election
	hasVoted  map[string]map[string]bool // ElectionID -> VoterID -> has voted
}

// NewVotingState creates a new VotingState
func NewVotingState() *VotingState {
	return &VotingState{
		voters:    make(map[string]*Voter),
		elections: make(map[string]*Election),
		hasVoted:  make(map[string]map[string]bool),
	}
}

// RegisterVoter adds a new voter to the state
func (vs *VotingState) RegisterVoter(tx *VoterRegistrationTx) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	// Check if voter already exists
	if _, exists := vs.voters[tx.VoterID]; exists {
		return fmt.Errorf("voter with ID %s already exists", tx.VoterID)
	}

	voter := &Voter{
		ID:          tx.VoterID,
		PublicKey:   tx.VoterPublicKey,
		IPFSDocHash: tx.IPFSDocHash,
		Status:      VoterStatusPending,
		Timestamp:   tx.Timestamp,
	}

	vs.voters[tx.VoterID] = voter
	return nil
}

// ApproveVoter approves a voter registration
func (vs *VotingState) ApproveVoter(voterID string, adminKey crypto.PublicKey) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	voter, exists := vs.voters[voterID]
	if !exists {
		return fmt.Errorf("voter with ID %s does not exist", voterID)
	}

	voter.Status = VoterStatusApproved
	return nil
}

// RejectVoter rejects a voter registration
func (vs *VotingState) RejectVoter(voterID string, adminKey crypto.PublicKey) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	voter, exists := vs.voters[voterID]
	if !exists {
		return fmt.Errorf("voter with ID %s does not exist", voterID)
	}

	voter.Status = VoterStatusRejected
	return nil
}

// CreateElection creates a new election
func (vs *VotingState) CreateElection(tx *ElectionCreationTx) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	// Check if election already exists
	if _, exists := vs.elections[tx.ElectionID]; exists {
		return fmt.Errorf("election with ID %s already exists", tx.ElectionID)
	}

	election := &Election{
		ID:          tx.ElectionID,
		Title:       tx.Title,
		Description: tx.Description,
		StartTime:   tx.StartTime,
		EndTime:     tx.EndTime,
		AdminKey:    tx.AdminPublicKey,
		Status:      ElectionStatusPending,
		Timestamp:   tx.Timestamp,
		Candidates:  make(map[string]*Candidate),
		VoteCounts:  make(map[string]uint64),
	}

	vs.elections[tx.ElectionID] = election
	vs.hasVoted[tx.ElectionID] = make(map[string]bool)

	// Update election status based on current time
	now := time.Now().Unix()
	if now >= election.StartTime && now < election.EndTime {
		election.Status = ElectionStatusActive
	} else if now >= election.EndTime {
		election.Status = ElectionStatusEnded
	}

	return nil
}

// RegisterCandidate adds a new candidate to an election
func (vs *VotingState) RegisterCandidate(tx *CandidateRegistrationTx) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	// Check if election exists
	election, exists := vs.elections[tx.ElectionID]
	if !exists {
		return fmt.Errorf("election with ID %s does not exist", tx.ElectionID)
	}

	// Check if candidate already exists in this election
	if _, exists := election.Candidates[tx.CandidateID]; exists {
		return fmt.Errorf("candidate with ID %s already registered for election %s", tx.CandidateID, tx.ElectionID)
	}

	candidate := &Candidate{
		ID:              tx.CandidateID,
		ElectionID:      tx.ElectionID,
		PublicKey:       tx.CandidatePublicKey,
		IPFSProfileHash: tx.IPFSProfileHash,
		Status:          CandidateStatusPending,
		Timestamp:       tx.Timestamp,
		VoteCount:       0,
	}

	election.Candidates[tx.CandidateID] = candidate
	election.VoteCounts[tx.CandidateID] = 0
	return nil
}

// ApproveCandidate approves a candidate registration
func (vs *VotingState) ApproveCandidate(electionID, candidateID string, adminKey crypto.PublicKey) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	election, exists := vs.elections[electionID]
	if !exists {
		return fmt.Errorf("election with ID %s does not exist", electionID)
	}

	// Verify admin key using string representation
	if election.AdminKey.String() != adminKey.String() {
		return fmt.Errorf("unauthorized: only the election admin can approve candidates")
	}

	candidate, exists := election.Candidates[candidateID]
	if !exists {
		return fmt.Errorf("candidate with ID %s does not exist in election %s", candidateID, electionID)
	}

	candidate.Status = CandidateStatusApproved
	return nil
}

// RejectCandidate rejects a candidate registration
func (vs *VotingState) RejectCandidate(electionID, candidateID string, adminKey crypto.PublicKey) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	election, exists := vs.elections[electionID]
	if !exists {
		return fmt.Errorf("election with ID %s does not exist", electionID)
	}

	// Verify admin key using string representation
	if election.AdminKey.String() != adminKey.String() {
		return fmt.Errorf("unauthorized: only the election admin can reject candidates")
	}

	candidate, exists := election.Candidates[candidateID]
	if !exists {
		return fmt.Errorf("candidate with ID %s does not exist in election %s", candidateID, electionID)
	}

	candidate.Status = CandidateStatusRejected
	return nil
}

// CastVote records a vote for a candidate
func (vs *VotingState) CastVote(tx *VoteTx) error {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	// Check if election exists
	election, exists := vs.elections[tx.ElectionID]
	if !exists {
		return fmt.Errorf("election with ID %s does not exist", tx.ElectionID)
	}

	// Check if election is active
	now := time.Now().Unix()
	if now < election.StartTime {
		return fmt.Errorf("election %s has not started yet", tx.ElectionID)
	}
	if now >= election.EndTime {
		return fmt.Errorf("election %s has ended", tx.ElectionID)
	}

	// Find voter by public key
	var voterID string
	for id, voter := range vs.voters {
		if voter.PublicKey.String() == tx.VoterPublicKey.String() {
			voterID = id
			break
		}
	}

	if voterID == "" {
		return fmt.Errorf("voter not found or not registered")
	}

	// Check if voter is approved
	voter := vs.voters[voterID]
	if voter.Status != VoterStatusApproved {
		return fmt.Errorf("voter is not approved to vote")
	}

	// Check if candidate exists and is approved
	candidate, exists := election.Candidates[tx.CandidateID]
	if !exists {
		return fmt.Errorf("candidate with ID %s does not exist in election %s", tx.CandidateID, tx.ElectionID)
	}
	if candidate.Status != CandidateStatusApproved {
		return fmt.Errorf("candidate is not approved to receive votes")
	}

	// Check if voter has already voted in this election
	if vs.hasVoted[tx.ElectionID][voterID] {
		return fmt.Errorf("voter has already cast a vote in this election")
	}

	// Record the vote
	election.VoteCounts[tx.CandidateID]++
	candidate.VoteCount++
	vs.hasVoted[tx.ElectionID][voterID] = true

	return nil
}

// GetElectionResults returns the results of an election
func (vs *VotingState) GetElectionResults(electionID string) (map[string]uint64, error) {
	vs.mu.RLock()
	defer vs.mu.RUnlock()

	election, exists := vs.elections[electionID]
	if !exists {
		return nil, fmt.Errorf("election with ID %s does not exist", electionID)
	}

	// Only return results if election has ended
	now := time.Now().Unix()
	if now < election.EndTime {
		return nil, fmt.Errorf("election %s has not ended yet", electionID)
	}

	// Create a copy of the results
	results := make(map[string]uint64)
	for candidateID, count := range election.VoteCounts {
		results[candidateID] = count
	}

	return results, nil
}

// GetElection returns information about an election
func (vs *VotingState) GetElection(electionID string) (*Election, error) {
	vs.mu.RLock()
	defer vs.mu.RUnlock()

	election, exists := vs.elections[electionID]
	if !exists {
		return nil, fmt.Errorf("election with ID %s does not exist", electionID)
	}

	return election, nil
}

// GetVoter returns information about a voter
func (vs *VotingState) GetVoter(voterID string) (*Voter, error) {
	vs.mu.RLock()
	defer vs.mu.RUnlock()

	voter, exists := vs.voters[voterID]
	if !exists {
		return nil, fmt.Errorf("voter with ID %s does not exist", voterID)
	}

	return voter, nil
}

// GetCandidate returns information about a candidate
func (vs *VotingState) GetCandidate(electionID, candidateID string) (*Candidate, error) {
	vs.mu.RLock()
	defer vs.mu.RUnlock()

	election, exists := vs.elections[electionID]
	if !exists {
		return nil, fmt.Errorf("election with ID %s does not exist", electionID)
	}

	candidate, exists := election.Candidates[candidateID]
	if !exists {
		return nil, fmt.Errorf("candidate with ID %s does not exist in election %s", candidateID, electionID)
	}

	return candidate, nil
}

// ListElections returns all elections currently stored in state.
func (vs *VotingState) ListElections() []*Election {
	vs.mu.RLock()
	defer vs.mu.RUnlock()

	elections := make([]*Election, 0, len(vs.elections))
	for _, election := range vs.elections {
		elections = append(elections, election)
	}

	return elections
}

// UpdateElectionStatuses updates the status of all elections based on current time
func (vs *VotingState) UpdateElectionStatuses() {
	vs.mu.Lock()
	defer vs.mu.Unlock()

	now := time.Now().Unix()
	for _, election := range vs.elections {
		if now >= election.StartTime && now < election.EndTime && election.Status != ElectionStatusActive {
			election.Status = ElectionStatusActive
		} else if now >= election.EndTime && election.Status != ElectionStatusEnded {
			election.Status = ElectionStatusEnded
		}
	}
}
