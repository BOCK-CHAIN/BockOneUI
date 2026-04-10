package api

import (
	"encoding/gob"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/anthdm/projectx/core"
	"github.com/anthdm/projectx/crypto"
	"github.com/anthdm/projectx/types"
	"github.com/go-kit/log"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type TxResponse struct {
	TxCount uint
	Hashes  []string
}

type APIError struct {
	Error string
}

type Block struct {
	Hash          string
	Version       uint32
	DataHash      string
	PrevBlockHash string
	Height        uint32
	Timestamp     int64
	Validator     string
	Signature     string

	TxResponse TxResponse
}

// VoterResponse represents voter information returned by the API
type VoterResponse struct {
	ID          string `json:"id"`
	PublicKey   string `json:"publicKey"`
	IPFSDocHash string `json:"ipfsDocHash"`
	Status      string `json:"status"`
	Timestamp   int64  `json:"timestamp"`
}

// CandidateResponse represents candidate information returned by the API
type CandidateResponse struct {
	ID              string `json:"id"`
	ElectionID      string `json:"electionId"`
	PublicKey       string `json:"publicKey"`
	IPFSProfileHash string `json:"ipfsProfileHash"`
	Status          string `json:"status"`
	VoteCount       uint64 `json:"voteCount"`
	Timestamp       int64  `json:"timestamp"`
}

// ElectionResponse represents election information returned by the API
type ElectionResponse struct {
	ID          string              `json:"id"`
	Title       string              `json:"title"`
	Description string              `json:"description"`
	StartTime   int64               `json:"startTime"`
	EndTime     int64               `json:"endTime"`
	AdminKey    string              `json:"adminKey"`
	Status      string              `json:"status"`
	Timestamp   int64               `json:"timestamp"`
	Candidates  []CandidateResponse `json:"candidates,omitempty"`
	VoteCounts  map[string]uint64   `json:"voteCounts,omitempty"`
}

// ElectionResultsResponse represents election results returned by the API
type ElectionResultsResponse struct {
	ElectionID string            `json:"electionId"`
	Title      string            `json:"title"`
	EndTime    int64             `json:"endTime"`
	Results    map[string]uint64 `json:"results"`
	Candidates map[string]string `json:"candidates"` // CandidateID -> Name/Profile hash
}

// VoterRegistrationRequest represents a request to register a voter
type VoterRegistrationRequest struct {
	VoterID     string `json:"voterId"`
	IPFSDocHash string `json:"ipfsDocHash"`
}

// CandidateRegistrationRequest represents a request to register a candidate
type CandidateRegistrationRequest struct {
	CandidateID     string `json:"candidateId"`
	ElectionID      string `json:"electionId"`
	IPFSProfileHash string `json:"ipfsProfileHash"`
}

// ElectionCreationRequest represents a request to create an election
type ElectionCreationRequest struct {
	ElectionID  string `json:"electionId"`
	Title       string `json:"title"`
	Description string `json:"description"`
	StartTime   int64  `json:"startTime"`
	EndTime     int64  `json:"endTime"`
}

// VoteRequest represents a request to cast a vote
type VoteRequest struct {
	ElectionID  string `json:"electionId"`
	CandidateID string `json:"candidateId"`
}

// ApprovalRequest represents a request to approve a voter or candidate
type ApprovalRequest struct {
	ID         string `json:"id"`
	ElectionID string `json:"electionId,omitempty"` // Only needed for candidate approval
	Approve    bool   `json:"approve"`
}

type ServerConfig struct {
	Logger     log.Logger
	ListenAddr string
}

type Server struct {
	txChan chan *core.Transaction
	ServerConfig
	bc *core.Blockchain
}

func NewServer(cfg ServerConfig, bc *core.Blockchain, txChan chan *core.Transaction) *Server {
	return &Server{
		ServerConfig: cfg,
		bc:           bc,
		txChan:       txChan,
	}
}

func (s *Server) Start() error {
	e := echo.New()
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{
			http.MethodGet,
			http.MethodPost,
			http.MethodPut,
			http.MethodPatch,
			http.MethodDelete,
			http.MethodOptions,
		},
		AllowHeaders: []string{
			echo.HeaderContentType,
			echo.HeaderAuthorization,
			"X-Private-Key",
			"X-Admin-Key",
		},
	}))

	e.GET("/block/:hashorid", s.handleGetBlock)
	e.GET("/tx/:hash", s.handleGetTx)
	e.POST("/tx", s.handlePostTx)

	// Voting API endpoints
	e.GET("/voting/elections", s.handleListElections)
	e.POST("/voting/register/voter", s.handleRegisterVoter)
	e.POST("/voting/register/candidate", s.handleRegisterCandidate)
	e.POST("/voting/election/create", s.handleCreateElection)
	e.POST("/voting/vote", s.handleCastVote)
	e.GET("/voting/election/:id", s.handleGetElection)
	e.GET("/voting/election/:id/results", s.handleGetElectionResults)
	e.GET("/voting/voter/:id", s.handleGetVoter)
	e.GET("/voting/candidate/:electionId/:id", s.handleGetCandidate)
	e.POST("/voting/approve/voter", s.handleApproveVoter)
	e.POST("/voting/approve/candidate", s.handleApproveCandidate)

	return e.Start(s.ListenAddr)
}

