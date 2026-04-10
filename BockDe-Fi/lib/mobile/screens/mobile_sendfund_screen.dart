import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SendFundScreen extends StatefulWidget {
  final String walletAddress;
  final String privateKey;
  final VoidCallback? onTransactionComplete;
  
  const SendFundScreen({
    Key? key,
    required this.walletAddress,
    required this.privateKey,
    this.onTransactionComplete,
  }) : super(key: key);

  @override
  State<SendFundScreen> createState() => _SendFundScreenState();
}

class _SendFundScreenState extends State<SendFundScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final WalletService _walletService = WalletService();
  
  QRViewController? controller;
  bool showScanner = false;
  bool isSending = false;
  double currentBalance = 0.0;
  String estimatedGas = '0.00021'; // Default gas estimate

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      final balance = await _walletService.getBalance(widget.walletAddress);
      setState(() {
        currentBalance = balance;
      });
    } catch (e) {
      print('Error loading balance: $e');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    controller?.dispose();
    _walletService.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _addressController.text = scanData.code ?? '';
        showScanner = false;
      });
      controller.pauseCamera();
      _validateAddress();
    });
  }

  void _toggleScanner() {
    setState(() {
      showScanner = !showScanner;
      if (!showScanner) {
        controller?.pauseCamera();
      } else {
        controller?.resumeCamera();
      }
    });
  }

  bool _validateAddress() {
    final address = _addressController.text.trim();
    if (address.isEmpty) return false;
    return _walletService.isValidAddress(address);
  }

  Future<void> _estimateGas() async {
    if (!_validateAddress() || _amountController.text.isEmpty) return;
    
    try {
      final amount = double.tryParse(_amountController.text) ?? 0;
      if (amount <= 0) return;
      
      final gas = await _walletService.estimateGas(
        fromAddress: widget.walletAddress,
        toAddress: _addressController.text.trim(),
        amount: amount,
      );
      
      final gasPrice = await _walletService.getGasPrice();
      final totalGasBigInt = gas * gasPrice.getInWei;
      
      // Convert BigInt to double safely
      final gasInEth = totalGasBigInt.toDouble() / 1e18;
      
      setState(() {
        estimatedGas = gasInEth.toStringAsFixed(6);
      });
    } catch (e) {
      print('Error estimating gas: $e');
      // Set a default gas estimate if calculation fails
      setState(() {
        estimatedGas = '0.00021'; // ~21000 gas * typical gas price
      });
    }
  }

  Future<void> _sendFund() async {
    if (_addressController.text.isEmpty || _amountController.text.isEmpty) {
      _showSnackBar('Please enter address and amount', isError: true);
      return;
    }

    if (!_validateAddress()) {
      _showSnackBar('Invalid Ethereum address', isError: true);
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBar('Invalid amount', isError: true);
      return;
    }

    if (amount > currentBalance) {
      _showSnackBar('Insufficient balance', isError: true);
      return;
    }

    // Estimate gas first
    await _estimateGas();
    
    // Use default if estimation failed
    if (estimatedGas.isEmpty || estimatedGas == '0') {
      estimatedGas = '0.00021';
    }
    
    final gasAmount = double.tryParse(estimatedGas) ?? 0.00021;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You are about to send:'),
            const SizedBox(height: 16),
            _buildInfoRow('Amount:', '$amount ETH'),
            _buildInfoRow('To:', '${_addressController.text.substring(0, 10)}...'),
            _buildInfoRow('Est. Gas:', '${gasAmount.toStringAsFixed(6)} ETH'),
            const Divider(height: 24),
            _buildInfoRow(
              'Total:',
              '${(amount + gasAmount).toStringAsFixed(6)} ETH',
              isBold: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 122, 79, 223),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => isSending = true);

    try {
      final txHash = await _walletService.sendTransaction(
        fromPrivateKey: widget.privateKey,
        toAddress: _addressController.text.trim(),
        amount: amount,
      );

      setState(() => isSending = false);
      
      // Show success dialog
      if (!mounted) return;
      
      final shouldGoBack = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 28),
              const SizedBox(width: 12),
              const Text('Transaction Sent!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your transaction has been broadcast to the network.'),
              const SizedBox(height: 16),
              const Text(
                'Transaction Hash:',
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
                  txHash,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'View on Etherscan: https://sepolia.etherscan.io/tx/$txHash',
                style: TextStyle(fontSize: 11, color: Colors.blue[700]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your balance will update in 10-30 seconds after confirmation.',
                        style: TextStyle(fontSize: 11, color: Colors.green.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: txHash));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction hash copied!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Copy Hash'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
      
      // Clear form
      _addressController.clear();
      _amountController.clear();
      setState(() {
        estimatedGas = '0.00021';
      });
      
      // Refresh balance callback
      widget.onTransactionComplete?.call();
      
      // Go back to assets screen
      if (mounted && (shouldGoBack ?? false)) {
        Navigator.pop(context);
      }
      
    } catch (e) {
      setState(() => isSending = false);
      _showSnackBar('Transaction failed: ${e.toString()}', isError: true);
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Send ETH'),
        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Balance Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${currentBalance.toStringAsFixed(6)} ETH',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // QR Scanner Section
              if (showScanner)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 250,
                      ),
                    ),
                  ),
                ),

              if (showScanner) const SizedBox(height: 16),

              // Scan QR Button
              ElevatedButton.icon(
                onPressed: _toggleScanner,
                icon: Icon(showScanner ? Icons.close : Icons.qr_code_scanner),
                label: Text(showScanner ? 'Close Scanner' : 'Scan QR Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100],
                  foregroundColor: const Color.fromARGB(255, 122, 79, 223),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recipient Address
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recipient Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 122, 79, 223),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      onChanged: (_) {
                        _validateAddress();
                        _estimateGas();
                      },
                      decoration: InputDecoration(
                        hintText: '0x...',
                        prefixIcon: const Icon(
                          Icons.account_balance_wallet,
                          color: Color.fromARGB(255, 122, 79, 223),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_validateAddress())
                              const Icon(Icons.check_circle, color: Colors.green),
                            IconButton(
                              icon: const Icon(
                                Icons.paste,
                                color: Color.fromARGB(255, 122, 79, 223),
                              ),
                              onPressed: () async {
                                ClipboardData? data =
                                    await Clipboard.getData('text/plain');
                                if (data != null) {
                                  _addressController.text = data.text ?? '';
                                  _validateAddress();
                                  _estimateGas();
                                }
                              },
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.purple[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.purple[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 122, 79, 223),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Amount Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amount (ETH)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 122, 79, 223),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Set max amount minus gas
                            final maxAmount =
                                (currentBalance - double.parse(estimatedGas.isEmpty ? '0' : estimatedGas))
                                    .clamp(0, currentBalance);
                            _amountController.text = maxAmount.toStringAsFixed(6);
                            _estimateGas();
                          },
                          child: const Text('MAX'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => _estimateGas(),
                      decoration: InputDecoration(
                        hintText: '0.0',
                        prefixIcon: const Icon(
                          Icons.currency_exchange,
                          color: Color.fromARGB(255, 122, 79, 223),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 122, 79, 223),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 122, 79, 223),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 122, 79, 223),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    if (estimatedGas.isNotEmpty && estimatedGas != '0')
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Est. Gas Fee: $estimatedGas ETH',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Send Button
              ElevatedButton(
                onPressed: isSending ? null : _sendFund,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: isSending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        'Send Transaction',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}