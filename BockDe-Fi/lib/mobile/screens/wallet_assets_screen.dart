import 'package:flutter/material.dart';

class WalletAssetsScreen extends StatelessWidget {
  const WalletAssetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Assets',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 196, 171, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance_wallet, color: Color.fromRGBO(156, 39, 176, 1)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'My Wallet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.keyboard_arrow_down),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.content_copy, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Balance
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '₹0',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.arrow_upward,
                  label: 'Send',
                  onTap: () => _navigateToSendScreen(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.arrow_downward,
                  label: 'Receive',
                  onTap: () => _navigateToReceiveScreen(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.history,
                  label: 'History',
                  onTap: () => _navigateToHistoryScreen(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Approvals',
                  onTap: () => _navigateToApprovalsScreen(context),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tabs
          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color.fromRGBO(156, 39, 176, 1),
                    tabs: [
                      Tab(text: 'Tokens'),
                      Tab(text: 'DeFi'),
                      Tab(text: 'NFTs'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTokensList(),
                        const Center(child: Text('DeFi Content')),
                        const Center(child: Text('NFTs Content')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
     );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTokensList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Assets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
          ],
        ),
        const Text('₹0', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTokenItem('BNB', '₹96,678.77', '+5.03%', '0', '₹0', Colors.orange),
        _buildTokenItem('ETH', '₹396,283.16', '+1.43%', '0', '₹0', Colors.blue),
        _buildTokenItem('ETH', '₹396,317.07', '+1.55%', '0', '₹0', Colors.blue),
        _buildTokenItem('SOL', '₹20,362.88', '+2.11%', '0', '₹0', Colors.purple),
        _buildTokenItem('USDC', '₹88.74', '-0.02%', '0', '₹0', Colors.blue),
        _buildTokenItem('USDT', '₹88.70', '-0.02%', '0', '₹0', Colors.green),
      ],
    );
  }

  Widget _buildTokenItem(String symbol, String price, String change, String amount, String value, Color color) {
    final isPositive = change.startsWith('+');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(Icons.currency_bitcoin, color: color)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(symbol, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Text(price, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 8),
                    Text(change, style: TextStyle(fontSize: 12, color: isPositive ? Colors.green : Colors.red)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(value, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToSendScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SendTokenScreen()));
  }

  void _navigateToReceiveScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceiveTokensScreen()));
  }

  void _navigateToHistoryScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
  }

  void _navigateToApprovalsScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ApprovalsScreen()));
  }
}

// Send Token Screen
class SendTokenScreen extends StatelessWidget {
  const SendTokenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Send Token', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionCard(
              context,
              icon: Icons.swap_horiz,
              title: 'Transfer to BOCK De-Fi Exchange',
              subtitle: 'Transfer assets to your BOCK De-Fi Account',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferToBinanceScreen())),
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              icon: Icons.account_balance_wallet_outlined,
              title: 'Send to Wallet Address',
              subtitle: 'Send your assets to onchain wallet address',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SendToWalletScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Receive Tokens Screen
class ReceiveTokensScreen extends StatelessWidget {
  const ReceiveTokensScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Receive Tokens', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOptionCard(
              context,
              icon: Icons.swap_horiz,
              title: 'Transfer from BOCK De-Fi Exchange',
              subtitle: 'Withdraw assets from your BOCK De-Fi Account',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferFromBinanceScreen())),
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              icon: Icons.qr_code,
              title: 'Receive Tokens via Address',
              subtitle: 'Receive funds via wallet address or QR code',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceiveViaAddressScreen())),
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              icon: Icons.credit_card,
              title: 'Buy with Card',
              subtitle: 'Buy crypto easily via card, Apple Pay, Google Pay',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyWithCardScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for navigation
class TransferToBinanceScreen extends StatelessWidget {
  const TransferToBinanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer to BOCK De-Fi Exchange')),
      body: const Center(child: Text('Transfer to BOCK De-Fi Exchange Screen')),
    );
  }
}

class SendToWalletScreen extends StatelessWidget {
  const SendToWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send to Wallet Address')),
      body: const Center(child: Text('Send to Wallet Address Screen')),
    );
  }
}

class TransferFromBinanceScreen extends StatelessWidget {
  const TransferFromBinanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer from BOCK De-Fi Exchange')),
      body: const Center(child: Text('Transfer from BOCK De-Fi Exchange Screen')),
    );
  }
}

class ReceiveViaAddressScreen extends StatelessWidget {
  const ReceiveViaAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive Tokens via Address')),
      body: const Center(child: Text('Receive Tokens via Address Screen')),
    );
  }
}

class BuyWithCardScreen extends StatelessWidget {
  const BuyWithCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy with Card')),
      body: const Center(child: Text('Buy with Card Screen')),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('Transaction History Screen')),
    );
  }
}

class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approvals')),
      body: const Center(child: Text('Approvals Screen')),
    );
  }
}