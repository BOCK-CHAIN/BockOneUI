import 'package:flutter/material.dart';

class MobileCopyTradingScreen extends StatefulWidget {
  const MobileCopyTradingScreen({Key? key}) : super(key: key);

  @override
  State<MobileCopyTradingScreen> createState() => _MobileCopyTradingScreenState();
}

class _MobileCopyTradingScreenState extends State<MobileCopyTradingScreen> {
  int selectedFilter = 0; // 0: All Portfolios, 1: Favorites
  String selectedTimeframe = '30D';
  String selectedPnL = 'PnL';
  bool smartFilterEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Futures Copy',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
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
      ),
      body: Column(
        children: [
          // Top Filter Section
          _buildFilterSection(),
          
          // Traders List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Compare Banner
                  _buildCompareBanner(),
                  
                  // Trader Cards
                  ..._buildTraderCards(),
                  
                  // Promotion Banner
                  _buildPromotionBanner(),
                  
                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tab Bar
          Row(
            children: [
              _buildTab('All Portfolios', 0),
              const SizedBox(width: 24),
              _buildTab('Favorites', 1),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Daily Picks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Filter Row
          Row(
            children: [
              _buildDropdownFilter(selectedTimeframe, ['30D', '7D', '1D']),
              const SizedBox(width: 12),
              _buildDropdownFilter(selectedPnL, ['PnL', 'ROI', 'Win Rate']),
              const SizedBox(width: 12),
              _buildSmartFilter(),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '99+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'vs',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Icon(Icons.search, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 2,
              width: 40,
              color: const Color.fromARGB(255, 122, 79, 223),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(String value, List<String> options) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSmartFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: smartFilterEnabled ? Colors.black : Colors.transparent,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check,
            size: 16,
            color: smartFilterEnabled ? Colors.white : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            'Smart Filter',
            style: TextStyle(
              color: smartFilterEnabled ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Compare top lead traders',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Mock',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: const Color(0xFFFF6B6B),
                child: const Text(
                  'Full',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTraderCards() {
    final traders = [
      {
        'name': 'UsGguiY',
        'avatar': 'U',
        'followers': '1000/1000',
        'badge': null,
        'pnl': '+1,685,760.64',
        'pnlColor': Colors.green,
        'roi': '56.19%',
        'roiColor': Colors.green,
        'aum': '6,656,439.97',
        'mdd': '18.07%',
        'sharpeRatio': '--',
        'showChart': true,
      },
      {
        'name': 'YHW1',
        'avatar': 'Y',
        'followers': '178/200',
        'badge': null,
        'hasApi': true,
        'pnl': '+526,757.97',
        'pnlColor': Colors.green,
        'roi': '502.18%',
        'roiColor': Colors.green,
        'aum': '656,798.41',
        'mdd': '8.24%',
        'sharpeRatio': '--',
        'showChart': true,
      },
      {
        'name': '0Gravity',
        'avatar': 'G',
        'followers': '175/600',
        'badge': null,
        'pnl': '+436,463.82',
        'pnlColor': Colors.green,
        'roi': '35.09%',
        'roiColor': Colors.green,
        'aum': '869,360.23',
        'mdd': '18.07%',
        'sharpeRatio': '--',
        'showChart': true,
      },
    ];

    return traders.map((trader) => _buildTraderCard(trader)).toList();
  }

  Widget _buildTraderCard(Map<String, dynamic> trader) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Trader Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  trader['avatar'],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          trader['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (trader['badge'] != null) ...[
                          const SizedBox(width: 4),
                          Text(trader['badge']),
                        ],
                        if (trader['hasApi'] == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'API',
                              style: TextStyle(
                                color: Color.fromARGB(255, 122, 79, 223),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          trader['followers'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Mock',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Copy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats Section
          Row(
            children: [
              // Left Column - PnL and Chart
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$selectedTimeframe $selectedPnL',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trader['pnl'],
                      style: TextStyle(
                        color: trader['pnlColor'],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (trader['showChart'] == true) ...[
                      const SizedBox(height: 8),
                      _buildMiniChart(trader['pnlColor']),
                    ],
                  ],
                ),
              ),
              
              // Middle Column - ROI and MDD
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$selectedTimeframe ROI',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trader['roi'],
                      style: TextStyle(
                        color: trader['roiColor'],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$selectedTimeframe MDD',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trader['mdd'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Right Column - AUM and Sharpe Ratio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'AUM',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trader['aum'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sharpe Ratio',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trader['sharpeRatio'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChart(Color color) {
    return Container(
      height: 40,
      width: 80,
      child: CustomPaint(
        painter: MiniChartPainter(color),
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not satisfied with a leader? Start leading now and earn up to 30% profit!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Apply Now',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Text('', style: TextStyle(fontSize: 32)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.folder, color: Colors.black),
              SizedBox(height: 4),
              Text(
                'Portfolios',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.explore, color: Colors.grey),
              SizedBox(height: 4),
              Text(
                'Discover',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy, color: Colors.grey),
              SizedBox(height: 4),
              Text(
                'Copy',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MiniChartPainter extends CustomPainter {
  final Color color;

  MiniChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Simple upward trending line
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.5);
    path.lineTo(size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}