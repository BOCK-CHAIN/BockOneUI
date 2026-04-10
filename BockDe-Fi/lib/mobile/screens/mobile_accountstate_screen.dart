import 'package:flutter/material.dart';

class MobileAccountStateScreen extends StatefulWidget {
  const MobileAccountStateScreen({Key? key}) : super(key: key);

  @override
  State<MobileAccountStateScreen> createState() => _MobileAccountStateScreenState();
}

class _MobileAccountStateScreenState extends State<MobileAccountStateScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample data - replace with your actual data models
  final Map<String, dynamic> accountData = {
    'date': '2025-09-23',
    'userId': '',
    'accountType': 'Wallet',
    'masterAccount': 'All',
    'btcRate': 1.0,
    'btcRateUSD': 111999.0,
    'totalValueBTC': 0.0,
    'spotBTC': 0.0,
    'fundingBTC': 0.0,
    'usdFuturesBTC': 0.0,
    'coinFuturesBTC': 0.0,
    'unrealizedPNL': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Statement',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF7C3AED),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Funding'),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildFundingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.download, size: 20),
                      onPressed: () {},
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, size: 20),
                      onPressed: () {},
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          Text(
            'Data refreshes at UTC+0 daily.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Account Details Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDetailRow('Date', accountData['date'] as String),
                const Divider(height: 24),
                _buildDetailRow('User ID', ''),
                const Divider(height: 24),
                _buildDetailRow('Account Type', accountData['accountType'] as String),
                const Divider(height: 24),
                _buildDetailRow('Master Account', accountData['masterAccount'] as String),
                const Divider(height: 24),
                _buildDetailRow('Rate', ''),
                const SizedBox(height: 8),
                _buildRateSection(),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Total Value Section
          const Text(
            'Total Value',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildBalanceCard(
            null,
            '-- BTC',
            '≈ -- USDT',
          ),
          
          const SizedBox(height: 24),
          
          // Balance Grid
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spot',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSmallBalanceCard('-- BTC', '≈ -- USDT'),
                    const SizedBox(height: 16),
                    const Text(
                      'USD(S)-M Futures',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSmallBalanceCard('-- BTC', '≈ -- USDT'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Funding',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSmallBalanceCard('-- BTC', '≈ -- USDT'),
                    const SizedBox(height: 16),
                    const Text(
                      'Coin-M Futures',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSmallBalanceCard('-- BTC', '≈ -- USDT'),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Spot Section
          const Text(
            'Spot',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildBalanceCard(
            'Total Balance',
            '-- BTC',
            '≈ -- USDT',
          ),
        ],
      ),
    );
  }

  Widget _buildFundingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Funding',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Funding Balance
          _buildBalanceCard(
            'Total Balance',
            '-- BTC',
            '≈ -- USDT',
          ),
          
          const SizedBox(height: 20),
          
          // No records found
          _buildNoRecordsSection(),
          
          const SizedBox(height: 32),
          
          // USD(S)-M Futures Section
          const Text(
            'USD(S)-M Futures',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Margin Balance
          _buildBalanceCard(
            'Margin Balance',
            '-- BTC',
            '≈ -- USDT',
          ),
          
          const SizedBox(height: 16),
          
          // Wallet Balance and Unrealized PNL
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSmallBalanceCard('-- BTC', '≈ -- USDT'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unrealized PNL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSmallBalanceCard('-- BTC', '≈ -- USDT', valueColor: const Color(0xFF10B981)),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Position Section
          const Text(
            'Position',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildNoRecordsSection(),
          
          const SizedBox(height: 32),
          
          // Assets Section
          const Text(
            'Assets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildNoRecordsSection(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildRateSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1 BTC',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '≈ ${(accountData['btcRateUSD'] as double).toStringAsFixed(0)} USDT',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String? title, String btcValue, String usdValue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            btcValue,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            usdValue,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBalanceCard(String btcValue, String usdValue, {Color? valueColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            btcValue,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            usdValue,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRecordsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No records found.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}