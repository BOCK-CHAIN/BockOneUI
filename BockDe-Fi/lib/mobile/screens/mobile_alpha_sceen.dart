import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CoinData {
  final String name;
  final String symbol;
  final String logo;
  double price;
  double change24h;
  final double volume;
  final String volumeFormatted;
  final String priceInINR;

  CoinData({
    required this.name,
    required this.symbol,
    required this.logo,
    required this.price,
    required this.change24h,
    required this.volume,
    required this.volumeFormatted,
    required this.priceInINR,
  });
}

class MobileAlphaScreen extends StatefulWidget {
  @override
  _MobileAlphaScreenState createState() => _MobileAlphaScreenState();
}

class _MobileAlphaScreenState extends State<MobileAlphaScreen>
    with TickerProviderStateMixin {
  Timer? _priceUpdateTimer;
  final Random _random = Random();
  String _selectedFilter = 'All';
  
  final List<String> _filters = [
    'All', 'New', 'BSC', 'Ethereum', 'Solana', 'Base', 'Sonic', 'Sui'
  ];

  List<CoinData> _coins = [
    CoinData(
      name: 'ASTER',
      symbol: 'ASTER',
      logo: 'A',
      price: 0.69733,
      change24h: 10.44,
      volume: 50.76,
      volumeFormatted: '\$50.76M',
      priceInINR: '₹61.44',
    ),
    CoinData(
      name: 'JOJO',
      symbol: 'JOJO',
      logo: 'J',
      price: 0.11877,
      change24h: 74.71,
      volume: 22.87,
      volumeFormatted: '\$22.87M',
      priceInINR: '₹10.46',
    ),
    CoinData(
      name: 'AOP',
      symbol: 'AOP',
      logo: 'A',
      price: 0.052182,
      change24h: 51.85,
      volume: 14.32,
      volumeFormatted: '\$14.32M',
      priceInINR: '₹4.59783',
    ),
    CoinData(
      name: 'DL',
      symbol: 'DL',
      logo: 'DS',
      price: 0.010592,
      change24h: -44.34,
      volume: 11.39,
      volumeFormatted: '\$11.39M',
      priceInINR: '₹0.93333',
    ),
    CoinData(
      name: 'KOGE',
      symbol: 'KOGE',
      logo: '',
      price: 48.01,
      change24h: 0.04,
      volume: 554.08,
      volumeFormatted: '\$554.08M',
      priceInINR: '₹4,230.96',
    ),
    CoinData(
      name: 'WOD',
      symbol: 'WOD',
      logo: '',
      price: 0.067482,
      change24h: 0.23,
      volume: 288.13,
      volumeFormatted: '\$288.13M',
      priceInINR: '₹5.94587',
    ),
    CoinData(
      name: 'AICell',
      symbol: 'AICELL',
      logo: '',
      price: 0.0025009,
      change24h: 25.00,
      volume: 98.91,
      volumeFormatted: '\$98.91M',
      priceInINR: '₹0.22035',
    ),
    CoinData(
      name: 'STBL',
      symbol: 'STBL',
      logo: '',
      price: 0.23256,
      change24h: 29.93,
      volume: 95.32,
      volumeFormatted: '\$95.32M',
      priceInINR: '₹20.49',
    ),
    CoinData(
      name: 'TAKE',
      symbol: 'TAKE',
      logo: '',
      price: 0.18309,
      change24h: -5.33,
      volume: 92.60,
      volumeFormatted: '\$92.60M',
      priceInINR: '₹16.13',
    ),
    CoinData(
      name: 'TRADOOR',
      symbol: 'TRADOOR',
      logo: '',
      price: 2.92767,
      change24h: 42.85,
      volume: 79.25,
      volumeFormatted: '\$79.25M',
      priceInINR: '₹257.95',
    ),
    // Additional coins for demonstration
    CoinData(
      name: 'FLUID',
      symbol: 'FLUID',
      logo: '',
      price: 5.39755,
      change24h: 2.77,
      volume: 414.28,
      volumeFormatted: '\$414.28M',
      priceInINR: '₹475.68',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startPriceUpdates();
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }

  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        for (var coin in _coins) {
          // Simulate realistic price changes (±0.1% to ±2%)
          double changePercent = (_random.nextDouble() - 0.5) * 0.04; // ±2%
          coin.price = coin.price * (1 + changePercent);
          
          // Update 24h change with some volatility
          double changeVariation = (_random.nextDouble() - 0.5) * 2; // ±1%
          coin.change24h = coin.change24h + changeVariation;
        }
      });
    });
  }

  void _navigateToCoinDetail(CoinData coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinDetailScreen(coin: coin),
      ),
    );
  }

  Widget _buildCoinItem(CoinData coin) {
    return InkWell(
      onTap: () => _navigateToCoinDetail(coin),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Coin Logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 214, 214),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  coin.logo.isNotEmpty ? coin.logo : coin.symbol[0],
                  style: TextStyle(
                    fontSize: coin.logo.isNotEmpty ? 20 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 34, 34, 34),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            
            // Coin Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        coin.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    coin.volumeFormatted,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            // Price Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coin.price >= 1 
                      ? coin.price.toStringAsFixed(2)
                      : coin.price.toStringAsFixed(6),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  coin.priceInINR,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            
            SizedBox(width: 16),
            
            // Change Percentage
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: coin.change24h >= 0 ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${coin.change24h >= 0 ? '+' : ''}${coin.change24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Navigation Tabs
          /*Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildNavTab('Favorites', false),
                _buildNavTab('Market', false),
                _buildNavTab('Alpha', true),
                _buildNavTab('Grow', false),
                _buildNavTab('Square', false),
                _buildNavTab('Data', false),
              ],
            ),
          ),*/
          
          SizedBox(height: 16),
          
          // Filter Tabs
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                bool isSelected = _filters[index] == _selectedFilter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = _filters[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color.fromARGB(255, 122, 79, 223)! : Colors.grey[600]!,
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 16),
          
          // Header Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Name  / Vol ',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 58, 58, 58),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Text(
                  'Last Price ',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 41, 41, 41),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 60),
                Text(
                  '24h Chg% ',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 48, 48, 48),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Coin List
          Expanded(
            child: ListView.builder(
              itemCount: _coins.length,
              itemBuilder: (context, index) {
                return _buildCoinItem(_coins[index]);
              },
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.grey[800]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(Icons.home, 'Home', false),
            _buildBottomNavItem(Icons.trending_up, 'Markets', true),
            _buildBottomNavItem(Icons.swap_horiz, 'Trade', false),
            _buildBottomNavItem(Icons.description, 'Futures', false),
            _buildBottomNavItem(Icons.account_balance_wallet, 'Assets', false),
          ],
        ),
      ),*/
    );
  }

  Widget _buildNavTab(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : const Color.fromARGB(255, 39, 39, 39),
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            SizedBox(height: 4),
            Container(
              height: 3,
              width: 30,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.yellow[700] : Colors.grey[400],
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.yellow[700] : Colors.grey[400],
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// Coin Detail Screen (Second Image)
class CoinDetailScreen extends StatefulWidget {
  final CoinData coin;

  CoinDetailScreen({required this.coin});

  @override
  _CoinDetailScreenState createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen>
    with TickerProviderStateMixin {
  Timer? _chartUpdateTimer;
  List<double> _chartData = [];
  final Random _random = Random();
  String _selectedTimeframe = '1D';
  
  final List<String> _timeframes = ['15m', '1h', '4h', '1D', 'More'];

  @override
  void initState() {
    super.initState();
    _generateChartData();
    _startChartUpdates();
  }

  @override
  void dispose() {
    _chartUpdateTimer?.cancel();
    super.dispose();
  }

  void _generateChartData() {
    _chartData.clear();
    double basePrice = widget.coin.price;
    for (int i = 0; i < 50; i++) {
      double variation = (_random.nextDouble() - 0.5) * 0.1; // ±5% variation
      _chartData.add(basePrice * (1 + variation));
    }
  }

  void _startChartUpdates() {
    _chartUpdateTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        // Remove first element and add new one
        if (_chartData.isNotEmpty) {
          _chartData.removeAt(0);
        }
        double lastPrice = _chartData.isNotEmpty ? _chartData.last : widget.coin.price;
        double variation = (_random.nextDouble() - 0.5) * 0.02; // ±1% variation
        _chartData.add(lastPrice * (1 + variation));
        
        // Update coin price
        widget.coin.price = _chartData.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(Icons.water_drop, color: Colors.black, size: 16),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'FLUID',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: const Color.fromARGB(255, 26, 25, 25)),
          ],
        ),
        actions: [
          Icon(Icons.star_border, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.share, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.notifications_outlined, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Price Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Info',
                      style: TextStyle(color: const Color.fromARGB(255, 26, 25, 25), fontSize: 14),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Audit',
                      style: TextStyle(color: const Color.fromARGB(255, 32, 32, 32), fontSize: 14),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Square',
                      style: TextStyle(color: const Color.fromARGB(255, 32, 32, 32), fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  '\$${widget.coin.price.toStringAsFixed(5)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '+${widget.coin.change24h.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '0x6f40...d303eb',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 41, 41, 41),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.copy, color: const Color.fromARGB(255, 39, 39, 39), size: 12),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 156, 156, 156),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'DEX',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ETH',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Stats
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Market Cap', '\$414.28M'),
                _buildStatItem('On-chain Holders', '10,173'),
                _buildStatItem('On-chain Liquidity', '\$15.87M'),
                _buildStatItem('FDV', '\$539.76M'),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Timeframe Selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _timeframes.map((timeframe) {
                bool isSelected = timeframe == _selectedTimeframe;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimeframe = timeframe;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      timeframe,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color.fromARGB(255, 24, 24, 24),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Chart Area
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              child: CustomPaint(
                painter: ChartPainter(_chartData, widget.coin.price),
                child: Container(),
              ),
            ),
          ),
          
          // Trade Button
          Container(
            padding: EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Trade',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(255, 49, 49, 49),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final double currentPrice;

  ChartPainter(this.data, this.currentPrice);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    double minPrice = data.reduce((a, b) => a < b ? a : b);
    double maxPrice = data.reduce((a, b) => a > b ? a : b);
    
    if (maxPrice == minPrice) {
      maxPrice += 0.1;
      minPrice -= 0.1;
    }
    
    for (int i = 0; i < data.length; i++) {
      double x = (i / (data.length - 1)) * size.width;
      double y = size.height - ((data[i] - minPrice) / (maxPrice - minPrice)) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw current price line
    final currentPricePaint = Paint()
      ..color = const Color.fromARGB(255, 56, 56, 56)!
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    double currentY = size.height - ((currentPrice - minPrice) / (maxPrice - minPrice)) * size.height;
    canvas.drawLine(Offset(0, currentY), Offset(size.width, currentY), currentPricePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}