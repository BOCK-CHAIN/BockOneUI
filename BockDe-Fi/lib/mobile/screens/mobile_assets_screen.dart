/*import 'package:bockchain/mobile/screens/mobile_addfund_screen.dart';
import 'package:bockchain/mobile/screens/mobile_sendfund_screen.dart';
import 'package:bockchain/mobile/screens/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wallet_connect_service.dart'; // Import the service

class MobileAssetsScreen extends StatefulWidget {
  final WalletConnectService walletService;
  
  const MobileAssetsScreen({Key? key, required this.walletService}) : super(key: key);
  
  @override
  State<MobileAssetsScreen> createState() => _MobileAssetsScreenState();
}

class _MobileAssetsScreenState extends State<MobileAssetsScreen> {
  final WalletConnectService _walletService = WalletConnectService();
  bool showAddFundsOptions = false;
  String walletAddress = '';
  String balance = '0.00';
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
    _initializeWallet();
  }

  Future<void> _initializeWallet() async {
    _walletService.initWeb3Client();
  }

  // Connect MetaMask
  Future<void> _connectMetaMask() async {
    setState(() {
      isConnecting = true;
    });

    try {
      final address = await _walletService.connectWallet(context);
      if (address != null) {
        setState(() {
          walletAddress = address;
        });
        
        // Get balance after connecting
        await _updateBalance();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('MetaMask connected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isConnecting = false;
      });
    }
  }

  // Update balance
  Future<void> _updateBalance() async {
    if (_walletService.isConnected) {
      final bal = await _walletService.getBalance();
      setState(() {
        balance = bal;
      });
    }
  }

  // Disconnect wallet
  Future<void> _disconnectWallet() async {
    await _walletService.disconnect();
    setState(() {
      walletAddress = '';
      balance = '0.00';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wallet disconnected'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Connection Status
                  if (!_walletService.isConnected)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 40,
                            color: Color.fromARGB(255, 122, 79, 223),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Connect your MetaMask wallet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Connect to view balance and make transactions',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: isConnecting ? null : _connectMetaMask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isConnecting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Connect MetaMask',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (_walletService.isConnected) ...[
                    // Connected Wallet Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Connected',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: walletAddress));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Address copied!')),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.logout, size: 18),
                                onPressed: _disconnectWallet,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Header with Est. Total Value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Est. Total Value',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.history, size: 20),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionHistoryScreen(
                                    walletService: _walletService,
                                  ),
                                ) as String,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: _updateBalance,
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.help_outline,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Amount with currency
                  Row(
                    children: [
                      Text(
                        _walletService.isConnected ? '$balance ETH' : '₹0.00',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              _walletService.isConnected ? 'Sepolia' : 'INR',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Add Funds and Send Funds Buttons
                  Row(
                    children: [
                      // Add Funds Button
                      Expanded(
                        child: GestureDetector(
                          onTap: _walletService.isConnected
                              ? () {
                                  Navigator.pushNamed(context,
      MaterialPageRoute(
        builder: (context) => ReceiveScreen(
          walletService: _walletService,
        ),
      ) as String,);
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please connect wallet first'),
                                    ),
                                  );
                                },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: _walletService.isConnected
                                  ? const Color.fromARGB(255, 122, 79, 223)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Add Funds',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Send Funds Button
                      Expanded(
                        child: GestureDetector(
                          onTap: _walletService.isConnected
                              ? () async {
                                  // Navigate to send screen and pass the service
                                  final result = await Navigator.pushNamed(
                                    context,
      MaterialPageRoute(
        builder: (context) => SendFundScreen(
          walletService: _walletService,
        ),
      ) as String,
                                  );
                                  
                                  // Update balance after sending
                                  if (result == true) {
                                    await _updateBalance();
                                  }
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please connect wallet first'),
                                    ),
                                  );
                                },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: _walletService.isConnected
                                  ? const Color.fromARGB(255, 122, 79, 223)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Send Funds',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Rest of your existing coin cards...
                  // USDT, BTC, BNB cards remain the same
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:bockchain/mobile/screens/mobile_addfund_screen.dart';
import 'package:bockchain/mobile/screens/mobile_sendfund_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileAssetsScreen extends StatefulWidget {
  final String walletAddress;
  final String privateKey;
  
  const MobileAssetsScreen({
    Key? key,
    required this.walletAddress,
    required this.privateKey, required WalletService walletService,
  }) : super(key: key);

  @override
  State<MobileAssetsScreen> createState() => _MobileAssetsScreenState();
}

class _MobileAssetsScreenState extends State<MobileAssetsScreen> {
  final WalletService _walletService = WalletService();
  double ethBalance = 0.0;
  bool isLoadingBalance = true;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    setState(() => isLoadingBalance = true);
    try {
      final balance = await _walletService.getBalance(widget.walletAddress);
      setState(() {
        ethBalance = balance;
        isLoadingBalance = false;
      });
    } catch (e) {
      print('Error loading balance: $e');
      setState(() => isLoadingBalance = false);
    }
  }

  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: widget.walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wallet address copied!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _requestTestEth() async {
    final result = await _walletService.requestTestEth(widget.walletAddress);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Get Test ETH'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result['message']),
            const SizedBox(height: 16),
            if (result['success']) ...[
              const Text(
                'Your Wallet Address:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  widget.walletAddress,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Steps:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('1. Visit the faucet website'),
              const Text('2. Paste your wallet address'),
              const Text('3. Complete the verification'),
              const Text('4. Wait 1-2 minutes for funds'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _copyAddress();
            },
            child: const Text('Copy Address'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadBalance,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet Address Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 122, 79, 223),
                        const Color.fromARGB(255, 122, 79, 223).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Wallet',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.walletAddress.substring(0, 8)}...${widget.walletAddress.substring(widget.walletAddress.length - 6)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.white, size: 20),
                            onPressed: _copyAddress,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Total Balance Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _loadBalance,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                if (isLoadingBalance)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  Text(
                    '${ethBalance.toStringAsFixed(6)} ETH',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MobileReceiveScreen(
                                walletAddress: widget.walletAddress,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('Receive'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendFundScreen(
                                walletAddress: widget.walletAddress,
                                privateKey: widget.privateKey,
                                onTransactionComplete: _loadBalance,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_upward),
                        label: const Text('Send'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Get Test ETH Button
                
                const SizedBox(height: 32),
                
                // Assets List
                const Text(
                  'Your Assets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // ETH Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'Ξ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ethereum',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Sepolia Testnet',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${ethBalance.toStringAsFixed(6)} ETH',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Test Network',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _walletService.dispose();
    super.dispose();
  }
}