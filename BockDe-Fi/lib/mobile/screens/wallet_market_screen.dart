import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Main Wallet Market Screen
class WalletMarketScreen extends StatelessWidget {
  const WalletMarketScreen({Key? key}) : super(key: key);

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
            indicatorColor: Color.fromARGB(255, 122, 79, 223),
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            tabs: [
              Tab(text: 'Markets'),
              Tab(text: 'Signals'),
              Tab(child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Leaderboard'),
                  SizedBox(width: 4),
                  Badge(
                    label: Text('New', style: TextStyle(fontSize: 10)),
                    backgroundColor: Color.fromARGB(255, 122, 79, 223),
                    textColor: Colors.black,
                  ),
                ],
              )),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MarketsTab(),
            SignalsTab(),
            LeaderboardTab(),
          ],
        ),
      ),
    );
  }
}

// Markets Tab with Watchlist, Trending, Newest
class MarketsTab extends StatefulWidget {
  const MarketsTab({Key? key}) : super(key: key);

  @override
  State<MarketsTab> createState() => _MarketsTabState();
}

class _MarketsTabState extends State<MarketsTab> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Token symbol or contract address',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              suffixIcon: Icon(Icons.copy_outlined, color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        
        // Featured cards
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFeatureCard('Alpha', Colors.grey[200]!),
              const SizedBox(width: 12),
              _buildFeatureCard('Meme Rush', Colors.grey[200]!),
              const SizedBox(width: 12),
              _buildFeatureCard('Plasma', Colors.grey[200]!, percentage: '+16.01%'),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Sub tabs
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color.fromARGB(255, 122, 79, 223),
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            tabs: const [
              Tab(text: 'Watchlist'),
              Tab(text: 'Trending'),
              Tab(text: 'Newest'),
            ],
          ),
        ),
        
        // Filter chips
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', true),
                const SizedBox(width: 8),
                _buildFilterChip('BSC', false),
                const SizedBox(width: 8),
                _buildFilterChip('Solana', false),
                const SizedBox(width: 8),
                _buildFilterChip('Ethereum', false),
                const SizedBox(width: 8),
                _buildFilterChip('Base', false),
                const SizedBox(width: 8),
                _buildFilterChip('Sonic', false),
              ],
            ),
          ),
        ),
        
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              CoinListView(type: 'watchlist'),
              CoinListView(type: 'trending'),
              CoinListView(type: 'newest'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, Color color, {String? icon, String? percentage}) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (icon != null)
            Text(icon, style: const TextStyle(fontSize: 40))
          else if (percentage != null)
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          Row(
            children: [
              Text(
                'Go',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 122, 79, 223),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16, color: const Color.fromARGB(255, 122, 79, 223)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (selected) const Icon(Icons.public, size: 16, color: Colors.white),
          if (selected) const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Coin List View
class CoinListView extends StatefulWidget {
  final String type;
  
  const CoinListView({Key? key, required this.type}) : super(key: key);

  @override
  State<CoinListView> createState() => _CoinListViewState();
}

class _CoinListViewState extends State<CoinListView> {
  late Timer _timer;
  final List<CoinData> coins = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeCoins();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _updatePrices();
        });
      }
    });
  }

  void _initializeCoins() {
    if (widget.type == 'watchlist') {
      coins.addAll([
        CoinData('BNB', '₹91,810.71', '₹1.69B', '₹12.78T', -0.1, true, true),
        CoinData('ETH', '₹389,035.41', '₹623.77M', '₹46.96T', 0.09, true, false),
        CoinData('BTC', '₹10,554,557.55', '₹0', '₹1.36T', 0.0, false, false),
      ]);
    } else {
      coins.addAll([
        CoinData('TRUTH', '₹1.42713', '₹827.09K', '₹2.98B', -5.36, false, false, verified: true),
        CoinData('STRIKE', '₹2.01869', '₹64.02M', '₹4.04B', -4.55, false, false, verified: true),
        CoinData('KOGE', '₹4,260.59', '₹2.97B', '₹14.4B', -0.05, false, false, verified: true),
        CoinData('ASTER', '₹154.2', '₹1.17B', '₹1.23T', 0.97, false, false, verified: true),
        CoinData('quq', '₹0.19535', '₹2.87B', '₹172.03M', 0.0, false, false, verified: true),
        CoinData('COAI', '₹41.35', '₹399.91M', '₹41.36B', 18.91, false, false, verified: true),
        CoinData('ALEO', '₹20.58', '₹1.02B', '₹461.35M', 0.17, false, false, verified: true),
      ]);
    }
  }

  void _updatePrices() {
    for (var coin in coins) {
      double change = (_random.nextDouble() - 0.5) * 2;
      coin.changePercent += change * 0.1;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Vol  / Market Cap ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Last Price  / Change ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            itemCount: coins.length,
            itemBuilder: (context, index) {
              return _buildCoinItem(coins[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCoinItem(CoinData coin) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoinDetailScreen(coin: coin),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // Coin icon and info
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.primaries[coin.name.hashCode % Colors.primaries.length].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        coin.name[0],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                              coin.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (coin.hasMultiplePeople)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.people, size: 16, color: Colors.green),
                              ),
                            if (coin.hasCheckmark)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.verified, size: 16, color: Colors.green),
                              ),
                            if (coin.verified)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.verified, size: 12, color: Color.fromARGB(255, 122, 79, 223)),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Color.fromARGB(255, 122, 79, 223)),
                            const SizedBox(width: 4),
                            Text(
                              coin.volume,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              coin.marketCap,
                              style: TextStyle(
                                color: Colors.grey[600],
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
            ),
            
            // Price and change
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    coin.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${coin.changePercent >= 0 ? '+' : ''}${coin.changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: coin.changePercent >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
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

// Coin Data Model
class CoinData {
  String name;
  String price;
  String volume;
  String marketCap;
  double changePercent;
  bool hasMultiplePeople;
  bool hasCheckmark;
  bool verified;

  CoinData(
    this.name,
    this.price,
    this.volume,
    this.marketCap,
    this.changePercent,
    this.hasMultiplePeople,
    this.hasCheckmark, {
    this.verified = false,
  });
}

// Coin Detail Screen
class CoinDetailScreen extends StatefulWidget {
  final CoinData coin;

  const CoinDetailScreen({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedTimeframe = '1m';
  late Timer _timer;
  final List<double> priceData = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generatePriceData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updatePriceData();
        });
      }
    });
  }

  void _generatePriceData() {
    double basePrice = 0.022;
    for (int i = 0; i < 50; i++) {
      priceData.add(basePrice + (_random.nextDouble() - 0.5) * 0.002);
    }
  }

  void _updatePriceData() {
    priceData.removeAt(0);
    priceData.add(priceData.last + (_random.nextDouble() - 0.5) * 0.0005);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

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
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text('S', style: TextStyle(fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.coin.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  '\$0.02279 -15.62%',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.star_border, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color.fromARGB(255, 122, 79, 223),
              tabs: const [
                Tab(text: 'Price'),
                Tab(text: 'Info'),
                Tab(text: 'Data'),
                Tab(text: 'Audit'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPriceTab(),
                const Center(child: Text('Info Tab')),
                const Center(child: Text('Data Tab')),
                const Center(child: Text('Audit Tab')),
              ],
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildPriceTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\$0.022801',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹2.02315  -15.58%',
                  style: TextStyle(fontSize: 16, color: Colors.red[400]),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem('MCap on BSC', '₹424.66M'),
                    _buildInfoItem('24h Volume', '₹2.27B'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem('Liquidity', '₹79.2M'),
                    _buildInfoItem('Holders', '3.26K'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem('Top 10', '95.91%'),
                    Container(),
                  ],
                ),
              ],
            ),
          ),
          
          // Timeframe selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['1s', '1m', '5m', '15m', '1h', '4h', '1d'].map((time) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(time),
                      selected: selectedTimeframe == time,
                      onSelected: (selected) {
                        setState(() {
                          selectedTimeframe = time;
                        });
                      },
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                        color: selectedTimeframe == time ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Chart
          SizedBox(
            height: 250,
            child: CustomPaint(
              painter: ChartPainter(priceData),
              child: Container(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Volume chart
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Vol',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: VolumePainter(),
              child: Container(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // MA indicators
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              children: const [
                Chip(label: Text('MA', style: TextStyle(fontSize: 11)), backgroundColor: Colors.grey),
                Chip(label: Text('EMA', style: TextStyle(fontSize: 11)), backgroundColor: Colors.grey),
                Chip(label: Text('BOLL', style: TextStyle(fontSize: 11)), backgroundColor: Colors.grey),
                Chip(label: Text('SAR', style: TextStyle(fontSize: 11)), backgroundColor: Colors.grey),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Activities section
          _buildActivitiesSection(),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          child: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromARGB(255, 122, 79, 223),
            isScrollable: true,
            tabs: [
              Tab(text: 'Activities'),
              Tab(text: 'Holders (3.26K)'),
              Tab(text: 'My Position'),
              Tab(text: 'C'),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTransactionItem('S', '-9.08K', '₹18.36K', '₹2.02223', Colors.red),
              _buildTransactionItem('B', '+2.04K', '₹4.13K', '₹2.02321', Colors.green),
              _buildTransactionItem('S', '-4.07K', '₹8.24K', '₹2.02295', Colors.red),
              _buildTransactionItem('B', '+3.36K', '₹6.79K', '₹2.02341', Colors.green),
              _buildTransactionItem('S', '-5.33K', '₹10.79K', '₹2.02315', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(String type, String amount, String value, String price, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                type,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color),
                ),
                Text(
                  '2025-10-02 14:27:37',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                price,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(Icons.launch, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Trade',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Quick Buy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Chart Painter
class ChartPainter extends CustomPainter {
  final List<double> data;

  ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = const Color.fromARGB(255, 122, 79, 223)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    final double maxValue = data.reduce((a, b) => a > b ? a : b);
    final double minValue = data.reduce((a, b) => a < b ? a : b);
    final double range = maxValue - minValue;
    
    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * size.width;
      final double y = size.height - ((data[i] - minValue) / range) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw candlesticks
    final candlePaint = Paint()..style = PaintingStyle.fill;
    final double candleWidth = size.width / data.length * 0.6;

    for (int i = 0; i < data.length; i++) {
      final double x = (i / (data.length - 1)) * size.width;
      final double y = size.height - ((data[i] - minValue) / range) * size.height;
      
      bool isGreen = i > 0 ? data[i] > data[i - 1] : true;
      candlePaint.color = isGreen ? Colors.green : Colors.red;
      
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: candleWidth,
          height: 8,
        ),
        candlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) => true;
}

// Volume Painter
class VolumePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Random random = Random();
    final paint = Paint()..style = PaintingStyle.fill;
    
    final int barCount = 50;
    final double barWidth = size.width / barCount * 0.8;
    
    for (int i = 0; i < barCount; i++) {
      final double x = (i / barCount) * size.width;
      final double height = random.nextDouble() * size.height;
      final bool isGreen = random.nextBool();
      
      paint.color = isGreen ? Colors.green : Colors.red;
      
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - height, barWidth, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(VolumePainter oldDelegate) => false;
}

// Signals Tab
class SignalsTab extends StatefulWidget {
  const SignalsTab({Key? key}) : super(key: key);

  @override
  State<SignalsTab> createState() => _SignalsTabState();
}

class _SignalsTabState extends State<SignalsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color.fromARGB(255, 122, 79, 223),
            tabs: const [
              Tab(text: 'Sentiment'),
              Tab(text: 'Smart Money'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              SentimentView(),
              SmartMoneyView(),
            ],
          ),
        ),
      ],
    );
  }
}

// Sentiment View
class SentimentView extends StatelessWidget {
  const SentimentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSignalCard(
          'XPL',
          '₹86.1',
          'MCap ₹5.35B',
          '10-01 08:04:54',
          'Negative',
          'Hype Growth 155.99%',
          'Mainnet Beta Launch & Airdrop, Significant Whale Purchase, Price Drop Post ATH',
          true,
        ),
        const SizedBox(height: 16),
        _buildSignalCard(
          'SUI',
          '₹318.34',
          'MCap ₹3.18T',
          '10-01 06:50:04',
          'Negative',
          'Hype Growth 165.01%',
          'Major Token Unlock, Price Drop, Coinbase Futures Listing',
          true,
        ),
        const SizedBox(height: 16),
        _buildSignalCard(
          'EDEN',
          '₹34.58',
          'MCap ₹6.36B',
          '09-30 17:04:55',
          'Positive',
          'Hype Growth 112.50%',
          'OpenEden EDEN Launch, BOCK De-Fi HODLer Airdrop, KuCoin Listing',
          false,
        ),
      ],
    );
  }

  Widget _buildSignalCard(
    String symbol,
    String price,
    String marketCap,
    String timestamp,
    String sentiment,
    String hypeGrowth,
    String description,
    bool isNegative,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.primaries[symbol.hashCode % Colors.primaries.length].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    symbol[0],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                          symbol,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.people, size: 16, color: Colors.green),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          price,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          marketCap,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                timestamp,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Trade', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isNegative ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isNegative ? Icons.trending_down : Icons.trending_up,
                      size: 16,
                      color: isNegative ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sentiment,
                      style: TextStyle(
                        color: isNegative ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                hypeGrowth,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.trending_up, size: 16, color: Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
          const SizedBox(height: 8),
          const Text(
            'View Details',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 122, 79, 223),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.military_tech, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Token Matching & Content Generation by AI',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Smart Money View
class SmartMoneyView extends StatelessWidget {
  const SmartMoneyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSmartMoneyCard(
          '4',
          '4 Smart Money bought ₹1,356,570.95 within 12 mins',
          'Expired',
          '₹1.91976',
          '₹1.92B',
          '+9189.22%',
          67,
        ),
        const SizedBox(height: 16),
        _buildSmartMoneyCard(
          'FLYWHEEL',
          '4 Smart Money bought ₹448,863.76 within 15 mins',
          'Expired',
          '₹58.53',
          '₹58.53M',
          '+38.07%',
          0,
        ),
      ],
    );
  }

  Widget _buildSmartMoneyCard(
    String symbol,
    String description,
    String status,
    String price,
    String marketCap,
    String gain,
    int count,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.primaries[symbol.hashCode % Colors.primaries.length].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    symbol[0],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '10-02 11:45:52',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Trade', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.arrow_upward, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.grey[200],
            color: Colors.grey[400],
            minHeight: 4,
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Signal Price',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      price,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Highest Gain',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      gain,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MCap',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      marketCap,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomPaint(
                    painter: MiniChartPainter(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: Color.fromARGB(255, 122, 79, 223)),
                const SizedBox(width: 8),
                Text(
                  'What is \$symbol? - AI Generated',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mini Chart Painter
class MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final Random random = Random();
    
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.3);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MiniChartPainter oldDelegate) => false;
}

