import { ethers } from 'ethers';

// Key types
export enum KeyType {
  VOTER = 'voter',
  CANDIDATE = 'candidate',
  ADMIN = 'admin',
}

// Interface for stored key
interface StoredKey {
  privateKey: string;
  publicKey: string;
  type: KeyType;
  label: string;
}

// Local storage key
const STORAGE_KEY = 'voting_dapp_keys';

// Generate a new key pair
export const generateKeyPair = (): { privateKey: string; publicKey: string } => {
  const wallet = ethers.Wallet.createRandom();
  return {
    privateKey: wallet.privateKey,
    publicKey: wallet.address, // Using Ethereum address as public key for simplicity
  };
};

// Save a key to local storage
export const saveKey = (
  privateKey: string,
  type: KeyType,
  label: string
): void => {
  // Generate public key from private key
  const wallet = new ethers.Wallet(privateKey);
  const publicKey = wallet.address;

  // Get existing keys
  const keys = getKeys();

  // Add new key
  keys.push({
    privateKey,
    publicKey,
    type,
    label,
  });

  // Save to local storage
  localStorage.setItem(STORAGE_KEY, JSON.stringify(keys));
};

// Get all stored keys
export const getKeys = (): StoredKey[] => {
  const keysStr = localStorage.getItem(STORAGE_KEY);
  if (!keysStr) {
    return [];
  }
  return JSON.parse(keysStr);
};

// Get keys by type
export const getKeysByType = (type: KeyType): StoredKey[] => {
  const keys = getKeys();
  return keys.filter((key) => key.type === type);
};

// Get a key by public key
export const getKeyByPublicKey = (publicKey: string): StoredKey | undefined => {
  const keys = getKeys();
  return keys.find((key) => key.publicKey === publicKey);
};

// Delete a key
export const deleteKey = (publicKey: string): void => {
  let keys = getKeys();
  keys = keys.filter((key) => key.publicKey !== publicKey);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(keys));
};

// Clear all keys
export const clearKeys = (): void => {
  localStorage.removeItem(STORAGE_KEY);
};

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

export default {
  generateKeyPair,
  saveKey,
  getKeys,
  getKeysByType,
  getKeyByPublicKey,
  deleteKey,
  clearKeys,
  signMessage,
  verifySignature,
  KeyType,
}; 