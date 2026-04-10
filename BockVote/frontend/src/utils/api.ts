import axios from 'axios';
import { ethers } from 'ethers';

// API base URL
const API_BASE_URL = '/api';

// Interface for API responses
interface ApiResponse<T> {
  data: T;
  status: number;
}

// Voter registration request
export interface VoterRegistrationRequest {
  voterId: string;
  ipfsDocHash: string;
}

// Candidate registration request
export interface CandidateRegistrationRequest {
  candidateId: string;
  electionId: string;
  ipfsProfileHash: string;
}

// Election creation request
export interface ElectionCreationRequest {
  electionId: string;
  title: string;
  description: string;
  startTime: number;
  endTime: number;
}

// Vote request
export interface VoteRequest {
  electionId: string;
  candidateId: string;
}

// Approval request
export interface ApprovalRequest {
  id: string;
  electionId?: string;
  approve: boolean;
}

// Voter response
export interface VoterResponse {
  id: string;
  publicKey: string;
  ipfsDocHash: string;
  status: 'pending' | 'approved' | 'rejected';
  timestamp: number;
}

// Candidate response
export interface CandidateResponse {
  id: string;
  electionId: string;
  publicKey: string;
  ipfsProfileHash: string;
  status: 'pending' | 'approved' | 'rejected';
  voteCount: number;
  timestamp: number;
}

// Election response
export interface ElectionResponse {
  id: string;
  title: string;
  description: string;
  startTime: number;
  endTime: number;
  adminKey: string;
  status: 'pending' | 'active' | 'ended';
  timestamp: number;
  candidates?: CandidateResponse[];
  voteCounts?: Record<string, number>;
}

// Election results response
export interface ElectionResultsResponse {
  electionId: string;
  title: string;
  endTime: number;
  results: Record<string, number>;
  candidates: Record<string, string>;
}

// Transaction response
export interface TransactionResponse {
  status: string;
  txHash: string;
}

// Generate a random private key for testing purposes
// In a real app, this would be securely managed
export const generateRandomPrivateKey = (): string => {
  const wallet = ethers.Wallet.createRandom();
  return wallet.privateKey;
};

// API client
const apiClient = axios.create({
  baseURL: API_BASE_URL,
});

// Set the private key in the request header
export const setPrivateKey = (privateKey: string): void => {
  apiClient.defaults.headers.common['X-Private-Key'] = privateKey;
};

// Set the admin key in the request header
export const setAdminKey = (adminKey: string): void => {
  apiClient.defaults.headers.common['X-Admin-Key'] = adminKey;
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
  electionId: string,
  includeCandidates: boolean = false
): Promise<ApiResponse<ElectionResponse>> => {
  return await apiClient.get(
    `/voting/election/${electionId}${includeCandidates ? '?includeCandidates=true' : ''}`
  );
};

// Get election results
export const getElectionResults = async (
  electionId: string
): Promise<ApiResponse<ElectionResultsResponse>> => {
  return await apiClient.get(`/voting/election/${electionId}/results`);
};

// Get voter details
export const getVoter = async (
  voterId: string
): Promise<ApiResponse<VoterResponse>> => {
  return await apiClient.get(`/voting/voter/${voterId}`);
};

// Get candidate details
export const getCandidate = async (
  electionId: string,
  candidateId: string
): Promise<ApiResponse<CandidateResponse>> => {
  return await apiClient.get(`/voting/candidate/${electionId}/${candidateId}`);
};

// Approve or reject a voter
export const approveVoter = async (
  request: ApprovalRequest
): Promise<ApiResponse<{ status: string; action: string }>> => {
  return await apiClient.post('/voting/approve/voter', request);
};

// Approve or reject a candidate
export const approveCandidate = async (
  request: ApprovalRequest
): Promise<ApiResponse<{ status: string; action: string }>> => {
  return await apiClient.post('/voting/approve/candidate', request);
};

export default {
  registerVoter,
  registerCandidate,
  createElection,
  castVote,
  getElection,
  getElectionResults,
  getVoter,
  getCandidate,
  approveVoter,
  approveCandidate,
  setPrivateKey,
  setAdminKey,
  generateRandomPrivateKey,
}; 