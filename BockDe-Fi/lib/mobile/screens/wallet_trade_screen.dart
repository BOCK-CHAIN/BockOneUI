import 'package:flutter/material.dart';

class WalletTradeScreen extends StatelessWidget {
  const WalletTradeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 18),
            tabs: [
              Tab(text: 'Swap'),
              Tab(text: 'Bridge'),
              Tab(text: 'Pro'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            SwapTab(),
            BridgeTab(),
            ProTab(),
          ],
        ),
      ),
    );
  }
}

// Swap Tab
class SwapTab extends StatefulWidget {
  const SwapTab({Key? key}) : super(key: key);

  @override
  State<SwapTab> createState() => _SwapTabState();
}

class _SwapTabState extends State<SwapTab> {
  bool useExchangeBalance = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('From', style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  const Text('Use Exchange Balance'),
                  Switch(
                    value: useExchangeBalance,
                    onChanged: (val) => setState(() => useExchangeBalance = val),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTokenCard(
            icon: Icons.currency_bitcoin,
            iconColor: const Color.fromARGB(255, 122, 79, 223),
            token: 'BNB',
            network: 'BNB Chain Native',
            amount: '1',
            value: '≈₹92,263.84',
            balance: '0',
          ),
          const SizedBox(height: 16),
          Center(
            child: IconButton(
              icon: const Icon(Icons.swap_vert, size: 32),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 16),
          const Text('To', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          _buildTokenCard(
            icon: Icons.attach_money,
            iconColor: Colors.teal,
            token: 'USDT',
            network: 'Tether USDT',
            amount: '1037.85253299',
            value: '≈₹92,132.28',
            balance: '0',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Insufficient BNB balance. Please top up.',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Route', 'Lifi', hasIcon: true),
          const Divider(),
          _buildDetailRow('Rate', '1 BNB ≈ 1,037.85253 USDT'),
          const Divider(),
          _buildDetailRow('Slippage', 'Auto | 0.5%', hasIcon: true, badge: 'Anti-MEV'),
          const Divider(),
          _buildDetailRow('Min. Received', '1,032.66327 USDT'),
          const Divider(),
          _buildDetailRow('Trading Fee', '0.5%', isFree: true),
        ],
      ),
    );
  }