// Leaderboard Tab
class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({Key? key}) : super(key: key);

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  String selectedChain = 'Solana';
  String selectedTimeframe = '7D';
  String selectedFilter = 'PnL High to Low';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chain selector
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildChainChip('Solana', true),
              const SizedBox(width: 8),
              _buildChainChip('BSC', false),
            ],
          ),
        ),
        
        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildDropdown('PnL High to Low'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown('7D'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDropdown('All'),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildLeaderCard('Cented', 'KOL', '+\$178.64K', '+18.02%', 58.57, 1081, true),
              const SizedBox(height: 12),
              _buildLeaderCard('Cupsey', 'KOL', '+\$108.21K', '+14.88%', 61.85, 1779, false),
              const SizedBox(height: 12),
              _buildLeaderCard('S', 'KOL', '+\$95.97K', '+125.93%', 29.55, 50, false),
              const SizedBox(height: 12),
              _buildLeaderCard('rayan', 'KOL', '+\$89.45K', '+22.15%', 55.20, 892, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChainChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 20),
        ],
      ),
    );
  }

  Widget _buildLeaderCard(
    String name,
    String badge,
    String pnl,
    String percentage,
    double winRate,
    int trades,
    bool showFullChart,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.primaries[name.hashCode % Colors.primaries.length].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                          name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        /*const Text(
                          '🇨🇦',
                          style: TextStyle(fontSize: 16),
                        ),*/
                        const SizedBox(width: 4),
                        const Icon(Icons.copy, size: 14, color: Colors.grey),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            badge,
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7D Realized PnL',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      pnl,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      percentage,
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Win Rate',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            Text(
                              '${winRate.toStringAsFixed(2)}%',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Traded Tokens',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            Text(
                              trades.toString(),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                height: 80,
                child: CustomPaint(
                  painter: LeaderChartPainter(showFullChart),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Leader Chart Painter
class LeaderChartPainter extends CustomPainter {
  final bool showFullChart;

  LeaderChartPainter(this.showFullChart);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final double barWidth = size.width / 7 * 0.7;
    final List<double> heights = showFullChart
        ? [0.6, 0.55, 0.1, 0.65, 0.7, 0.95, 0.35]
        : [0.8, 0.6, 0.5, 0.7, 0.75, 0.85, 0.4];

    for (int i = 0; i < 7; i++) {
      final double x = (i / 6) * (size.width - barWidth);
      final double height = heights[i] * size.height;
      
      paint.color = Colors.green;
      
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - height, barWidth, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(LeaderChartPainter oldDelegate) => false;
}