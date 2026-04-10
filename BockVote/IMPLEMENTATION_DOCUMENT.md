# Decentralized Voting DApp - Implementation Document

## 1. Introduction

This document provides a comprehensive guide for implementing a decentralized voting application (DApp) built on a custom blockchain. The system offers a secure, transparent, and tamper-proof platform for conducting elections with the following key features:

- Validator-based Proof of Authority (PoA) consensus mechanism
- Specialized transaction types for voting operations
- Secure voter and candidate registration with approval workflows
- Tamper-proof vote casting and real-time results
- IPFS integration for document storage and verification

## 2. System Architecture

### 2.1 Core Components

1. **Custom Blockchain (Go)**
   - PoA consensus with pre-selected validators
   - Custom transaction types for voting operations
   - State management for accounts, voting, and elections
   - Virtual machine for simple smart contract execution

2. **Frontend Application (Next.js/React)**
   - Modern UI with Tailwind CSS
   - Role-based interfaces (voter, candidate, admin)
   - Key management and transaction signing

3. **Network Layer**
   - P2P networking with TCP transport
   - Transaction and block propagation
   - Node discovery and synchronization

4. **API Layer**
   - RESTful JSON-RPC endpoints
   - Voting-specific API routes
   - Transaction submission and querying

### 2.2 Technical Stack

- **Backend**: Go 1.18+, Echo framework
- **Frontend**: Next.js 14+, TypeScript, Tailwind CSS
- **Cryptography**: ECDSA P-256
- **Storage**: IPFS via Pinata
- **Networking**: Custom TCP-based P2P protocol

## 3. Blockchain Implementation

### 3.1 Transaction Types

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

### 3.2 Transaction Structures

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

### 3.3 Voting State Management

```go
// VotingState manages the state of voting-related data
type VotingState struct {
    mu        sync.RWMutex
    voters    map[string]*Voter               // VoterID -> Voter
    elections map[string]*Election            // ElectionID -> Election
    hasVoted  map[string]map[string]bool      // ElectionID -> VoterID -> has voted
}

// Voter represents a registered voter
type Voter struct {
    ID          string
    PublicKey   crypto.PublicKey
    IPFSDocHash string
    Status      VoterStatus
    Timestamp   int64
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
    Candidates  map[string]*Candidate
    VoteCounts  map[string]uint64  // CandidateID -> vote count
    Timestamp   int64
}

// Candidate represents a registered candidate
type Candidate struct {
    ID             string
    ElectionID     string
    PublicKey      crypto.PublicKey
    IPFSProfileHash string
    Status         CandidateStatus
    VoteCount      uint64
    Timestamp      int64
}
```

### 3.4 Blockchain Integration

