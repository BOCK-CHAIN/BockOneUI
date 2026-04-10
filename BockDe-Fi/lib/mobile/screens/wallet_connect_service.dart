import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'dart:convert';

class WalletService {
  late Web3Client _client;
  late String _rpcUrl;
  
  // Sepolia Testnet RPC URL (you can use Infura or Alchemy)
  static const String sepoliaRpcUrl = 'https://sepolia.infura.io/v3/67e0fe82bbe141469c0b27ca7546b91a';
  
  WalletService() {
    _rpcUrl = sepoliaRpcUrl;
    _client = Web3Client(_rpcUrl, Client());
  }

  // Generate a new wallet
  Future<Map<String, String>> generateWallet() async {
    // Generate mnemonic (12 words)
    final mnemonic = bip39.generateMnemonic();
    
    // Generate private key from mnemonic
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);
    
    // Create credentials from private key
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = await credentials.extractAddress();
    
    return {
      'address': address.hex,
      'privateKey': privateKey,
      'mnemonic': mnemonic,
    };
  }

  // Get wallet from private key
  EthPrivateKey getCredentialsFromPrivateKey(String privateKey) {
    return EthPrivateKey.fromHex(privateKey);
  }

  // Get ETH balance
  Future<double> getBalance(String address) async {
    try {
      final ethAddress = EthereumAddress.fromHex(address);
      final balance = await _client.getBalance(ethAddress);
      // Convert from Wei to ETH
      return balance.getValueInUnit(EtherUnit.ether).toDouble();
    } catch (e) {
      print('Error getting balance: $e');
      return 0.0;
    }
  }

  // Send ETH
  Future<String> sendTransaction({
    required String fromPrivateKey,
    required String toAddress,
    required double amount,
  }) async {
    try {
      final credentials = EthPrivateKey.fromHex(fromPrivateKey);
      final recipient = EthereumAddress.fromHex(toAddress);
      
      // Convert ETH to Wei (more precise conversion)
      final weiAmount = BigInt.from(amount * 1e18);
      final amountInWei = EtherAmount.inWei(weiAmount);

      // Send transaction
      final txHash = await _client.sendTransaction(
        credentials,
        Transaction(
          to: recipient,
          value: amountInWei,
        ),
        chainId: 11155111, // Sepolia chain ID
      );

      return txHash;
    } catch (e) {
      print('Error sending transaction: $e');
      throw Exception('Failed to send transaction: $e');
    }
  }

  // Get transaction receipt
  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    try {
      return await _client.getTransactionReceipt(txHash);
    } catch (e) {
      print('Error getting transaction receipt: $e');
      return null;
    }
  }

  // Get transaction history (using Etherscan API)
  Future<List<Map<String, dynamic>>> getTransactionHistory(String address) async {
    try {
      // You'll need an Etherscan API key
      const apiKey = '7B2Y9IDR4X8JIT51D3BUMN3AM36MK9PX46';
      final url = 'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&sort=desc&apikey=$apiKey';
      
      final response = await Client().get(Uri.parse(url));
      final data = json.decode(response.body);
      
      if (data['status'] == '1') {
        return List<Map<String, dynamic>>.from(data['result']);
      }
      return [];
    } catch (e) {
      print('Error getting transaction history: $e');
      return [];
    }
  }

  // Request test ETH from faucet (Sepolia faucet)
  Future<Map<String, dynamic>> requestTestEth(String address) async {
    try {
      // Using Alchemy Sepolia Faucet API
      // Note: This requires authentication. For production, use proper faucet integration
      const faucetUrl = 'https://sepoliafaucet.com/';
      
      return {
        'success': true,
        'message': 'Please visit $faucetUrl and enter your address: $address',
        'faucetUrl': faucetUrl,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to request test ETH: $e',
      };
    }
  }

  // Get current gas price
  Future<EtherAmount> getGasPrice() async {
    try {
      return await _client.getGasPrice();
    } catch (e) {
      print('Error getting gas price: $e');
      return EtherAmount.zero();
    }
  }

  // Estimate gas for transaction
  Future<BigInt> estimateGas({
    required String fromAddress,
    required String toAddress,
    required double amount,
  }) async {
    try {
      final sender = EthereumAddress.fromHex(fromAddress);
      final recipient = EthereumAddress.fromHex(toAddress);
      final amountInWei = EtherAmount.fromUnitAndValue(
        EtherUnit.ether,
        (amount * 1e18).toInt(),
      );

      return await _client.estimateGas(
        sender: sender,
        to: recipient,
        value: amountInWei,
      );
    } catch (e) {
      print('Error estimating gas: $e');
      return BigInt.from(21000); // Default gas limit for ETH transfer
    }
  }

  // Validate Ethereum address
  bool isValidAddress(String address) {
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _client.dispose();
  }
}

