# Decentralized Voting DApp on Custom Blockchain

This project implements a decentralized voting application (DApp) built on a custom blockchain. It provides a secure, transparent, and tamper-proof platform for conducting elections.

## Project Structure

The project consists of two main components:

1. **Custom Blockchain** - A validator-based Proof of Authority (PoA) blockchain with voting-specific functionality
2. **Frontend Application** - A Next.js/React application for interacting with the blockchain

## Custom Blockchain Features

- **Consensus**: Validator-based Proof of Authority (PoA)
- **Transaction Types**: Native token transfers and custom transaction formats for voting operations
- **VM**: Basic virtual machine for executing simple smart contracts
- **API Layer**: JSON RPC endpoints for interaction
- **Key Management**: ECDSA (P-256) for digital signatures

## Voting DApp Features

- **User Roles**:
  - **Voters**: Register, get approved, cast votes
  - **Candidates**: Register, get approved, receive votes
  - **Election Admin**: Approve/reject participants, set voting period, view results

- **Core Functionality**:
  - Secure voter/candidate registration
  - Tamper-proof vote casting
  - Real-time results tracking
  - IPFS for document storage (e.g., voter IDs, candidate profiles)

## Technical Stack

- **Backend**: Go-based custom blockchain
- **Frontend**: Next.js/React with TypeScript and Tailwind CSS
- **Storage**: IPFS via Pinata
- **Cryptography**: ECDSA (P-256) for digital signatures

## Getting Started

### Prerequisites

- Go 1.16+
- Node.js 16+
- npm or yarn

### Running the Blockchain

1. Start the blockchain nodes:
   ```
   cd projectx
   go run main.go
   ```

2. This will start a local blockchain network with multiple nodes.

### Running the Frontend

1. Navigate to the frontend directory:
   ```
   cd projectx/frontend
   ```

2. Install dependencies:
   ```
   npm install
   # or
   yarn install
   ```

3. Start the development server:
   ```
   npm run dev
   # or
   yarn dev
   ```

4. Open [http://localhost:3000](http://localhost:3000) in your browser to see the application.

## API Endpoints

The blockchain exposes the following API endpoints for the voting DApp:

- **Voter Registration**: `/voting/register/voter`
- **Candidate Registration**: `/voting/register/candidate`
- **Election Creation**: `/voting/election/create`
- **Vote Casting**: `/voting/vote`
- **Election Details**: `/voting/election/:id`
- **Election Results**: `/voting/election/:id/results`
- **Voter Details**: `/voting/voter/:id`
- **Candidate Details**: `/voting/candidate/:electionId/:id`
- **Voter Approval**: `/voting/approve/voter`
- **Candidate Approval**: `/voting/approve/candidate`

## Security Measures

- **Double Voting Prevention**: The blockchain state tracks votes to prevent double voting
- **Replay Attack Prevention**: Transactions include timestamps and nonces
- **Tamper-Proof Records**: All votes are stored on the immutable blockchain
- **Secure Identity Management**: ECDSA key pairs for voter and candidate identification
- **Document Verification**: IPFS for secure storage of verification documents

## License

This project is licensed under the MIT License - see the LICENSE file for details.