  Widget _buildTokenCard({
    required IconData icon,
    required Color iconColor,
    required String token,
    required String network,
    required String amount,
    required String value,
    required String balance,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(network, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text(
                amount,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Wallet...daA2', style: TextStyle(color: Colors.grey.shade600)),
              Text(value, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('$balance ', style: const TextStyle(color: Colors.grey)),
              const Text('Add Funds', style: TextStyle(color: Color.fromARGB(255, 122, 79, 223))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool hasIcon = false, String? badge, bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Row(
            children: [
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(badge, style: const TextStyle(fontSize: 10, color: Colors.green)),
                ),
              const SizedBox(width: 8),
              if (isFree)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Free', style: TextStyle(fontSize: 10, color: Colors.green)),
                ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (hasIcon) const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

// Bridge Tab
class BridgeTab extends StatelessWidget {
  const BridgeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('From', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          _buildTokenCard(
            icon: Icons.currency_bitcoin,
            iconColor: const Color.fromARGB(255, 122, 79, 223),
            token: 'BNB',
            network: 'BNB Chain Native',
            amount: '1',
            value: '≈₹92,133.03',
          ),
          const SizedBox(height: 16),
          Center(
            child: IconButton(
              icon: const Icon(Icons.swap_vert, size: 32),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 16),
          const Text('To', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          _buildTokenCard(
            icon: Icons.currency_exchange,
            iconColor: Colors.blue,
            token: 'ETH',
            network: 'Ether',
            amount: '0.23634527',
            value: '≈₹92,018.23',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Insufficient BNB balance. Please top up.',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Route', 'Rango | ~2 mins'),
          const Divider(),
          _buildDetailRow('Rate', '1 BNB ≈ 0.23634 ETH'),
          const Divider(),
          _buildDetailRow('Network Fee', '0.00001284 BNB (₹1.18317)'),
          const Divider(),
          _buildDetailRow('Slippage', 'Auto | 1%'),
          const Divider(),
          _buildDetailRow('Min. Received', '0.23398 ETH'),
          const Divider(),
          _buildDetailRow('Trading Fee', '0.5%', isFree: true),
        ],
      ),
    );
  }

  Widget _buildTokenCard({
    required IconData icon,
    required Color iconColor,
    required String token,
    required String network,
    required String amount,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(token, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(network, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Wallet...daA2', style: TextStyle(color: Colors.grey.shade600)),
              Text(value, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Row(
            children: [
              if (isFree)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Free', style: TextStyle(fontSize: 10, color: Colors.green)),
                ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

// Pro Tab
class ProTab extends StatefulWidget {
  const ProTab({Key? key}) : super(key: key);

  @override
  State<ProTab> createState() => _ProTabState();
}

class _ProTabState extends State<ProTab> {
  bool isBuying = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with token info
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.attach_money, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('USDT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('\$1.00043', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.candlestick_chart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChartScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        // Buy/Sell toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isBuying = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isBuying ? Colors.green : Colors.grey.shade200,
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                    ),
                    child: Text(
                      'Buy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isBuying ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isBuying = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !isBuying ? Colors.red : Colors.grey.shade200,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                    ),
                    child: Text(
                      'Sell',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !isBuying ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Market info
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem('Market Cap', '\$7.99B'),
                    _buildInfoItem('24h vol', '\$994.58M'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem('Liquidity', '\$200.84M'),
                    _buildInfoItem('Holders', '38.11M'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '\$1.00043',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const Text('₹88.76 +0.01%', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                // Order form
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'BNB',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Value',
                    hintText: '₹',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                _buildOrderInfo(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your gas token balance may be insufficient to cover transaction fees.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Buy USDT', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      children: [
        _buildOrderRow('Available', '0 BNB'),
        _buildOrderRow('Est. Receive', '-- USDT'),
        _buildOrderRow('Trading Fee', '--'),
        _buildOrderRow('Wallet', 'My Wallet...daa2'),
      ],
    );
  }

  Widget _buildOrderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}

// Chart Screen
class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

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
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 16,
              child: Icon(Icons.attach_money, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('USDT', style: TextStyle(color: Colors.black, fontSize: 16)),
                Text('\$1.00044 +0.01%', style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.star_border, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: 'Price'),
                Tab(text: 'Info'),
                Tab(text: 'Data'),
                Tab(text: 'Audit'),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Price info
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('\$1.00044', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                              Text('₹88.76 +0.01%', style: TextStyle(color: Colors.green)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('MCap on BSC', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const Text('₹708.8B', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              const Text('24h Volume', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const Text('₹88.26B', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Chart placeholder
                    Container(
                      height: 300,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.show_chart, size: 64, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Candlestick Chart', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    // Time intervals
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: ['1s', '1m', '5m', '15m', '1h', '4h', '1d']
                            .map((t) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Chip(label: Text(t)),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Activities section
                    const DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.green,
                            tabs: [
                              Tab(text: 'Activities'),
                              Tab(text: 'Holders (38.11M)'),
                              Tab(text: 'My Position'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Order History Screen
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

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
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 16,
              child: Icon(Icons.attach_money, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('USDT', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              tabs: [
                Tab(text: 'Price'),
                Tab(text: 'Info'),
                Tab(text: 'Data'),
                Tab(text: 'Audit'),
              ],
            ),
            const SizedBox(height: 16),
            const DefaultTabController(
              length: 3,
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                tabs: [
                  Tab(text: 'Activities'),
                  Tab(text: 'Holders (38.11M)'),
                  Tab(text: 'My Position'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('All Txns', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTransactionItem('S', '-8.97K', '₹796.63K', '₹88.76', Colors.red),
                  _buildTransactionItem('S', '-3.84K', '₹341.25K', '₹88.76', Colors.red),
                  _buildTransactionItem('S', '-263.63', '₹23.4K', '₹88.76', Colors.red),
                  _buildTransactionItem('B', '+79.09', '₹7.02K', '₹88.76', Colors.green),
                  _buildTransactionItem('B', '+184.54', '₹16.38K', '₹88.76', Colors.green),
                  _buildTransactionItem('B', '+303.09', '₹26.9K', '₹88.76', Colors.green),
                  _buildTransactionItem('B', '+99.68', '₹8.85K', '₹88.76', Colors.green),
                  _buildTransactionItem('B', '+1.09K', '₹97.12K', '₹88.76', Colors.green),
                  _buildTransactionItem('B', '+110.24', '₹9.79K', '₹88.76', Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String type, String amount, String value, String price, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(type, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                const Text('2025-10-02 14:58:42', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(price, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}