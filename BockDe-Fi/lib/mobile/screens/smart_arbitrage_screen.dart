import 'package:flutter/material.dart';

class SmartArbitrageScreen extends StatefulWidget {
  const SmartArbitrageScreen({Key? key}) : super(key: key);

  @override
  State<SmartArbitrageScreen> createState() => _SmartArbitrageScreenState();
}

class _SmartArbitrageScreenState extends State<SmartArbitrageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCurrency = 'BTC';
  
  final List<Map<String, dynamic>> tradingPairs = [
    {
      'asset': 'BTC/USDT',
      'icon': Icons.currency_bitcoin,
      'color': Colors.orange,
      'currentAPR': '6.64%',
      'thirtyDayAPR': '5.78%',
      'isActive': true,
    },
    {
      'asset': 'ETH/USDT',
      'icon': Icons.diamond,
      'color': Colors.blue,
      'currentAPR': '--',
      'thirtyDayAPR': '3.32%',
      'isActive': false,
    },
    {
      'asset': 'SOL/USDT',
      'icon': Icons.blur_circular,
      'color': Colors.purple,
      'currentAPR': '2.55%',
      'thirtyDayAPR': '5.04%',
      'isActive': true,
    },
    {
      'asset': 'XRP/USDT',
      'icon': Icons.close,
      'color': Colors.black,
      'currentAPR': '10.95%',
      'thirtyDayAPR': '6.57%',
      'isActive': true,
    },
    {
      'asset': 'DOGE/USDT',
      'icon': Icons.pets,
      'color': Colors.amber,
      'currentAPR': '3.69%',
      'thirtyDayAPR': '7.13%',
      'isActive': true,
    },
  ];

  final List<Map<String, dynamic>> faqData = [
    {
      'question': 'What is Smart Arbitrage?',
      'answer': 'Smart Arbitrage is an automated trading strategy that takes advantage of price differences across different exchanges to generate profit with minimal risk.'
    },
    {
      'question': 'How does APR calculation work?',
      'answer': 'APR (Annual Percentage Rate) is calculated based on historical trading performance and represents the potential yearly return on your investment.'
    },
    {
      'question': 'What are the risks involved?',
      'answer': 'While arbitrage is considered low-risk, there are still market risks, execution risks, and potential losses due to market volatility.'
    },
    {
      'question': 'How do I start trading?',
      'answer': 'Select a trading pair, review the APR rates, and click on the pair to begin automated arbitrage trading.'
    },
    {
      'question': 'What is the minimum investment?',
      'answer': 'Minimum investment varies by trading pair. Please check individual pair requirements before investing.'
    },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smart Arbitrage',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 122, 79, 223),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Home'),
            Tab(text: 'FAQ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(screenWidth, screenHeight),
          _buildFAQTab(screenWidth),
        ],
      ),
    );
  }

  Widget _buildHomeTab(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Robot illustration and balance section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total Balance',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.visibility_off,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              '-- ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCurrency,
                                  isDense: true,
                                  items: ['BTC', 'ETH', 'USDT']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCurrency = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '30-Day Profit',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '0.00 BTC',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Robot illustration placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Asset list header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Asset Name',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                const Text(
                  'Next APR',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Trading pairs list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tradingPairs.length,
              itemBuilder: (context, index) {
                final pair = tradingPairs[index];
                return _buildTradingPairCard(pair, screenWidth);
              },
            ),
            
            const SizedBox(height: 40),
            
            const Center(
              child: Text(
                'No more data',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTradingPairCard(Map<String, dynamic> pair, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Asset icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: pair['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              pair['icon'],
              color: pair['color'],
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Asset name
          Expanded(
            child: Text(
              pair['asset'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // APR information
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pair['currentAPR'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: pair['isActive'] 
                    ? (pair['currentAPR'] == '--' ? Colors.grey : Colors.green)
                    : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '30d APR: ${pair['thirtyDayAPR']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTab(double screenWidth) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqData.length,
              itemBuilder: (context, index) {
                return _buildFAQCard(faqData[index], screenWidth);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: 12,
            ),
            child: Text(
              faq['answer'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}