/*import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Transaction {
  final String hash;
  final String from;
  final String to;
  final String value;
  final DateTime timestamp;
  final bool isPending;
  final String type;

  Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.value,
    required this.timestamp,
    this.isPending = false,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'hash': hash,
    'from': from,
    'to': to,
    'value': value,
    'timestamp': timestamp.toIso8601String(),
    'isPending': isPending,
    'type': type,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    hash: json['hash'],
    from: json['from'],
    to: json['to'],
    value: json['value'],
    timestamp: DateTime.parse(json['timestamp']),
    isPending: json['isPending'] ?? false,
    type: json['type'],
  );
}

class WalletConnectService {
  String? _walletAddress;
  Web3Client? _web3client;
  List<Transaction> _transactions = [];
  Timer? _balanceUpdateTimer;
  String _currentBalance = '0';
  
  final String rpcUrl = 'https://sepolia.infura.io/v3/67e0fe82bbe141469c0b27ca7546b91a';
  final String etherscanApiKey = '7B2Y9IDR4X8JIT51D3BUMN3AM36MK9PX46';
  
  String? get walletAddress => _walletAddress;
  bool get isConnected => _walletAddress != null;
  List<Transaction> get transactions => _transactions;
  String get currentBalance => _currentBalance;

  void initWeb3Client() {
    _web3client = Web3Client(rpcUrl, http.Client());
  }

  // FIXED: Connect to MetaMask - Direct to app home
  Future<String?> connectWallet(BuildContext context) async {
    try {
      if (_web3client == null) {
        initWeb3Client();
      }

      // Open MetaMask app directly to home screen
      final metamaskUrl = 'https://metamask.app.link';
      
      if (await canLaunchUrl(Uri.parse(metamaskUrl))) {
        await launchUrl(
          Uri.parse(metamaskUrl),
          mode: LaunchMode.externalApplication,
        );
      }

      // Show dialog to manually enter address
      final address = await _showAddressInputDialog(context);
      
      if (address != null && address.isNotEmpty) {
        if (_isValidEthereumAddress(address)) {
          _walletAddress = address;
          _startBalanceUpdates();
          await loadTransactionHistory();
          return _walletAddress;
        } else {
          throw Exception('Invalid Ethereum address');
        }
      }
      
      return null;
    } catch (e) {
      print('Error connecting: $e');
      return null;
    }
  }

  Future<String?> _showAddressInputDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect MetaMask'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Copy your wallet address from MetaMask and paste it here:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '0x...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.account_balance_wallet),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '1. Open MetaMask app\n2. Tap on account name\n3. Copy address\n4. Paste here',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final address = controller.text.trim();
              Navigator.pop(context, address);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 122, 79, 223),
            ),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _startBalanceUpdates() {
    _balanceUpdateTimer?.cancel();
    _balanceUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await getBalance();
      await loadTransactionHistory();
    });
  }

  bool _isValidEthereumAddress(String address) {
    return address.startsWith('0x') && address.length == 42;
  }

  Future<String> getBalance() async {
    if (_walletAddress == null || _web3client == null) {
      _currentBalance = '0';
      return '0';
    }
    
    try {
      final address = EthereumAddress.fromHex(_walletAddress!);
      final balance = await _web3client!.getBalance(address);
      
      final ethBalance = balance.getInWei / BigInt.from(10).pow(18);
      _currentBalance = ethBalance.toStringAsFixed(6);
      return _currentBalance;
    } catch (e) {
      print('Error getting balance: $e');
      return _currentBalance;
    }
  }

  Future<void> loadTransactionHistory() async {
    if (_walletAddress == null) return;

    try {
      final url = 'https://api-sepolia.etherscan.io/api'
          '?module=account'
          '&action=txlist'
          '&address=$_walletAddress'
          '&startblock=0'
          '&endblock=99999999'
          '&page=1'
          '&offset=100'
          '&sort=desc'
          '&apikey=$etherscanApiKey';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == '1' && data['result'] != null) {
          final txList = data['result'] as List;
          
          _transactions = txList.map((tx) {
            final isSent = tx['from'].toString().toLowerCase() == 
                           _walletAddress!.toLowerCase();
            
            final valueInWei = BigInt.parse(tx['value'].toString());
            final ethValue = (valueInWei / BigInt.from(10).pow(18))
                .toStringAsFixed(6);
            
            return Transaction(
              hash: tx['hash'],
              from: tx['from'],
              to: tx['to'],
              value: ethValue,
              timestamp: DateTime.fromMillisecondsSinceEpoch(
                int.parse(tx['timeStamp']) * 1000
              ),
              isPending: tx['confirmations'] == '0',
              type: isSent ? 'sent' : 'received',
            );
          }).toList();
        }
      }
    } catch (e) {
      print('Error loading transaction history: $e');
    }
  }

  // FIXED: Send transaction with proper MetaMask deep link
  Future<String?> sendTransaction({
    required String toAddress,
    required String amount,
  }) async {
    if (_walletAddress == null) {
      print('Wallet not connected');
      return null;
    }

    try {
      // Convert ETH to Wei
      final weiAmount = (double.parse(amount) * 1e18).toInt();
      
      // FIXED: Proper MetaMask deep link format
      // Format: metamask://send?address=TO_ADDRESS&uint256=AMOUNT_IN_WEI
      final deepLink = Uri.encodeFull(
        'metamask://send/$toAddress@11155111?value=${weiAmount.toString()}'
      );
      
      print('Opening MetaMask with: $deepLink');
      
      if (await canLaunchUrl(Uri.parse(deepLink))) {
        final launched = await launchUrl(
          Uri.parse(deepLink),
          mode: LaunchMode.externalApplication,
        );
        
        if (launched) {
          // Generate mock transaction hash for tracking
          final txHash = '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
          
          // Add pending transaction to local list
          _transactions.insert(0, Transaction(
            hash: txHash,
            from: _walletAddress!,
            to: toAddress,
            value: amount,
            timestamp: DateTime.now(),
            isPending: true,
            type: 'sent',
          ));
          
          // Schedule balance refresh
          Future.delayed(const Duration(seconds: 5), () {
            getBalance();
            loadTransactionHistory();
          });
          
          return txHash;
        }
      } else {
        // Fallback: Try alternative format
        final alternativeLink = 'https://metamask.app.link/send/$toAddress@11155111?value=$weiAmount';
        
        print('Trying alternative link: $alternativeLink');
        
        final launched = await launchUrl(
          Uri.parse(alternativeLink),
          mode: LaunchMode.externalApplication,
        );
        
        if (launched) {
          final txHash = '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
          
          _transactions.insert(0, Transaction(
            hash: txHash,
            from: _walletAddress!,
            to: toAddress,
            value: amount,
            timestamp: DateTime.now(),
            isPending: true,
            type: 'sent',
          ));
          
          Future.delayed(const Duration(seconds: 5), () {
            getBalance();
            loadTransactionHistory();
          });
          
          return txHash;
        }
      }
      
      throw Exception('Could not open MetaMask');
    } catch (e) {
      print('Transaction error: $e');
      return null;
    }
  }

  String getReceiveAddress() {
    return _walletAddress ?? '';
  }

  Future<void> disconnect() async {
    _walletAddress = null;
    _transactions = [];
    _currentBalance = '0';
    _balanceUpdateTimer?.cancel();
  }

  void dispose() {
    _web3client?.dispose();
    _balanceUpdateTimer?.cancel();
  }

  Future<Map<String, dynamic>?> getTransactionDetails(String txHash) async {
    if (_web3client == null) return null;
    
    try {
      final receipt = await _web3client!.getTransactionReceipt(txHash);
      if (receipt != null) {
        return {
          'from': receipt.from?.hex,
          'to': receipt.to?.hex ?? '',
          'status': receipt.status ?? false,
          //'blockNumber': receipt.blockNumber.toInt(),
          'gasUsed': receipt.gasUsed?.toInt() ?? 0,
        };
      }
    } catch (e) {
      print('Error getting transaction details: $e');
    }
    return null;
  }

  Future<String> getGasPrice() async {
    if (_web3client == null) return '0';
    
    try {
      final gasPrice = await _web3client!.getGasPrice();
      final gwei = gasPrice.getInWei / BigInt.from(1e9);
      return gwei.toStringAsFixed(2);
    } catch (e) {
      print('Error getting gas price: $e');
      return '0';
    }
  }

  Future<void> refreshData() async {
    await getBalance();
    await loadTransactionHistory();
  }
}*/