func (s *Server) handlePostTx(c echo.Context) error {
	tx := &core.Transaction{}
	if err := gob.NewDecoder(c.Request().Body).Decode(tx); err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}
	s.txChan <- tx

	return nil
}

func (s *Server) handleGetTx(c echo.Context) error {
	hash := c.Param("hash")

	b, err := hex.DecodeString(hash)
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	tx, err := s.bc.GetTxByHash(types.HashFromBytes(b))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	return c.JSON(http.StatusOK, tx)
}

func (s *Server) handleGetBlock(c echo.Context) error {
	hashOrID := c.Param("hashorid")

	height, err := strconv.Atoi(hashOrID)
	// If the error is nil we can assume the height of the block is given.
	if err == nil {
		block, err := s.bc.GetBlock(uint32(height))
		if err != nil {
			return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
		}

		return c.JSON(http.StatusOK, intoJSONBlock(block))
	}

	// otherwise assume its the hash
	b, err := hex.DecodeString(hashOrID)
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	block, err := s.bc.GetBlockByHash(types.HashFromBytes(b))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	return c.JSON(http.StatusOK, intoJSONBlock(block))
}

// handleRegisterVoter handles voter registration requests
func (s *Server) handleRegisterVoter(c echo.Context) error {
	var req VoterRegistrationRequest
	if err := json.NewDecoder(c.Request().Body).Decode(&req); err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	privKey, err := parseRequestPrivateKey(c.Request().Header.Get("X-Private-Key"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	// Create voter registration transaction
	tx := core.NewTransaction(nil)
	tx.TxInner = core.VoterRegistrationTx{
		VoterID:        req.VoterID,
		IPFSDocHash:    req.IPFSDocHash,
		VoterPublicKey: privKey.PublicKey(),
		Timestamp:      time.Now().Unix(),
	}

	if err := tx.Sign(privKey); err != nil {
		return c.JSON(http.StatusInternalServerError, APIError{Error: err.Error()})
	}

	s.txChan <- tx

	return c.JSON(http.StatusOK, map[string]string{
		"status": "success",
		"txHash": tx.Hash(core.TxHasher{}).String(),
	})
}

// handleRegisterCandidate handles candidate registration requests
func (s *Server) handleRegisterCandidate(c echo.Context) error {
	var req CandidateRegistrationRequest
	if err := json.NewDecoder(c.Request().Body).Decode(&req); err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	privKey, err := parseRequestPrivateKey(c.Request().Header.Get("X-Private-Key"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	// Create candidate registration transaction
	tx := core.NewTransaction(nil)
	tx.TxInner = core.CandidateRegistrationTx{
		CandidateID:        req.CandidateID,
		ElectionID:         req.ElectionID,
		IPFSProfileHash:    req.IPFSProfileHash,
		CandidatePublicKey: privKey.PublicKey(),
		Timestamp:          time.Now().Unix(),
	}

	if err := tx.Sign(privKey); err != nil {
		return c.JSON(http.StatusInternalServerError, APIError{Error: err.Error()})
	}

	s.txChan <- tx

	return c.JSON(http.StatusOK, map[string]string{
		"status": "success",
		"txHash": tx.Hash(core.TxHasher{}).String(),
	})
}

// handleCreateElection handles election creation requests
func (s *Server) handleCreateElection(c echo.Context) error {
	var req ElectionCreationRequest
	if err := json.NewDecoder(c.Request().Body).Decode(&req); err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	privKey, err := parseRequestPrivateKey(c.Request().Header.Get("X-Private-Key"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	// Create election creation transaction
	tx := core.NewTransaction(nil)
	tx.TxInner = core.ElectionCreationTx{
		ElectionID:     req.ElectionID,
		Title:          req.Title,
		Description:    req.Description,
		StartTime:      req.StartTime,
		EndTime:        req.EndTime,
		AdminPublicKey: privKey.PublicKey(),
		Timestamp:      time.Now().Unix(),
	}

	if err := tx.Sign(privKey); err != nil {
		return c.JSON(http.StatusInternalServerError, APIError{Error: err.Error()})
	}

	s.txChan <- tx

	return c.JSON(http.StatusOK, map[string]string{
		"status": "success",
		"txHash": tx.Hash(core.TxHasher{}).String(),
	})
}

// handleCastVote handles vote casting requests
func (s *Server) handleCastVote(c echo.Context) error {
	var req VoteRequest
	if err := json.NewDecoder(c.Request().Body).Decode(&req); err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	privKey, err := parseRequestPrivateKey(c.Request().Header.Get("X-Private-Key"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	// Create vote transaction
	tx := core.NewTransaction(nil)
	tx.TxInner = core.VoteTx{
		ElectionID:     req.ElectionID,
		CandidateID:    req.CandidateID,
		VoterPublicKey: privKey.PublicKey(),
		Timestamp:      time.Now().Unix(),
	}

	if err := tx.Sign(privKey); err != nil {
		return c.JSON(http.StatusInternalServerError, APIError{Error: err.Error()})
	}

	s.txChan <- tx

	return c.JSON(http.StatusOK, map[string]string{
		"status": "success",
		"txHash": tx.Hash(core.TxHasher{}).String(),
	})
}

// handleListElections handles requests to list all elections.
func (s *Server) handleListElections(c echo.Context) error {
	s.bc.GetVotingState().UpdateElectionStatuses()

	includeCandidates := c.QueryParam("includeCandidates") == "true"
	elections := s.bc.GetVotingState().ListElections()
	sort.Slice(elections, func(i, j int) bool {
		return elections[i].Timestamp > elections[j].Timestamp
	})

	responses := make([]ElectionResponse, 0, len(elections))
	for _, election := range elections {
		responses = append(responses, toElectionResponse(election, includeCandidates))
	}

	return c.JSON(http.StatusOK, responses)
}

// handleGetElection handles requests to get election information
func (s *Server) handleGetElection(c echo.Context) error {
	electionID := c.Param("id")
	if electionID == "" {
		return c.JSON(http.StatusBadRequest, APIError{Error: "election ID is required"})
	}

	s.bc.GetVotingState().UpdateElectionStatuses()

	election, err := s.bc.GetVotingState().GetElection(electionID)
	if err != nil {
		return c.JSON(http.StatusNotFound, APIError{Error: err.Error()})
	}

	response := toElectionResponse(election, c.QueryParam("includeCandidates") == "true")

	return c.JSON(http.StatusOK, response)
}

// handleGetElectionResults handles requests to get election results
func (s *Server) handleGetElectionResults(c echo.Context) error {
	electionID := c.Param("id")
	if electionID == "" {
		return c.JSON(http.StatusBadRequest, APIError{Error: "election ID is required"})
	}

	// First get the election to check if it has ended
	election, err := s.bc.GetVotingState().GetElection(electionID)
	if err != nil {
		return c.JSON(http.StatusNotFound, APIError{Error: err.Error()})
	}

	// Get results
	results, err := s.bc.GetVotingState().GetElectionResults(electionID)
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	// Create a map of candidate IDs to names/profile hashes
	candidateMap := make(map[string]string)
	for id, candidate := range election.Candidates {
		candidateMap[id] = candidate.IPFSProfileHash
	}

	response := ElectionResultsResponse{
		ElectionID: election.ID,
		Title:      election.Title,
		EndTime:    election.EndTime,
		Results:    results,
		Candidates: candidateMap,
	}

	return c.JSON(http.StatusOK, response)
}

// handleGetVoter handles requests to get voter information
func (s *Server) handleGetVoter(c echo.Context) error {
	voterID := c.Param("id")
	if voterID == "" {
		return c.JSON(http.StatusBadRequest, APIError{Error: "voter ID is required"})
	}

	voter, err := s.bc.GetVotingState().GetVoter(voterID)
	if err != nil {
		return c.JSON(http.StatusNotFound, APIError{Error: err.Error()})
	}

	// Convert status to string
	var statusStr string
	switch voter.Status {
	case core.VoterStatusPending:
		statusStr = "pending"
	case core.VoterStatusApproved:
		statusStr = "approved"
	case core.VoterStatusRejected:
		statusStr = "rejected"
	}

	response := VoterResponse{
		ID:          voter.ID,
		PublicKey:   voter.PublicKey.String(),
		IPFSDocHash: voter.IPFSDocHash,
		Status:      statusStr,
		Timestamp:   voter.Timestamp,
	}

	return c.JSON(http.StatusOK, response)
}

// handleGetCandidate handles requests to get candidate information
func (s *Server) handleGetCandidate(c echo.Context) error {
	electionID := c.Param("electionId")
	candidateID := c.Param("id")
	if electionID == "" || candidateID == "" {
		return c.JSON(http.StatusBadRequest, APIError{Error: "election ID and candidate ID are required"})
	}

	candidate, err := s.bc.GetVotingState().GetCandidate(electionID, candidateID)
	if err != nil {
		return c.JSON(http.StatusNotFound, APIError{Error: err.Error()})
	}

	// Convert status to string
	var statusStr string
	switch candidate.Status {
	case core.CandidateStatusPending:
		statusStr = "pending"
	case core.CandidateStatusApproved:
		statusStr = "approved"
	case core.CandidateStatusRejected:
		statusStr = "rejected"
	}

	response := CandidateResponse{
		ID:              candidate.ID,
		ElectionID:      candidate.ElectionID,
		PublicKey:       candidate.PublicKey.String(),
		IPFSProfileHash: candidate.IPFSProfileHash,
		Status:          statusStr,
		VoteCount:       candidate.VoteCount,
		Timestamp:       candidate.Timestamp,
	}

	return c.JSON(http.StatusOK, response)
}

// handleApproveVoter handles requests to approve or reject voters
func (s *Server) handleApproveVoter(c echo.Context) error {
	var req ApprovalRequest
	if err := json.NewDecoder(c.Request().Body).Decode(&req); err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	adminKey, err := parseRequestPrivateKey(c.Request().Header.Get("X-Admin-Key"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	var actionErr error
	if req.Approve {
		actionErr = s.bc.GetVotingState().ApproveVoter(req.ID, adminKey.PublicKey())
	} else {
		actionErr = s.bc.GetVotingState().RejectVoter(req.ID, adminKey.PublicKey())
	}

	if actionErr != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: actionErr.Error()})
	}

	return c.JSON(http.StatusOK, map[string]string{
		"status": "success",
		"action": map[bool]string{true: "approved", false: "rejected"}[req.Approve],
	})
}

// handleApproveCandidate handles requests to approve or reject candidates
func (s *Server) handleApproveCandidate(c echo.Context) error {
	var req ApprovalRequest
	if err := json.NewDecoder(c.Request().Body).Decode(&req); err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	if req.ElectionID == "" {
		return c.JSON(http.StatusBadRequest, APIError{Error: "election ID is required"})
	}

	adminKey, err := parseRequestPrivateKey(c.Request().Header.Get("X-Admin-Key"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
	}

	var actionErr error
	if req.Approve {
		actionErr = s.bc.GetVotingState().ApproveCandidate(req.ElectionID, req.ID, adminKey.PublicKey())
	} else {
		actionErr = s.bc.GetVotingState().RejectCandidate(req.ElectionID, req.ID, adminKey.PublicKey())
	}

	if actionErr != nil {
		return c.JSON(http.StatusBadRequest, APIError{Error: actionErr.Error()})
	}

	return c.JSON(http.StatusOK, map[string]string{
		"status": "success",
		"action": map[bool]string{true: "approved", false: "rejected"}[req.Approve],
	})
}

func parseRequestPrivateKey(rawHeader string) (crypto.PrivateKey, error) {
	trimmed := strings.TrimSpace(rawHeader)
	if trimmed == "" {
		return crypto.PrivateKey{}, fmt.Errorf("private key is required")
	}

	// Preferred format: hex private key (`0x...` supported).
	if key, err := crypto.PrivateKeyFromHex(trimmed); err == nil {
		return key, nil
	}

	// Fallback for clients that send non-hex seeds.
	return crypto.PrivateKeyFromSeed(trimmed), nil
}

func toElectionResponse(election *core.Election, includeCandidates bool) ElectionResponse {
	response := ElectionResponse{
		ID:          election.ID,
		Title:       election.Title,
		Description: election.Description,
		StartTime:   election.StartTime,
		EndTime:     election.EndTime,
		AdminKey:    election.AdminKey.String(),
		Status:      electionStatusToString(election.Status),
		Timestamp:   election.Timestamp,
		VoteCounts:  election.VoteCounts,
	}

	if includeCandidates {
		candidates := make([]CandidateResponse, 0, len(election.Candidates))
		for _, candidate := range election.Candidates {
			candidates = append(candidates, toCandidateResponse(candidate))
		}
		sort.Slice(candidates, func(i, j int) bool {
			return candidates[i].Timestamp > candidates[j].Timestamp
		})
		response.Candidates = candidates
	}

	return response
}

func toCandidateResponse(candidate *core.Candidate) CandidateResponse {
	return CandidateResponse{
		ID:              candidate.ID,
		ElectionID:      candidate.ElectionID,
		PublicKey:       candidate.PublicKey.String(),
		IPFSProfileHash: candidate.IPFSProfileHash,
		Status:          candidateStatusToString(candidate.Status),
		VoteCount:       candidate.VoteCount,
		Timestamp:       candidate.Timestamp,
	}
}

func electionStatusToString(status core.ElectionStatus) string {
	switch status {
	case core.ElectionStatusPending:
		return "pending"
	case core.ElectionStatusActive:
		return "active"
	case core.ElectionStatusEnded:
		return "ended"
	default:
		return "pending"
	}
}

func candidateStatusToString(status core.CandidateStatus) string {
	switch status {
	case core.CandidateStatusPending:
		return "pending"
	case core.CandidateStatusApproved:
		return "approved"
	case core.CandidateStatusRejected:
		return "rejected"
	default:
		return "pending"
	}
}

func intoJSONBlock(block *core.Block) Block {
	txResponse := TxResponse{
		TxCount: uint(len(block.Transactions)),
		Hashes:  make([]string, len(block.Transactions)),
	}

	for i := 0; i < int(txResponse.TxCount); i++ {
		txResponse.Hashes[i] = block.Transactions[i].Hash(core.TxHasher{}).String()
	}

	return Block{
		Hash:          block.Hash(core.BlockHasher{}).String(),
		Version:       block.Header.Version,
		Height:        block.Header.Height,
		DataHash:      block.Header.DataHash.String(),
		PrevBlockHash: block.Header.PrevBlockHash.String(),
		Timestamp:     block.Header.Timestamp,
		Validator:     block.Validator.Address().String(),
		Signature:     block.Signature.String(),
		TxResponse:    txResponse,
	}
}
