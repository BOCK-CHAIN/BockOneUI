import 'package:flutter/material.dart';

class MobileHistoryScreen extends StatefulWidget {
  const MobileHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MobileHistoryScreen> createState() => _MobileHistoryScreenState();
}

class _MobileHistoryScreenState extends State<MobileHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sample activity history data
  final List<Map<String, dynamic>> _activityHistory = [
    {
      'action': 'Login',
      'description': 'Successful login from mobile device',
      'timestamp': '2025-10-24 14:30:25',
      'icon': Icons.login,
      'color': Colors.green,
    },
    {
      'action': 'Password Changed',
      'description': 'Password was successfully changed',
      'timestamp': '2025-10-23 16:45:10',
      'icon': Icons.lock_reset,
      'color': Colors.orange,
    },
    {
      'action': 'Two-Factor Authentication Enabled',
      'description': 'Security enhanced with 2FA',
      'timestamp': '2025-10-22 11:20:00',
      'icon': Icons.security,
      'color': Color.fromARGB(255, 122, 79, 223),
    },
    {
      'action': 'Email Updated',
      'description': 'Email address was changed',
      'timestamp': '2025-10-21 09:15:45',
      'icon': Icons.email,
      'color': Colors.blue,
    },
    {
      'action': 'Failed Login Attempt',
      'description': 'Failed login from unknown device',
      'timestamp': '2025-10-20 18:30:12',
      'icon': Icons.warning,
      'color': Colors.red,
    },
  ];

  // Sample trading history
  final List<Map<String, dynamic>> _tradingHistory = [
    {
      'pair': 'BTC/USDT',
      'type': 'Buy',
      'amount': '0.05 BTC',
      'price': '\$64,250.00',
      'total': '\$3,212.50',
      'timestamp': '2025-10-24 12:15:30',
      'status': 'Completed',
    },
    {
      'pair': 'ETH/USDT',
      'type': 'Sell',
      'amount': '2.5 ETH',
      'price': '\$3,200.00',
      'total': '\$8,000.00',
      'timestamp': '2025-10-22 09:30:15',
      'status': 'Completed',
    },
    {
      'pair': 'SOL/USDT',
      'type': 'Buy',
      'amount': '10 SOL',
      'price': '\$237.41',
      'total': '\$2,374.10',
      'timestamp': '2025-10-21 16:45:22',
      'status': 'Completed',
    },
  ];

  // Sample login history
  final List<Map<String, dynamic>> _loginHistory = [
    {
      'device': 'iPhone 14 Pro',
      'location': 'Bengaluru, India',
      'ip': '192.168.1.1',
      'timestamp': '2025-10-24 14:30:25',
      'status': 'Success',
    },
    {
      'device': 'Chrome on Windows',
      'location': 'Mumbai, India',
      'ip': '192.168.1.2',
      'timestamp': '2025-10-23 10:15:40',
      'status': 'Success',
    },
    {
      'device': 'Unknown Device',
      'location': 'Unknown Location',
      'ip': '123.456.789.0',
      'timestamp': '2025-10-20 18:30:12',
      'status': 'Failed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color.fromARGB(255, 122, 79, 223),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color.fromARGB(255, 122, 79, 223),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Activity'),
            Tab(text: 'Trading'),
            Tab(text: 'Login'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivityTab(),
          _buildTradingTab(),
          _buildLoginTab(),
        ],
      ),
    );
  }

  // Activity Tab
  Widget _buildActivityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activityHistory.length,
      itemBuilder: (context, index) {
        final activity = _activityHistory[index];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['action'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      activity['timestamp'],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Trading Tab
  Widget _buildTradingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tradingHistory.length,
      itemBuilder: (context, index) {
        final trade = _tradingHistory[index];
        return _buildTradingCard(trade);
      },
    );
  }

  Widget _buildTradingCard(Map<String, dynamic> trade) {
    final isBuy = trade['type'] == 'Buy';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      trade['type'],
                      style: TextStyle(
                        color: isBuy ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    trade['pair'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trade['status'],
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTradeDetailRow('Amount', trade['amount']),
          _buildTradeDetailRow('Price', trade['price']),
          _buildTradeDetailRow('Total', trade['total'], isHighlight: true),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                trade['timestamp'],
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradeDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              fontSize: isHighlight ? 16 : 14,
              color: isHighlight ? const Color.fromARGB(255, 122, 79, 223) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Login Tab
  Widget _buildLoginTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _loginHistory.length,
      itemBuilder: (context, index) {
        final login = _loginHistory[index];
        return _buildLoginCard(login);
      },
    );
  }

  Widget _buildLoginCard(Map<String, dynamic> login) {
    final isSuccess = login['status'] == 'Success';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSuccess ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.cancel,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    login['status'],
                    style: TextStyle(
                      color: isSuccess ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (!isSuccess)
                IconButton(
                  icon: const Icon(Icons.report, color: Colors.red),
                  onPressed: () {
                    _showReportDialog();
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLoginDetailRow(Icons.devices, 'Device', login['device']),
          _buildLoginDetailRow(Icons.location_on, 'Location', login['location']),
          _buildLoginDetailRow(Icons.language, 'IP Address', login['ip']),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                login['timestamp'],
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.report, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text('Report Suspicious Activity'),
            ],
          ),
          content: const Text(
            'If you don\'t recognize this login attempt, we recommend changing your password immediately and enabling two-factor authentication.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to change password screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Change Password'),
            ),
          ],
        );
      },
    );
  }
}