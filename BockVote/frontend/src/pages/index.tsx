import React from 'react';
import Link from 'next/link';
import Head from 'next/head';

export default function Home() {
  return (
    <>
      <Head>
        <title>Decentralized Voting DApp - Home</title>
        <meta name="description" content="A secure and transparent voting platform built on a custom blockchain" />
      </Head>

      <div className="space-y-12">
        {/* Hero section */}
        <section className="text-center py-12">
          <h1 className="text-4xl md:text-5xl font-bold mb-6">
            Secure and Transparent Voting on the Blockchain
          </h1>
          <p className="text-xl md:text-2xl text-gray-600 max-w-3xl mx-auto mb-8">
            Our decentralized voting application ensures tamper-proof elections with real-time results and complete transparency.
          </p>
          <div className="flex flex-wrap justify-center gap-4">
            <Link href="/register" className="btn btn-primary text-lg px-8 py-3">
              Register to Vote
            </Link>
            <Link href="/elections" className="btn btn-secondary text-lg px-8 py-3">
              View Elections
            </Link>
          </div>
        </section>

        {/* Features section */}
        <section className="py-12 bg-primary-700 rounded-lg text-white">
          <div className="max-w-7xl mx-auto px-4">
            <h2 className="text-3xl font-bold text-center mb-12">Key Features</h2>
            <div className="grid md:grid-cols-3 gap-8">
              {/* Feature 1 */}
              <div className="bg-primary-800 rounded-lg shadow-md p-6 hover:bg-primary-900 transition-colors">
                <div className="text-white mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold mb-2">Secure Voting</h3>
                <p className="text-gray-200">
                  End-to-end encryption and blockchain technology ensure your vote is secure and tamper-proof.
                </p>
                <ul className="mt-3 text-sm text-gray-200 list-disc list-inside">
                  <li>Wallet-based authentication</li>
                  <li>Cryptographic vote signatures</li>
                  <li>Immutable ballot records</li>
                </ul>
              </div>

              {/* Feature 2 */}
              <div className="bg-primary-800 rounded-lg shadow-md p-6 hover:bg-primary-900 transition-colors">
                <div className="text-white mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold mb-2">Transparent Process</h3>
                <p className="text-gray-200">
                  All votes are recorded on a public blockchain, allowing for complete transparency and verification.
                </p>
                <ul className="mt-3 text-sm text-gray-200 list-disc list-inside">
                  <li>Public election data</li>
                  <li>Verifiable vote counts</li>
                  <li>Auditable election results</li>
                </ul>
              </div>

              {/* Feature 3 */}
              <div className="bg-primary-800 rounded-lg shadow-md p-6 hover:bg-primary-900 transition-colors">
                <div className="text-white mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold mb-2">Real-time Results</h3>
                <p className="text-gray-200">
                  View election results in real-time as votes are cast and verified on the blockchain.
                </p>
                <ul className="mt-3 text-sm text-gray-200 list-disc list-inside">
                  <li>Live vote tallying</li>
                  <li>Voter turnout statistics</li>
                  <li>Tamper-proof result hashes</li>
                </ul>
              </div>
            </div>
            
            {/* Additional Features */}
            <div className="grid md:grid-cols-3 gap-8 mt-10">
              {/* Feature 4 */}
              <div className="bg-primary-800 rounded-lg shadow-md p-6 hover:bg-primary-900 transition-colors">
                <div className="text-white mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold mb-2">Comprehensive Voter Registration</h3>
                <p className="text-gray-200">
                  Secure and thorough voter registration process with identity verification.
                </p>
                <ul className="mt-3 text-sm text-gray-200 list-disc list-inside">
                  <li>Aadhar/ID verification</li>
                  <li>Biometric authentication</li>
                  <li>Digital identity management</li>
                </ul>
              </div>

              {/* Feature 5 */}
              <div className="bg-primary-800 rounded-lg shadow-md p-6 hover:bg-primary-900 transition-colors">
                <div className="text-white mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold mb-2">Advanced Admin Controls</h3>
                <p className="text-gray-200">
                  Powerful tools for election administrators to manage the voting process.
                </p>
                <ul className="mt-3 text-sm text-gray-200 list-disc list-inside">
                  <li>Voter approval workflow</li>
                  <li>Election creation and management</li>
                  <li>Candidate registration system</li>
                </ul>
              </div>

              {/* Feature 6 */}
              <div className="bg-primary-800 rounded-lg shadow-md p-6 hover:bg-primary-900 transition-colors">
                <div className="text-white mb-4">
                  <svg xmlns="http://www.w3.org/2000/svg" className="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold mb-2">Cryptographic Key Management</h3>
                <p className="text-gray-200">
                  Secure management of cryptographic keys for voting and verification.
                </p>
                <ul className="mt-3 text-sm text-gray-200 list-disc list-inside">
                  <li>Public/private key pairs</li>
                  <li>Key status monitoring</li>
                  <li>Secure key storage</li>
                </ul>
              </div>
            </div>
          </div>
        </section>

        {/* How it works section */}
        <section className="py-12">
          <div className="max-w-7xl mx-auto px-4">
            <h2 className="text-3xl font-bold text-center mb-12">How It Works</h2>
            <div className="grid md:grid-cols-4 gap-6">
              {/* Step 1 */}
              <div className="text-center">
                <div className="bg-primary-100 text-primary-700 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4 text-2xl font-bold">
                  1
                </div>
                <h3 className="text-xl font-semibold mb-2">Register</h3>
                <p className="text-gray-600">
                  Create your secure voter identity with blockchain-backed verification.
                </p>
              </div>

              {/* Step 2 */}
              <div className="text-center">
                <div className="bg-primary-100 text-primary-700 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4 text-2xl font-bold">
                  2
                </div>
                <h3 className="text-xl font-semibold mb-2">Get Verified</h3>
                <p className="text-gray-600">
                  Election administrators verify your eligibility to participate.
                </p>
              </div>

              {/* Step 3 */}
              <div className="text-center">
                <div className="bg-primary-100 text-primary-700 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4 text-2xl font-bold">
                  3
                </div>
                <h3 className="text-xl font-semibold mb-2">Cast Your Vote</h3>
                <p className="text-gray-600">
                  Vote securely in active elections using your private key.
                </p>
              </div>

              {/* Step 4 */}
              <div className="text-center">
                <div className="bg-primary-100 text-primary-700 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4 text-2xl font-bold">
                  4
                </div>
                <h3 className="text-xl font-semibold mb-2">View Results</h3>
                <p className="text-gray-600">
                  Access transparent, tamper-proof election results in real-time.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* CTA section */}
        <section className="bg-primary-700 text-white rounded-lg p-8 text-center">
          <h2 className="text-3xl font-bold mb-4">Ready to participate?</h2>
          <p className="text-xl mb-6 max-w-2xl mx-auto">
            Join our secure voting platform today and make your voice heard in a transparent and tamper-proof way.
          </p>
          <Link href="/register" className="btn bg-white text-primary-700 hover:bg-gray-100 text-lg px-8 py-3">
            Get Started
          </Link>
        </section>
      </div>
    </>
  );
} 