package crypto

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"errors"
	"encoding/hex"
	"io"
	"math/big"
	"strings"

	"github.com/anthdm/projectx/types"
)

type PrivateKey struct {
	key *ecdsa.PrivateKey
}

func (k PrivateKey) Sign(data []byte) (*Signature, error) {
	r, s, err := ecdsa.Sign(rand.Reader, k.key, data)
	if err != nil {
		return nil, err
	}

	return &Signature{
		R: r,
		S: s,
	}, nil
}

func NewPrivateKeyFromReader(r io.Reader) PrivateKey {
	key, err := ecdsa.GenerateKey(elliptic.P256(), r)
	if err != nil {
		panic(err)
	}

	return PrivateKey{
		key: key,
	}
}

func GeneratePrivateKey() PrivateKey {
	return NewPrivateKeyFromReader(rand.Reader)
}

// PrivateKeyFromHex builds a deterministic private key from a hex string.
// If the value is out of range for the curve order, it is normalized.
func PrivateKeyFromHex(hexKey string) (PrivateKey, error) {
	normalized := strings.TrimSpace(hexKey)
	normalized = strings.TrimPrefix(normalized, "0x")
	if normalized == "" {
		return PrivateKey{}, errors.New("empty private key")
	}

	keyBytes, err := hex.DecodeString(normalized)
	if err != nil {
		return PrivateKey{}, err
	}

	return privateKeyFromBytes(keyBytes), nil
}

// PrivateKeyFromSeed builds a deterministic private key from any seed string.
func PrivateKeyFromSeed(seed string) PrivateKey {
	hash := sha256.Sum256([]byte(seed))
	return privateKeyFromBytes(hash[:])
}

func privateKeyFromBytes(keyBytes []byte) PrivateKey {
	curve := elliptic.P256()
	curveOrder := curve.Params().N
	max := new(big.Int).Sub(curveOrder, big.NewInt(1))

	d := new(big.Int).SetBytes(keyBytes)
	d.Mod(d, max)
	d.Add(d, big.NewInt(1))

	private := &ecdsa.PrivateKey{
		PublicKey: ecdsa.PublicKey{
			Curve: curve,
		},
		D: d,
	}
	private.PublicKey.X, private.PublicKey.Y = curve.ScalarBaseMult(d.Bytes())

	return PrivateKey{key: private}
}

func (k PrivateKey) PublicKey() PublicKey {
	return elliptic.MarshalCompressed(k.key.PublicKey, k.key.PublicKey.X, k.key.PublicKey.Y)
}

type PublicKey []byte

func (k PublicKey) String() string {
	return hex.EncodeToString(k)
}

func (k PublicKey) Address() types.Address {
	h := sha256.Sum256(k)

	return types.AddressFromBytes(h[len(h)-20:])
}

type Signature struct {
	S *big.Int
	R *big.Int
}

func (sig Signature) String() string {
	b := append(sig.S.Bytes(), sig.R.Bytes()...)
	return hex.EncodeToString(b)
}

func (sig Signature) Verify(pubKey PublicKey, data []byte) bool {
	x, y := elliptic.UnmarshalCompressed(elliptic.P256(), pubKey)
	key := &ecdsa.PublicKey{
		Curve: elliptic.P256(),
		X:     x,
		Y:     y,
	}

	return ecdsa.Verify(key, data, sig.R, sig.S)
}
