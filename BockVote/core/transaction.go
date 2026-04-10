package core

import (
	"encoding/gob"
	"fmt"
	"math/rand"

	"github.com/anthdm/projectx/crypto"
	"github.com/anthdm/projectx/types"
)

type TxType byte

const (
	TxTypeCollection            TxType = iota // 0x0
	TxTypeMint                                // 0x01
	TxTypeVoterRegistration                   // 0x02
	TxTypeCandidateRegistration               // 0x03
	TxTypeVote                                // 0x04
	TxTypeElectionCreation                    // 0x05
)

type CollectionTx struct {
	Fee      int64
	MetaData []byte
}

type MintTx struct {
	Fee             int64
	NFT             types.Hash
	Collection      types.Hash
	MetaData        []byte
	CollectionOwner crypto.PublicKey
	Signature       crypto.Signature
}

// VoterRegistrationTx represents a transaction to register as a voter
type VoterRegistrationTx struct {
	VoterID        string // Unique identifier for the voter (could be a hash of government ID)
	IPFSDocHash    string // IPFS hash to voter's identification document
	VoterPublicKey crypto.PublicKey
	Signature      crypto.Signature
	Timestamp      int64
}

// CandidateRegistrationTx represents a transaction to register as a candidate
type CandidateRegistrationTx struct {
	CandidateID        string // Unique identifier for the candidate
	ElectionID         string // ID of the election the candidate is registering for
	IPFSProfileHash    string // IPFS hash to candidate's profile/manifesto
	CandidatePublicKey crypto.PublicKey
	Signature          crypto.Signature
	Timestamp          int64
}

// VoteTx represents a transaction to cast a vote
type VoteTx struct {
	ElectionID     string // ID of the election being voted in
	CandidateID    string // ID of the candidate being voted for
	VoterPublicKey crypto.PublicKey
	Signature      crypto.Signature
	Timestamp      int64
}

// ElectionCreationTx represents a transaction to create a new election
type ElectionCreationTx struct {
	ElectionID     string // Unique identifier for the election
	Title          string // Title of the election
	Description    string // Description of the election
	StartTime      int64  // Unix timestamp for when voting starts
	EndTime        int64  // Unix timestamp for when voting ends
	AdminPublicKey crypto.PublicKey
	Signature      crypto.Signature
	Timestamp      int64
}

type Transaction struct {
	// Only used for native NFT logic
	TxInner any
	// Any arbitrary data for the VM
	Data      []byte
	To        crypto.PublicKey
	Value     uint64
	From      crypto.PublicKey
	Signature *crypto.Signature
	Nonce     int64

	// cached version of the tx data hash
	hash types.Hash
}

func NewTransaction(data []byte) *Transaction {
	return &Transaction{
		Data:  data,
		Nonce: rand.Int63n(1000000000000000),
	}
}

func (tx *Transaction) Hash(hasher Hasher[*Transaction]) types.Hash {
	if tx.hash.IsZero() {
		tx.hash = hasher.Hash(tx)
	}
	return tx.hash
}

func (tx *Transaction) Sign(privKey crypto.PrivateKey) error {
	hash := tx.Hash(TxHasher{})
	sig, err := privKey.Sign(hash.ToSlice())
	if err != nil {
		return err
	}

	tx.From = privKey.PublicKey()
	tx.Signature = sig

	return nil
}

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

func (tx *Transaction) Decode(dec Decoder[*Transaction]) error {
	return dec.Decode(tx)
}

func (tx *Transaction) Encode(enc Encoder[*Transaction]) error {
	return enc.Encode(tx)
}

func init() {
	gob.Register(CollectionTx{})
	gob.Register(MintTx{})
	gob.Register(VoterRegistrationTx{})
	gob.Register(CandidateRegistrationTx{})
	gob.Register(VoteTx{})
	gob.Register(ElectionCreationTx{})
}
