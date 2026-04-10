# Decentralized Voting DApp Implementation Guide

This guide provides step-by-step instructions for implementing the decentralized voting application on the custom blockchain.

## Table of Contents

1. [Blockchain Modifications](#blockchain-modifications)
2. [Transaction Structure](#transaction-structure)
3. [API Layer](#api-layer)
4. [Frontend Integration](#frontend-integration)
5. [Security Measures](#security-measures)

## Blockchain Modifications

### 1. Define New Transaction Types

Add new transaction types to support voting operations:

```go
// In core/transaction.go
const (
    TxTypeCollection TxType = iota // 0x0
    TxTypeMint                     // 0x01
    TxTypeVoterRegistration        // 0x02
    TxTypeCandidateRegistration    // 0x03
    TxTypeVote                     // 0x04
    TxTypeElectionCreation         // 0x05
)
```

### 2. Create Transaction Structures

Define the structure for each voting transaction type:

```go
// VoterRegistrationTx represents a transaction to register as a voter
type VoterRegistrationTx struct {
    VoterID        string       // Unique identifier for the voter
    IPFSDocHash    string       // IPFS hash to voter's identification document
    VoterPublicKey crypto.PublicKey
    Signature      crypto.Signature
    Timestamp      int64
}

// CandidateRegistrationTx represents a transaction to register as a candidate
type CandidateRegistrationTx struct {
    CandidateID        string       // Unique identifier for the candidate
    ElectionID         string       // ID of the election the candidate is registering for
    IPFSProfileHash    string       // IPFS hash to candidate's profile/manifesto
    CandidatePublicKey crypto.PublicKey
    Signature          crypto.Signature
    Timestamp          int64
}

// VoteTx represents a transaction to cast a vote
type VoteTx struct {
    ElectionID     string       // ID of the election being voted in
    CandidateID    string       // ID of the candidate being voted for
    VoterPublicKey crypto.PublicKey
    Signature      crypto.Signature
    Timestamp      int64
}

// ElectionCreationTx represents a transaction to create a new election
type ElectionCreationTx struct {
    ElectionID      string       // Unique identifier for the election
    Title           string       // Title of the election
    Description     string       // Description of the election
    StartTime       int64        // Unix timestamp for when voting starts
    EndTime         int64        // Unix timestamp for when voting ends
    AdminPublicKey  crypto.PublicKey
    Signature       crypto.Signature
    Timestamp       int64
}
```

### 3. Implement Voting State Management

Create a new file `core/voting_state.go` to manage the voting-related state:

```go
// VotingState manages the state of voting-related data
type VotingState struct {
    mu        sync.RWMutex
    voters    map[string]*Voter               // VoterID -> Voter
    elections map[string]*Election            // ElectionID -> Election
    hasVoted  map[string]map[string]bool      // ElectionID -> VoterID -> has voted
}
```

Implement methods for managing voters, candidates, elections, and votes.

### 4. Integrate with Blockchain

Update the blockchain structure to include the voting state:

```go
// In core/blockchain.go
type Blockchain struct {
    // Existing fields
    votingState *VotingState
    // Other fields
}
```

Modify the `NewBlockchain` function to initialize the voting state:

```go
func NewBlockchain(l log.Logger, genesis *Block) (*Blockchain, error) {
    // Existing code
    bc := &Blockchain{
        // Existing fields
        votingState: NewVotingState(),
        // Other fields
    }
    // Rest of the function
}
```

### 5. Handle Voting Transactions

Update the `handleNativeNFT` function to handle voting transactions:

```go
func (bc *Blockchain) handleNativeNFT(tx *Transaction) error {
    hash := tx.Hash(TxHasher{})

    switch t := tx.TxInner.(type) {
    // Existing cases
    case VoterRegistrationTx:
        if err := bc.votingState.RegisterVoter(&t); err != nil {
            return err
        }
        bc.logger.Log("msg", "registered new voter", "voterID", t.VoterID)
    case CandidateRegistrationTx:
        if err := bc.votingState.RegisterCandidate(&t); err != nil {
            return err
        }
        bc.logger.Log("msg", "registered new candidate", "candidateID", t.CandidateID, "electionID", t.ElectionID)
    case VoteTx:
        if err := bc.votingState.CastVote(&t); err != nil {
            return err
        }
        bc.logger.Log("msg", "cast vote", "electionID", t.ElectionID, "candidateID", t.CandidateID)
    case ElectionCreationTx:
        if err := bc.votingState.CreateElection(&t); err != nil {
            return err
        }
        bc.logger.Log("msg", "created new election", "electionID", t.ElectionID, "title", t.Title)
    default:
        return fmt.Errorf("unsupported tx type %v", t)
    }

    return nil
}
```

### 6. Update Election Statuses

Add code to update election statuses after each block:

```go
func (bc *Blockchain) addBlockWithoutValidation(b *Block) error {
    // Existing code
    
    // Update election statuses after each block
    bc.votingState.UpdateElectionStatuses()
    
    return bc.store.Put(b)
}
```

## Transaction Structure

### Voter Registration Transaction

```json
{
  "TxInner": {
    "VoterID": "voter123",
    "IPFSDocHash": "QmXoypizjW3WknFiJnKLwHCnL72vedxjQkDDP1mXWo6uco",
    "VoterPublicKey": "...",
    "Timestamp": 1623456789
  },
  "From": "...",
  "Signature": "..."
}
```

### Candidate Registration Transaction

```json
{
  "TxInner": {
    "CandidateID": "candidate456",
    "ElectionID": "election789",
    "IPFSProfileHash": "QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG",
    "CandidatePublicKey": "...",
    "Timestamp": 1623456790
  },
  "From": "...",
  "Signature": "..."
}
```

### Vote Transaction

```json
{
  "TxInner": {
    "ElectionID": "election789",
    "CandidateID": "candidate456",
    "VoterPublicKey": "...",
    "Timestamp": 1623456791
  },
  "From": "...",
  "Signature": "..."
}
```

### Election Creation Transaction

```json
{
  "TxInner": {
    "ElectionID": "election789",
    "Title": "Presidential Election 2023",
    "Description": "Election for the next president",
    "StartTime": 1623456792,
    "EndTime": 1623556792,
    "AdminPublicKey": "...",
    "Timestamp": 1623456793
  },
  "From": "...",
  "Signature": "..."
}
```

## API Layer

### 1. Define API Response Types

Create response types for the API:

```go
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
    ID             string `json:"id"`
    ElectionID     string `json:"electionId"`
    PublicKey      string `json:"publicKey"`
    IPFSProfileHash string `json:"ipfsProfileHash"`
    Status         string `json:"status"`
    VoteCount      uint64 `json:"voteCount"`
    Timestamp      int64  `json:"timestamp"`
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
```

### 2. Implement API Endpoints

Add new endpoints to the API server:

```go
func (s *Server) Start() error {
    e := echo.New()

    // Existing endpoints
    e.GET("/block/:hashorid", s.handleGetBlock)
    e.GET("/tx/:hash", s.handleGetTx)
    e.POST("/tx", s.handlePostTx)

    // Voting API endpoints
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
```

### 3. Implement Request Handlers

Implement handlers for each endpoint:

```go
// handleRegisterVoter handles voter registration requests
func (s *Server) handleRegisterVoter(c echo.Context) error {
    var req VoterRegistrationRequest
    if err := json.NewDecoder(c.Request().Body).Decode(&req); err != nil {
        return c.JSON(http.StatusBadRequest, APIError{Error: err.Error()})
    }

    // Get the private key from the request header
    privKeyHex := c.Request().Header.Get("X-Private-Key")
    if privKeyHex == "" {
        return c.JSON(http.StatusBadRequest, APIError{Error: "private key is required"})
    }

    // TODO: Implement proper key handling
    privKey := crypto.GeneratePrivateKey() // Replace with actual key from header

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
```

Implement similar handlers for other endpoints.

## Frontend Integration

### 1. Set Up API Client

Create an API client to interact with the blockchain:

```typescript
// src/utils/api.ts
import axios from 'axios';

// API base URL
const API_BASE_URL = '/api';

// API client
const apiClient = axios.create({
  baseURL: API_BASE_URL,
});

// Set the private key in the request header
export const setPrivateKey = (privateKey: string): void => {
  apiClient.defaults.headers.common['X-Private-Key'] = privateKey;
};

// Register a voter
export const registerVoter = async (
  request: VoterRegistrationRequest
): Promise<ApiResponse<TransactionResponse>> => {
  return await apiClient.post('/voting/register/voter', request);
};

// Other API functions...
```

### 2. Implement Key Management

Create utilities for key management:

```typescript
// src/utils/keyManager.ts
import { ethers } from 'ethers';

// Generate a new key pair
export const generateKeyPair = (): { privateKey: string; publicKey: string } => {
  const wallet = ethers.Wallet.createRandom();
  return {
    privateKey: wallet.privateKey,
    publicKey: wallet.address,
  };
};

// Save a key to local storage
export const saveKey = (
  privateKey: string,
  type: KeyType,
  label: string
): void => {
  // Implementation...
};

// Other key management functions...
```

### 3. Implement IPFS Integration

Create utilities for IPFS document storage:

```typescript
// src/utils/ipfs.ts
import { create } from 'ipfs-http-client';

// Upload a file to IPFS
export const uploadToIPFS = async (file: File): Promise<string> => {
  try {
    const fileAdded = await ipfsClient.add(file);
    return fileAdded.path;
  } catch (error) {
    console.error('Error uploading file to IPFS:', error);
    throw error;
  }
};

// Other IPFS functions...
```

### 4. Create UI Components

Implement UI components for the application:

- Layout component
- Voter registration form
- Candidate registration form
- Election creation form
- Voting interface
- Election results display
- Admin dashboard

## Security Measures

### 1. Double Voting Prevention

The blockchain state tracks whether a voter has already voted in an election:

```go
// CastVote records a vote for a candidate
func (vs *VotingState) CastVote(tx *VoteTx) error {
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
```

### 2. Replay Attack Prevention

All transactions include timestamps and nonces:

```go
// Transaction structure includes nonce
type Transaction struct {
    // Other fields
    Nonce     int64
    // Other fields
}

// Transaction constructor generates a random nonce
func NewTransaction(data []byte) *Transaction {
    return &Transaction{
        Data:  data,
        Nonce: rand.Int63n(1000000000000000),
    }
}
```

### 3. Signature Verification

All transactions are signed and verified:

```go
func (tx *Transaction) Verify() error {
    if tx.Signature == nil {
        return fmt.Errorf("transaction has no signature")
    }

    hash := tx.Hash(TxHasher{})
    if !tx.Signature.Verify(tx.From, hash.ToSlice()) {
        return fmt.Errorf("invalid transaction signature")
    }

    return nil
}
```

### 4. Secure Key Management

The frontend securely manages keys:

```typescript
// Sign a message with a private key
export const signMessage = async (
  privateKey: string,
  message: string
): Promise<string> => {
  const wallet = new ethers.Wallet(privateKey);
  return await wallet.signMessage(message);
};

// Verify a signature
export const verifySignature = (
  publicKey: string,
  message: string,
  signature: string
): boolean => {
  try {
    const recoveredAddress = ethers.verifyMessage(message, signature);
    return recoveredAddress.toLowerCase() === publicKey.toLowerCase();
  } catch (error) {
    console.error('Error verifying signature:', error);
    return false;
  }
};
```

### 5. Access Control

Implement access control for admin operations:

```go
// ApproveCandidate approves a candidate registration
func (vs *VotingState) ApproveCandidate(electionID, candidateID string, adminKey crypto.PublicKey) error {
    // Verify admin key
    if election.AdminKey.String() != adminKey.String() {
        return fmt.Errorf("unauthorized: only the election admin can approve candidates")
    }
    
    // Approve candidate
    candidate.Status = CandidateStatusApproved
    return nil
}
```

## Conclusion

This implementation guide provides a comprehensive approach to building a decentralized voting application on a custom blockchain. By following these steps, you can create a secure, transparent, and tamper-proof voting platform that leverages the benefits of blockchain technology. 