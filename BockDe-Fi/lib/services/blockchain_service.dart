/*import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class BlockchainService {
  static Web3Client? _client;
  
  // Public RPC endpoint - works from anywhere, including APK!
  static const String rpcUrl = 'https://bsc-dataseed.binance.org/';
  
  // PancakeSwap Router address
  static const String routerAddress = '0x10ED43C718714eb63d5aA57B78B54704E256024E';
  static const String factoryAddress = '0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73';
  
  // Get Web3 client instance
  static Web3Client get client {
    _client ??= Web3Client(rpcUrl, http.Client());
    return _client!;
  }
  
  // Router ABI (simplified - only functions we need)
  static const String routerABI = '''
  [
    {
      "inputs": [
        {"internalType": "uint256", "name": "amountIn", "type": "uint256"},
        {"internalType": "address[]", "name": "path", "type": "address[]"}
      ],
      "name": "getAmountsOut",
      "outputs": [
        {"internalType": "uint256[]", "name": "amounts", "type": "uint256[]"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  ''';
  
  // Get swap quote directly from blockchain
  static Future<Map<String, dynamic>> getSwapQuote({
    required String tokenIn,
    required String tokenOut,
    required String amountIn,
    double slippage = 0.5,
  }) async {
    try {
      // Parse contract ABI
      final contract = DeployedContract(
        ContractAbi.fromJson(routerABI, 'PancakeRouter'),
        EthereumAddress.fromHex(routerAddress),
      );
      
      // Prepare function call
      final function = contract.function('getAmountsOut');
      final path = [
        EthereumAddress.fromHex(tokenIn),
        EthereumAddress.fromHex(tokenOut),
      ];
      
      // Call blockchain
      final result = await client.call(
        contract: contract,
        function: function,
        params: [BigInt.parse(amountIn), path],
      );
      
      // Parse result
      final amounts = result.first as List<dynamic>;
      final amountOut = amounts[1] as BigInt;
      
      // Calculate minimum amount with slippage
      final slippageMultiplier = (100 - slippage) / 100;
      final minAmountOut = (amountOut.toDouble() * slippageMultiplier).toInt();
      
      // Calculate fee (0.2% = 0.002)
      final fee = BigInt.parse(amountIn) * BigInt.from(2) ~/ BigInt.from(1000);
      
      return {
        'amount_in': amountIn,
        'amount_out': amountOut.toString(),
        'min_amount_out': minAmountOut.toString(),
        'price_impact': 0.01, // Simplified - calculate properly in production
        'route': [tokenIn, tokenOut],
        'fee': fee.toString(),
        'gas_estimate': '150000',
      };
    } catch (e) {
      print('Blockchain error: $e');
      // Fallback to mock calculation
      return _getMockQuote(amountIn, slippage);
    }
  }
  
  // Mock calculation as fallback
  static Map<String, dynamic> _getMockQuote(String amountIn, double slippage) {
    final amount = BigInt.parse(amountIn);
    final fee = amount * BigInt.from(2) ~/ BigInt.from(1000); // 0.2%
    final amountOut = amount - fee;
    final slippageAmount = (amountOut.toDouble() * slippage / 100).toInt();
    
    return {
      'amount_in': amountIn,
      'amount_out': amountOut.toString(),
      'min_amount_out': (amountOut - BigInt.from(slippageAmount)).toString(),
      'price_impact': 0.01,
      'route': ['mock', 'mock'],
      'fee': fee.toString(),
      'gas_estimate': '150000',
    };
  }
  
  // Execute swap on blockchain
  static Future<Map<String, dynamic>> executeSwap({
    required String tokenIn,
    required String tokenOut,
    required String amountIn,
    required String minAmountOut,
    required String recipient,
    required int deadline,
  }) async {
    try {
      // For direct blockchain execution, you need:
      // 1. User's wallet private key (from WalletConnect or MetaMask)
      // 2. Sign the transaction
      // 3. Send to blockchain
      
      // IMPORTANT: This is a placeholder!
      // Real implementation requires wallet integration
      
      // For now, return mock success
      // In production, integrate WalletConnect or MetaMask
      
      return {
        'transaction_hash': '0x${_generateMockTxHash()}',
        'status': 'success',
        'amount_out': minAmountOut,
      };
    } catch (e) {
      throw Exception('Swap execution failed: $e');
    }
  }
  
  // Generate mock transaction hash for demo
  static String _generateMockTxHash() {
    final random = Random();
    final chars = '0123456789abcdef';
    return List.generate(64, (index) => chars[random.nextInt(chars.length)]).join();
  }
  
  static void dispose() {
    _client?.dispose();
    _client = null;
  }
}*/

import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:async';

class BlockchainService {
  static Web3Client? _client;
  
  // Public RPC endpoint
  static const String rpcUrl = 'https://bsc-dataseed.binance.org/';
  static const String routerAddress = '0x10ED43C718714eb63d5aA57B78B54704E256024E';
  static const String factoryAddress = '0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73';
  
  // For real-time updates
  static Timer? _priceUpdateTimer;
  static Function? _onPriceUpdate;
  
  static Web3Client get client {
    _client ??= Web3Client(rpcUrl, http.Client());
    return _client!;
  }
  
  static const String routerABI = '''
  [
    {
      "inputs": [
        {"internalType": "uint256", "name": "amountIn", "type": "uint256"},
        {"internalType": "address[]", "name": "path", "type": "address[]"}
      ],
      "name": "getAmountsOut",
      "outputs": [
        {"internalType": "uint256[]", "name": "amounts", "type": "uint256[]"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  ''';
  
