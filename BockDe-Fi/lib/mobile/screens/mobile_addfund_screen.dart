import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MobileReceiveScreen extends StatefulWidget {
  final String walletAddress;
  
  const MobileReceiveScreen({
    Key? key,
    required this.walletAddress,
  }) : super(key: key);

  @override
  State<MobileReceiveScreen> createState() => _MobileReceiveScreenState();
}

class _MobileReceiveScreenState extends State<MobileReceiveScreen> {
  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: widget.walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Address copied to clipboard!'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareAddress() {
    Share.share(
      'My Ethereum Wallet Address:\n${widget.walletAddress}\n\nSend ETH (Sepolia Testnet) to this address.',
      subject: 'My Wallet Address',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Receive ETH'),
        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareAddress,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Share this address to receive ETH on Sepolia testnet',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // QR Code Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: QrImageView(
                      data: widget.walletAddress,
                      version: QrVersions.auto,
                      size: 220,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Address Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                    const Color.fromARGB(255, 122, 79, 223).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Wallet Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Address Text
                  SelectableText(
                    widget.walletAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _copyAddress,
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('Copy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareAddress,
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 122, 79, 223),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 122, 79, 223),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Network Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const SizedBox(height: 12),
                  
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Network Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sepolia Testnet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}