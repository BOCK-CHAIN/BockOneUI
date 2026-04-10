import React, { useState } from 'react';
import Head from 'next/head';
import axios from 'axios';
import { toast } from 'react-toastify';
import {
  generateRandomPrivateKey,
  registerCandidate,
  registerVoter,
  setPrivateKey,
} from '@/utils/api';

type RegistrationType = 'voter' | 'candidate';

const getErrorMessage = (error: unknown): string => {
  if (axios.isAxiosError(error)) {
    const apiMessage = error.response?.data?.error;
    if (typeof apiMessage === 'string' && apiMessage.length > 0) {
      return apiMessage;
    }

    if (typeof error.message === 'string' && error.message.length > 0) {
      return error.message;
    }
  }

  if (error instanceof Error && error.message.length > 0) {
    return error.message;
  }

  return 'Something went wrong while registering.';
};

export default function RegisterPage() {
  const [registrationType, setRegistrationType] = useState<RegistrationType>('voter');
  const [privateKey, setPrivateKeyValue] = useState('');
  const [voterId, setVoterId] = useState('');
  const [ipfsDocHash, setIpfsDocHash] = useState('');
  const [candidateId, setCandidateId] = useState('');
  const [electionId, setElectionId] = useState('');
  const [ipfsProfileHash, setIpfsProfileHash] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const generatePrivateKey = () => {
    setPrivateKeyValue(generateRandomPrivateKey());
    toast.info('Generated a new private key for this session.');
  };

  const submitRegistration = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    const trimmedPrivateKey = privateKey.trim();
    if (!trimmedPrivateKey) {
      toast.error('Private key is required.');
      return;
    }

    setIsSubmitting(true);

    try {
      setPrivateKey(trimmedPrivateKey);

      if (registrationType === 'voter') {
        const response = await registerVoter({
          voterId: voterId.trim(),
          ipfsDocHash: ipfsDocHash.trim(),
        });
        toast.success(`Voter registration submitted. Tx: ${response.data.txHash}`);
        setVoterId('');
        setIpfsDocHash('');
      } else {
        const response = await registerCandidate({
          candidateId: candidateId.trim(),
          electionId: electionId.trim(),
          ipfsProfileHash: ipfsProfileHash.trim(),
        });
        toast.success(`Candidate registration submitted. Tx: ${response.data.txHash}`);
        setCandidateId('');
        setElectionId('');
        setIpfsProfileHash('');
      }
    } catch (error) {
      toast.error(getErrorMessage(error));
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <>
      <Head>
        <title>Register | Bock Vote</title>
        <meta name="description" content="Register as a voter or candidate on Bock Vote." />
      </Head>

      <section className="max-w-3xl mx-auto">
        <div className="card space-y-6">
          <div>
            <h1 className="text-3xl font-bold">Registration</h1>
            <p className="text-gray-600 mt-2">
              Submit a voter or candidate registration transaction to the blockchain.
            </p>
          </div>

          <div className="flex flex-wrap gap-3">
            <button
              type="button"
              onClick={() => setRegistrationType('voter')}
              className={`btn ${
                registrationType === 'voter' ? 'btn-primary' : 'btn-secondary'
              }`}
            >
              Voter
            </button>
            <button
              type="button"
              onClick={() => setRegistrationType('candidate')}
              className={`btn ${
                registrationType === 'candidate' ? 'btn-primary' : 'btn-secondary'
              }`}
            >
              Candidate
            </button>
          </div>

          <form className="space-y-4" onSubmit={submitRegistration}>
            <div>
              <label className="label" htmlFor="private-key">
                Private Key
              </label>
              <textarea
                id="private-key"
                className="input min-h-24"
                value={privateKey}
                onChange={(event) => setPrivateKeyValue(event.target.value)}
                placeholder="0x..."
                required
              />
              <div className="mt-2">
                <button type="button" className="btn btn-secondary" onClick={generatePrivateKey}>
                  Generate Random Key
                </button>
              </div>
            </div>

            {registrationType === 'voter' ? (
              <>
                <div>
                  <label className="label" htmlFor="voter-id">
                    Voter ID
                  </label>
                  <input
                    id="voter-id"
                    className="input"
                    value={voterId}
                    onChange={(event) => setVoterId(event.target.value)}
                    placeholder="voter-001"
                    required
                  />
                </div>
                <div>
                  <label className="label" htmlFor="voter-ipfs-doc">
                    IPFS Document Hash
                  </label>
                  <input
                    id="voter-ipfs-doc"
                    className="input"
                    value={ipfsDocHash}
                    onChange={(event) => setIpfsDocHash(event.target.value)}
                    placeholder="Qm..."
                    required
                  />
                </div>
              </>
            ) : (
              <>
                <div>
                  <label className="label" htmlFor="candidate-id">
                    Candidate ID
                  </label>
                  <input
                    id="candidate-id"
                    className="input"
                    value={candidateId}
                    onChange={(event) => setCandidateId(event.target.value)}
                    placeholder="candidate-001"
                    required
                  />
                </div>
                <div>
                  <label className="label" htmlFor="election-id">
                    Election ID
                  </label>
                  <input
                    id="election-id"
                    className="input"
                    value={electionId}
                    onChange={(event) => setElectionId(event.target.value)}
                    placeholder="election-2026"
                    required
                  />
                </div>
                <div>
                  <label className="label" htmlFor="candidate-ipfs-profile">
                    IPFS Profile Hash
                  </label>
                  <input
                    id="candidate-ipfs-profile"
                    className="input"
                    value={ipfsProfileHash}
                    onChange={(event) => setIpfsProfileHash(event.target.value)}
                    placeholder="Qm..."
                    required
                  />
                </div>
              </>
            )}

            <button type="submit" className="btn btn-primary" disabled={isSubmitting}>
              {isSubmitting ? 'Submitting...' : `Register as ${registrationType}`}
            </button>
          </form>
        </div>
      </section>
    </>
  );
}
