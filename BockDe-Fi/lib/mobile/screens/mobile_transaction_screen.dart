import 'package:flutter/material.dart';

class MobileTransactionScreen extends StatefulWidget {
  const MobileTransactionScreen({Key? key}) : super(key: key);

  @override
  State<MobileTransactionScreen> createState() => _MobileTransactionScreenState();
}

class _MobileTransactionScreenState extends State<MobileTransactionScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Deposit', 'Withdrawal', 'Trade', 'Transfer'];

  // Sample transaction data
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'Deposit',
      'amount': '+500.00',
      'currency': 'USDT',
      'date': '2025-10-24',
      'time': '14:30',
      'status': 'Completed',
      'icon': Icons.arrow_downward,
      'color': Colors.green,
    },
    {
      'type': 'Trade',
      'amount': '-0.05',
      'currency': 'BTC',
      'date': '2025-10-24',
      'time': '12:15',
      'status': 'Completed',
      'icon': Icons.swap_horiz,
      'color': Color.fromARGB(255, 122, 79, 223),
    },
    {
      'type': 'Withdrawal',
      'amount': '-100.00',
      'currency': 'USDT',
      'date': '2025-10-23',
      'time': '16:45',
      'status': 'Completed',
      'icon': Icons.arrow_upward,
      'color': Colors.red,
    },
    {
      'type': 'Deposit',
      'amount': '+1000.00',
      'currency': 'USDT',
      'date': '2025-10-23',
      'time': '10:20',
      'status': 'Completed',
      'icon': Icons.arrow_downward,
      'color': Colors.green,
    },
    {
      'type': 'Trade',
      'amount': '+2.5',
      'currency': 'ETH',
      'date': '2025-10-22',
      'time': '09:30',
      'status': 'Completed',
      'icon': Icons.swap_horiz,
      'color': Color.fromARGB(255, 122, 79, 223),
    },
    {
      'type': 'Transfer',
      'amount': '-50.00',
      'currency': 'USDT',
      'date': '2025-10-22',
      'time': '18:00',
      'status': 'Pending',
      'icon': Icons.send,
      'color': Colors.orange,
    },
    {
      'type': 'Deposit',
      'amount': '+750.00',
      'currency': 'USDT',
      'date': '2025-10-21',
      'time': '11:15',
      'status': 'Completed',
      'icon': Icons.arrow_downward,
      'color': Colors.green,
    },
    {
      'type': 'Withdrawal',
      'amount': '-200.00',
      'currency': 'USDT',
      'date': '2025-10-20',
      'time': '15:30',
      'status': 'Failed',
      'icon': Icons.arrow_upward,
      'color': Colors.red,
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == 'All') {
      return _transactions;
    }
    return _transactions.where((tx) => tx['type'] == _selectedFilter).toList();
  }

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
          'Transaction History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterBottomSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 122, 79, 223),
                  Color.fromARGB(255, 142, 99, 243),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total\nTransactions', '${_transactions.length}'),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildStatItem('This\nMonth', '5'),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildStatItem('Pending', '1'),
              ],
            ),
          ),

          // Filter Chips
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color.fromARGB(255, 122, 79, 223),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Transaction List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return _buildTransactionCard(transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: transaction['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            transaction['icon'],
            color: transaction['color'],
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              transaction['type'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Text(
              '${transaction['amount']} ${transaction['currency']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: transaction['amount'].startsWith('+')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${transaction['date']} ${transaction['time']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    transaction['status'],
                    style: TextStyle(
                      color: _getStatusColor(transaction['status']),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          _showTransactionDetails(transaction);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transaction history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ..._filters.map((filter) {
                return ListTile(
                  title: Text(filter),
                  trailing: _selectedFilter == filter
                      ? const Icon(
                          Icons.check,
                          color: Color.fromARGB(255, 122, 79, 223),
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Type', transaction['type']),
              _buildDetailRow('Amount', '${transaction['amount']} ${transaction['currency']}'),
              _buildDetailRow('Date', transaction['date']),
              _buildDetailRow('Time', transaction['time']),
              _buildDetailRow('Status', transaction['status']),
              _buildDetailRow('Transaction ID', 'TXN${DateTime.now().millisecondsSinceEpoch}'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Download receipt functionality
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Receipt'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 122, 79, 223),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 122, 79, 223),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}