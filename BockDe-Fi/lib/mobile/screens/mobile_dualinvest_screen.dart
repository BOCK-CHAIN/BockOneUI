import 'package:flutter/material.dart';

class MobileDualInvestScreen extends StatefulWidget {
  const MobileDualInvestScreen({Key? key}) : super(key: key);

  @override
  State<MobileDualInvestScreen> createState() => _MobileDualInvestScreenState();
}

class _MobileDualInvestScreenState extends State<MobileDualInvestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCoinIndex = 0;
  int _selectedPairIndex = 0;

  final List<CoinData> coins = [
    CoinData('BTC', '₿', Colors.orange),
    CoinData('ETH', 'Ξ', Colors.blue),
    CoinData('BNB', 'BNB', Colors.yellow.shade600),
    CoinData('SOL', 'SOL', Colors.green),
    CoinData('XRP', 'XRP', Colors.grey.shade800),
  ];

  final List<String> tradingPairs = ['BTC/USDT', 'BTC/FDUSD', 'BTC/USDC'];

  final List<InvestmentOption> buyLowOptions = [
    InvestmentOption(112500, -0.54, 69.03),
    InvestmentOption(112000, -0.98, 43.12),
    InvestmentOption(111500, -1.42, 28.84),
    InvestmentOption(111000, -1.87, 19.03),
    InvestmentOption(110500, -2.31, 14.43),
  ];

  final List<InvestmentOption> sellHighOptions = [
    InvestmentOption(114000, 0.78, 45.23),
    InvestmentOption(114500, 1.24, 32.15),
    InvestmentOption(115000, 1.65, 25.67),
    InvestmentOption(115500, 2.12, 18.94),
    InvestmentOption(116000, 2.58, 13.28),
  ];

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dual Investment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // RFQ Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dual Investment RFQ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Request-for-Quote for Large Trades',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[300]!, Colors.grey[400]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bar_chart, color: Colors.white),
                ),
              ],
            ),
          ),

          // Tab Bar with Spot Price
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          tabs: const [
                            Tab(text: 'Buy Low'),
                            Tab(text: 'Sell High'),
                          ],
                        ),
                      ),
                      Text(
                        '${tradingPairs[_selectedPairIndex]} Spot Price ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Text(
                        '113,117',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Coin Selection
          Container(
            height: 80,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: coins.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedCoinIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCoinIndex = index;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: const Color.fromARGB(255, 122, 79, 223), width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: coins[index].color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              coins[index].symbol,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coins[index].name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Trading Pairs
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              children: tradingPairs.asMap().entries.map((entry) {
                final index = entry.key;
                final pair = entry.value;
                final isSelected = index == _selectedPairIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPairIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(6),
                      border: isSelected
                          ? Border.all(color: const Color.fromARGB(255, 122, 79, 223), width: 1)
                          : null,
                    ),
                    child: Text(
                      pair,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Settlement Date Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Settlement Date and Target Price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Date Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'All', '1 Day', '2 Days', '5 Days', '6 Days', '7 Days', '9 Days'
                    ].asMap().entries.map((entry) {
                      final index = entry.key;
                      final text = entry.value;
                      final isSelected = index == 0; // Default to 'All' selected
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Target Price',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'APR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Action',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Settlement Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Settled on Sep 25, 2025',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Investment Options List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Buy Low Tab
                _buildInvestmentList(buyLowOptions),
                // Sell High Tab
                _buildInvestmentList(sellHighOptions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentList(List<InvestmentOption> options) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        itemCount: options.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
        ),
        itemBuilder: (context, index) {
          final option = options[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.targetPrice.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${option.changePercent >= 0 ? '+' : ''}${option.changePercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: option.changePercent >= 0 ? Colors.green : const Color.fromARGB(255, 122, 79, 223),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${option.apr.toStringAsFixed(2)}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle subscribe action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: const Size(80, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Subscribe',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CoinData {
  final String name;
  final String symbol;
  final Color color;

  CoinData(this.name, this.symbol, this.color);
}

class InvestmentOption {
  final double targetPrice;
  final double changePercent;
  final double apr;

  InvestmentOption(this.targetPrice, this.changePercent, this.apr);
}