```go
// In core/blockchain.go
type Blockchain struct {
    // Existing fields
    votingState *VotingState
    // Other fields
}

// Handle voting transactions
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

## 4. API Layer Implementation

### 4.1 API Response Types

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

### 4.2 API Endpoints

```go
func (s *Server) Start() error {
    e := echo.New()

    // Core blockchain endpoints
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

### 4.3 Request Handler Example

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

    // Parse the private key
    privKey, err := crypto.PrivateKeyFromHex(privKeyHex)
    if err != nil {
        return c.JSON(http.StatusBadRequest, APIError{Error: "invalid private key"})
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
```

## 5. Frontend Implementation

### 5.1 API Client

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

// Register a candidate
export const registerCandidate = async (
  request: CandidateRegistrationRequest
): Promise<ApiResponse<TransactionResponse>> => {
  return await apiClient.post('/voting/register/candidate', request);
};

// Create an election
export const createElection = async (
  request: ElectionCreationRequest
): Promise<ApiResponse<TransactionResponse>> => {
  return await apiClient.post('/voting/election/create', request);
};

// Cast a vote
export const castVote = async (
  request: VoteRequest
): Promise<ApiResponse<TransactionResponse>> => {
  return await apiClient.post('/voting/vote', request);
};

// Get election details
export const getElection = async (
  electionId: string
): Promise<ApiResponse<ElectionResponse>> => {
  return await apiClient.get(`/voting/election/${electionId}`);
};

// Get election results
export const getElectionResults = async (
  electionId: string
): Promise<ApiResponse<ElectionResultsResponse>> => {
  return await apiClient.get(`/voting/election/${electionId}/results`);
};
```

### 5.2 Key Management

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
  const keys = loadKeys();
  keys.push({
    privateKey,
    publicKey: getPublicKey(privateKey),
    type,
    label,
    createdAt: new Date().toISOString(),
  });
  localStorage.setItem('keys', JSON.stringify(keys));
};

// Load keys from local storage
export const loadKeys = (): KeyPair[] => {
  const keysStr = localStorage.getItem('keys');
  if (!keysStr) {
    return [];
  }
  return JSON.parse(keysStr);
};

// Get public key from private key
export const getPublicKey = (privateKey: string): string => {
  const wallet = new ethers.Wallet(privateKey);
  return wallet.address;
};

// Sign a message with a private key
export const signMessage = async (
  privateKey: string,
  message: string
): Promise<string> => {
  const wallet = new ethers.Wallet(privateKey);
  return await wallet.signMessage(message);
};
```

### 5.3 IPFS Integration

```typescript
// src/utils/ipfs.ts
import { create } from 'ipfs-http-client';

// Configure IPFS client with Pinata
const ipfsClient = create({
  host: 'api.pinata.cloud',
  port: 443,
  protocol: 'https',
  headers: {
    pinata_api_key: process.env.NEXT_PUBLIC_PINATA_API_KEY!,
    pinata_secret_api_key: process.env.NEXT_PUBLIC_PINATA_SECRET_API_KEY!,
  },
});

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

// Get a file from IPFS
export const getFromIPFS = (hash: string): string => {
  return `https://gateway.pinata.cloud/ipfs/${hash}`;
};
```

## 6. Security Measures

### 6.1 Double Voting Prevention

```go
// CastVote records a vote for a candidate
func (vs *VotingState) CastVote(tx *VoteTx) error {
    vs.mu.Lock()
    defer vs.mu.Unlock()
    
    // Extract voter ID from public key
    voterID := tx.VoterPublicKey.Address().String()
    
    // Check if voter has already voted in this election
    if vs.hasVoted[tx.ElectionID][voterID] {
        return fmt.Errorf("voter has already cast a vote in this election")
    }
    
    // Get the election
    election, exists := vs.elections[tx.ElectionID]
    if !exists {
        return fmt.Errorf("election not found: %s", tx.ElectionID)
    }
    
    // Check if election is active
    if election.Status != ElectionStatusActive {
        return fmt.Errorf("election is not active")
    }
    
    // Get the candidate
    candidate, exists := election.Candidates[tx.CandidateID]
    if !exists {
        return fmt.Errorf("candidate not found: %s", tx.CandidateID)
    }
    
    // Check if candidate is approved
    if candidate.Status != CandidateStatusApproved {
        return fmt.Errorf("candidate is not approved")
    }
    
    // Record the vote
    election.VoteCounts[tx.CandidateID]++
    candidate.VoteCount++
    
    // Mark that the voter has voted
    if vs.hasVoted[tx.ElectionID] == nil {
        vs.hasVoted[tx.ElectionID] = make(map[string]bool)
    }
    vs.hasVoted[tx.ElectionID][voterID] = true
    
    return nil
}
```

### 6.2 Replay Attack Prevention

```go
// Transaction structure includes nonce and timestamp
type Transaction struct {
    Data      []byte
    From      crypto.PublicKey
    Signature *crypto.Signature
    Nonce     int64
    Timestamp int64
}

// Transaction constructor generates a random nonce
func NewTransaction(data []byte) *Transaction {
    return &Transaction{
        Data:      data,
        Nonce:     rand.Int63n(1000000000000000),
        Timestamp: time.Now().Unix(),
    }
}

// Validate transaction
func (tx *Transaction) Validate() error {
    // Check if transaction is expired (older than 10 minutes)
    if time.Now().Unix()-tx.Timestamp > 600 {
        return fmt.Errorf("transaction expired")
    }
    
    // Other validation...
    return nil
}
```

### 6.3 Signature Verification

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

### 6.4 Access Control

```go
// ApproveVoter approves a voter registration
func (vs *VotingState) ApproveVoter(voterID string, adminKey crypto.PublicKey) error {
    vs.mu.Lock()
    defer vs.mu.Unlock()
    
    // Verify admin key
    if !isAdmin(adminKey) {
        return fmt.Errorf("unauthorized: only admins can approve voters")
    }
    
    // Get the voter
    voter, exists := vs.voters[voterID]
    if !exists {
        return fmt.Errorf("voter not found: %s", voterID)
    }
    
    // Approve voter
    voter.Status = VoterStatusApproved
    return nil
}

// ApproveCandidate approves a candidate registration
func (vs *VotingState) ApproveCandidate(electionID, candidateID string, adminKey crypto.PublicKey) error {
    vs.mu.Lock()
    defer vs.mu.Unlock()
    
    // Get the election
    election, exists := vs.elections[electionID]
    if !exists {
        return fmt.Errorf("election not found: %s", electionID)
    }
    
    // Verify admin key
    if election.AdminKey.String() != adminKey.String() {
        return fmt.Errorf("unauthorized: only the election admin can approve candidates")
    }
    
    // Get the candidate
    candidate, exists := election.Candidates[candidateID]
    if !exists {
        return fmt.Errorf("candidate not found: %s", candidateID)
    }
    
    // Approve candidate
    candidate.Status = CandidateStatusApproved
    return nil
}
```

## 7. Deployment and Setup

### 7.1 Prerequisites

- Go 1.18+
- Node.js 16+
- npm or yarn

### 7.2 Backend Setup

```bash
# Clone the repository
git clone https://github.com/your-org/projectx.git
cd projectx

# Install Go dependencies
go mod download

# Run the blockchain network
go run main.go
```

### 7.3 Frontend Setup

```bash
# Navigate to the frontend directory
cd frontend

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env.local
# Edit .env.local with your Pinata API keys

# Start the development server
npm run dev
```

### 7.4 Network Configuration

The blockchain network is configured in `main.go` to run with:
- Local node (validator) on port 3000
- Remote nodes on ports 4000, 5000, 6000
- API server on port 9000

## 8. Testing and Verification

### 8.1 Backend Tests

```bash
# Run all tests
go test ./...

# Run specific tests
go test ./core -v
go test ./network -v
```

### 8.2 Frontend Tests

```bash
# Run frontend tests
cd frontend
npm test
```

### 8.3 End-to-End Testing

1. Start the blockchain network
2. Start the frontend application
3. Register as a voter
4. Register as a candidate
5. Create an election
6. Approve voter and candidate
7. Cast votes
8. View election results

## 9. Future Enhancements

1. **Smart Contract Support**: Extend VM to support complex voting rules
2. **Multi-language Support**: Internationalization for the frontend
3. **Mobile Application**: Native mobile apps for iOS and Android
4. **Advanced Analytics**: Real-time analytics and reporting dashboard
5. **External Identity Integration**: OAuth and other identity providers

## 10. Conclusion

This implementation document provides a comprehensive guide for building a decentralized voting application on a custom blockchain. The system offers a secure, transparent, and tamper-proof platform for conducting elections with robust security measures and a user-friendly interface.