  // ============================================
  // REAL-TIME: Start auto-updating prices
  // ============================================
  static void startRealTimeUpdates({
    required String tokenIn,
    required String tokenOut,
    required String amountIn,
    required Function(Map<String, dynamic>) onUpdate,
    Duration interval = const Duration(seconds: 5), required double slippage, // Update every 5 seconds
  }) {
    // Cancel existing timer
    _priceUpdateTimer?.cancel();
    
    // Store callback
    _onPriceUpdate = onUpdate;
    
    // Get initial quote
    getSwapQuote(
      tokenIn: tokenIn,
      tokenOut: tokenOut,
      amountIn: amountIn,
    ).then((quote) {
      onUpdate(quote);
    });
    
    // Start periodic updates
    _priceUpdateTimer = Timer.periodic(interval, (timer) async {
      try {
        final quote = await getSwapQuote(
          tokenIn: tokenIn,
          tokenOut: tokenOut,
          amountIn: amountIn,
        );
        onUpdate(quote);
        print('🔄 Real-time update: ${DateTime.now()}');
      } catch (e) {
        print('⚠️ Update error: $e');
      }
    });
  }
  
  // ============================================
  // REAL-TIME: Stop auto-updates
  // ============================================
  static void stopRealTimeUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = null;
    _onPriceUpdate = null;
    print('⏹️ Stopped real-time updates');
  }
  
  // ============================================
  // Get swap quote from blockchain
  // ============================================
  static Future<Map<String, dynamic>> getSwapQuote({
    required String tokenIn,
    required String tokenOut,
    required String amountIn,
    double slippage = 0.5,
  }) async {
    try {
      final contract = DeployedContract(
        ContractAbi.fromJson(routerABI, 'PancakeRouter'),
        EthereumAddress.fromHex(routerAddress),
      );
      
      final function = contract.function('getAmountsOut');
      final path = [
        EthereumAddress.fromHex(tokenIn),
        EthereumAddress.fromHex(tokenOut),
      ];
      
      // Add timestamp for tracking
      final startTime = DateTime.now();
      
      final result = await client.call(
        contract: contract,
        function: function,
        params: [BigInt.parse(amountIn), path],
      );
      
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inMilliseconds;
      
      final amounts = result.first as List<dynamic>;
      final amountOut = amounts[1] as BigInt;
      
      final slippageMultiplier = (100 - slippage) / 100;
      final minAmountOut = (amountOut.toDouble() * slippageMultiplier).toInt();
      
      final fee = BigInt.parse(amountIn) * BigInt.from(2) ~/ BigInt.from(1000);
      
      return {
        'amount_in': amountIn,
        'amount_out': amountOut.toString(),
        'min_amount_out': minAmountOut.toString(),
        'price_impact': 0.01,
        'route': [tokenIn, tokenOut],
        'fee': fee.toString(),
        'gas_estimate': '150000',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'response_time_ms': responseTime,
        'is_real_time': true,
      };
    } catch (e) {
      print('Blockchain error: $e');
      return _getMockQuote(amountIn, slippage);
    }
  }
  
  // ============================================
  // Get current block number (for real-time check)
  // ============================================
  static Future<int> getCurrentBlockNumber() async {
    try {
      return await client.getBlockNumber();
    } catch (e) {
      print('Error getting block number: $e');
      return 0;
    }
  }
  
  // ============================================
  // Check if prices are updating (monitor blockchain)
  // ============================================
  static Future<bool> isBlockchainLive() async {
    try {
      final block1 = await client.getBlockNumber();
      await Future.delayed(Duration(seconds: 3));
      final block2 = await client.getBlockNumber();
      return block2 > block1; // Blockchain is live if blocks are moving
    } catch (e) {
      return false;
    }
  }
  
  // Execute swap (MOCK)
  static Future<Map<String, dynamic>> executeSwap({
    required String tokenIn,
    required String tokenOut,
    required String amountIn,
    required String minAmountOut,
    required String recipient,
    required int deadline,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    
    final random = Random();
    final chars = '0123456789abcdef';
    final txHash = List.generate(64, (i) => chars[random.nextInt(16)]).join();
    
    return {
      'transaction_hash': '0x$txHash',
      'status': 'success',
      'amount_out': minAmountOut,
      'note': '⚠️ Mock transaction for testing only',
    };
  }
  
  static Map<String, dynamic> _getMockQuote(String amountIn, double slippage) {
    try {
      final amount = BigInt.parse(amountIn);
      final fee = amount * BigInt.from(2) ~/ BigInt.from(1000);
      final amountOut = amount - fee;
      final slippageAmount = (amountOut.toDouble() * slippage / 100).toInt();
      
      return {
        'amount_in': amountIn,
        'amount_out': amountOut.toString(),
        'min_amount_out': (amountOut - BigInt.from(slippageAmount)).toString(),
        'price_impact': 0.01,
        'route': ['mock', 'mock'],
        'fee': fee.toString(),
        'gas_estimate': '150000',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'is_real_time': false,
      };
    } catch (e) {
      return {
        'amount_in': amountIn,
        'amount_out': amountIn,
        'min_amount_out': amountIn,
        'price_impact': 0.0,
        'route': ['mock', 'mock'],
        'fee': '0',
        'gas_estimate': '150000',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'is_real_time': false,
      };
    }
  }
  
  static void dispose() {
    stopRealTimeUpdates();
    _client?.dispose();
    _client = null;
  }
}