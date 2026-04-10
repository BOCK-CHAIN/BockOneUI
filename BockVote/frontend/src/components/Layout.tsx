import React from 'react';
import Head from 'next/head';
import Link from 'next/link';
import Image from 'next/image';
import { useRouter } from 'next/router';

interface LayoutProps {
  children: React.ReactNode;
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
  const router = useRouter();
  
  // Navigation items
  const navItems = [
    { name: 'Home', path: '/' },
    { name: 'Elections', path: '/elections' },
    { name: 'Register', path: '/register' },
    { name: 'Admin', path: '/admin' },
    { name: 'Keys', path: '/keys' },
  ];

  return (
    <>
      <Head>
        <title>Decentralized Voting DApp</title>
        <meta name="description" content="A decentralized voting application built on a custom blockchain" />
        <link rel="icon" href="/logo.svg" />
      </Head>

      <div className="min-h-screen flex flex-col">
        {/* Header */}
        <header className="bg-primary-700 text-white shadow-md">
          <div className="container mx-auto px-4 py-3">
            <div className="flex items-center justify-between">
              {/* Left: Logo and App Title */}
              <div className="flex items-center space-x-4">
                {/* Logo */}
                <div className="logo-container h-14 w-14">
                  <Image 
                    src="/logo.svg" 
                    alt="Voting DApp Logo" 
                    width={56} 
                    height={56} 
                    className="object-contain drop-shadow-lg"
                    priority
                  />
                </div>
                
                {/* App Title */}
                <Link href="/" className="text-2xl font-bold hover:text-primary-200 transition-colors">
                  Bock Vote
                </Link>
              </div>
              
              {/* Center/Right: Navigation */}
              <nav className="hidden md:block">
                <ul className="flex items-center space-x-8">
                  {navItems.map((item) => (
                    <li key={item.path}>
                      <Link
                        href={item.path}
                        className={`hover:text-primary-200 transition-colors text-lg ${
                          router.pathname === item.path ? 'text-primary-200 font-bold' : ''
                        }`}
                      >
                        {item.name}
                      </Link>
                    </li>
                  ))}
                </ul>
              </nav>
              
              {/* Mobile menu button */}
              <button className="md:hidden text-white">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                </svg>
              </button>
            </div>
          </div>
        </header>

        {/* Main content */}
        <main className="flex-grow container mx-auto px-4 py-8">
          {children}
        </main>

        {/* Footer */}
        <footer className="bg-gray-800 text-white py-6">
          <div className="container mx-auto px-4">
            <div className="flex flex-col md:flex-row justify-between items-center">
              <div className="flex items-center space-x-3 mb-4 md:mb-0">
                <div className="h-8 w-8 relative">
                  <Image 
                    src="/logo.svg" 
                    alt="Voting DApp Logo" 
                    width={32} 
                    height={32} 
                    className="object-contain"
                  />
                </div>
                <p>&copy; {new Date().getFullYear()} Voting DApp. All rights reserved.</p>
              </div>
              <div className="flex space-x-4">
                <a href="#" className="hover:text-primary-300 transition-colors">Privacy Policy</a>
                <a href="#" className="hover:text-primary-300 transition-colors">Terms of Service</a>
                <a href="#" className="hover:text-primary-300 transition-colors">Contact</a>
              </div>
            </div>
          </div>
        </footer>
      </div>
    </>
  );
};

export default Layout; 