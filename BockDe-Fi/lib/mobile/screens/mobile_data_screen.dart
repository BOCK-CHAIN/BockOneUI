import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileDataScreen extends StatefulWidget {
  @override
  _MobileDataScreenState createState() => _MobileDataScreenState();
}

class _MobileDataScreenState extends State<MobileDataScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  
  // Mock data that updates in real-time
  double solPrice = 241.50;
  double solChange = -2.21;
  double aiScore = 7.66;
  
  int upCount = 241;
  int downCount = 1254;
  
  Map<String, dynamic> hotCoins = {
    'BNB': {'price': 990.89, 'change': -0.59},
    'BTC': {'price': 116245.83, 'change': -1.00},
    'ETH': {'price': 4521.50, 'change': -1.41},
  };
  
  List<Map<String, dynamic>> topMovers = [
    {'symbol': 'LUNA/USDT', 'type': 'Pullback', 'change': -5.71, 'time': '18:30:21'},
    {'symbol': 'SFP/USDT', 'type': 'Pullback', 'change': -7.76, 'time': '18:30:21'},
    {'symbol': 'SFP/BTC', 'type': 'Pullback', 'change': -7.21, 'time': '18:30:21'},
    {'symbol': 'METIS/USDT', 'type': 'Pullback', 'change': -8.61, 'time': '18:30:22'},
    {'symbol': 'W/USDT', 'type': 'Pullback', 'change': -13.28, 'time': '18:30:22'},
  ];
  
  Map<String, dynamic> tradingData = {
    'marginDebtGrowth': -3.76,
    'longShortRatio': 18.50,
    'openInterest': 754234260.34,
    'topTraderRatio': 1.24,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Update data every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _updateData();
    });
  }

  void _updateData() {
    setState(() {
      // Update SOL data
      solPrice += (Random().nextDouble() - 0.5) * 5;
      solChange = (Random().nextDouble() - 0.5) * 5;
      aiScore = 6.5 + Random().nextDouble() * 2;
      
      // Update counts
      upCount = 200 + Random().nextInt(100);
      downCount = 1200 + Random().nextInt(200);
      
      // Update hot coins
      hotCoins.forEach((key, value) {
        value['change'] = (Random().nextDouble() - 0.5) * 4;
      });
      
      // Update top movers
      for (var mover in topMovers) {
        mover['change'] = -Random().nextDouble() * 15;
      }
      
      // Update trading data
      tradingData['marginDebtGrowth'] = (Random().nextDouble() - 0.5) * 10;
      tradingData['longShortRatio'] = 15 + Random().nextDouble() * 10;
      tradingData['openInterest'] = 700000000 + Random().nextDouble() * 100000000;
      tradingData['topTraderRatio'] = 1 + Random().nextDouble() * 0.5;
    });
    
    _animationController.forward().then((_) {
      _animationController.reset();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*_buildTabs(),
              SizedBox(height: 20),*/
              _buildAISelect(),
              SizedBox(height: 20),
              _buildPriceDistribution(),
              SizedBox(height: 20),
              _buildHotCoins(),
              SizedBox(height: 20),
              _buildZones(),
              SizedBox(height: 20),
              _buildHeatmap(),
              SizedBox(height: 20),
              _buildTopMovers(),
              SizedBox(height: 20),
              _buildTradingData(),
            ],
          ),
        ),
      ),
    );
  }



  /*Widget _buildTabs() {
    return Row(
      children: [
        _buildTab('Favorites', false),
        _buildTab('Market', false),
        _buildTab('Alpha', false),
        _buildTab('Grow', false),
        _buildTab('Square', false),
        _buildTab('Data', true),
      ],
    );
  }*/

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: isSelected ? Border(bottom: BorderSide(color: const Color.fromARGB(255, 122, 79, 223), width: 2)) : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAISelect() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AI Select', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.blue, size: 16),
                  Text(' Powered by AI', style: TextStyle(color: Colors.blue)),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('SOL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SOL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Text(
                              '${solPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${solChange.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: solChange < 0 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${aiScore.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Strong Positive', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Price Change Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
        SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                flex: upCount,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: downCount,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Up: $upCount', style: TextStyle(color: Colors.grey[600])),
            Text('Down: $downCount', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  Widget _buildHotCoins() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hot Coins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: hotCoins.entries.map((entry) => Expanded(
            child: _buildHotCoinCard(entry.key, entry.value),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildHotCoinCard(String symbol, Map<String, dynamic> data) {
    Color changeColor = data['change'] < 0 ? Colors.red : Colors.green;
    
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getCoinIcon(symbol),
              SizedBox(width: 4),
              Text(symbol, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _formatPrice(data['price']),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '${data['change'].toStringAsFixed(2)}%',
            style: TextStyle(color: changeColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _getCoinIcon(String symbol) {
    Map<String, Color> colors = {
      'BNB': Colors.yellow[700]!,
      'BTC': Colors.orange,
      'ETH': Colors.blue,
    };
    
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: colors[symbol] ?? Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          symbol[0],
          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price > 10000) {
      return '${(price / 1000).toStringAsFixed(1)}K';
    }
    return price.toStringAsFixed(2);
  }

  Widget _buildZones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Zones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildZoneCard('BNB Chain', 'TWT', '+29.50%')),
            Expanded(child: _buildZoneCard('Infrastructure', 'TWT', '+29.50%')),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildZoneCard('Monitoring', 'FTT', '+28.51%')),
            Expanded(child: _buildZoneCard('Layer 1 / Layer 2', 'LINEA', '+14.79%')),
          ],
        ),
      ],
    );
  }

  Widget _buildZoneCard(String category, String symbol, String change) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('T', style: TextStyle(color: Colors.white, fontSize: 8)),
                ),
              ),
              SizedBox(width: 4),
              Text(symbol, style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text(change, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Heatmap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ETHUSDT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('4522.32', style: TextStyle(color: Colors.white)),
                        Text('-1.65%', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('BTCUSDT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('116079.2', style: TextStyle(color: Colors.white, fontSize: 12)),
                              Text('-1.39%', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('SOLUSDT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('241.36', style: TextStyle(color: Colors.white)),
                              Text('-2.23%', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(child: _buildSmallHeatmapTile('ETHUSDC', '-1.66%')),
                    Expanded(child: _buildSmallHeatmapTile('DOGEUSDT', '')),
                    Expanded(child: _buildSmallHeatmapTile('BTC', '')),
                    Expanded(child: _buildSmallHeatmapTile('XRP', '')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallHeatmapTile(String symbol, String change) {
    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.red[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(symbol, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            if (change.isNotEmpty)
              Text(change, style: TextStyle(color: Colors.white, fontSize: 8)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopMovers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Movers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildMoverTab('Crypto', true),
            _buildMoverTab('Spot', false),
            _buildMoverTab('Futures', false),
          ],
        ),
        SizedBox(height: 16),
        ...topMovers.map((mover) => _buildMoverItem(mover)).toList(),
      ],
    );
  }

  Widget _buildMoverTab(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMoverItem(Map<String, dynamic> mover) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mover['symbol'], style: TextStyle(fontWeight: FontWeight.bold)),
                Text(mover['time'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: Text(mover['type'], style: TextStyle(color: Colors.grey[700])),
          ),
          Text(
            '${mover['change'].toStringAsFixed(2)}%',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Trading Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.info_outline, color: Colors.grey),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildTradingTab('BNB', true),
            _buildTradingTab('ETH', false),
            _buildTradingTab('BTC', false),
          ],
        ),
        SizedBox(height: 16),
        _buildMoneyFlowChart(),
        SizedBox(height: 20),
        _buildTradingMetrics(),
        SizedBox(height: 20),
        _buildChangeOrderButton(),
      ],
    );
  }

  Widget _buildTradingTab(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMoneyFlowChart() {
    return Container(
      height: 200,
      child: Column(
        children: [
          Text('Money flow over the past 15 minutes', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              width: 150,
              height: 150,
              child: CustomPaint(
                painter: DonutChartPainter(),
                child: Center(
                  child: Text('Money flow over the\npast 15 minutes', 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingMetrics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Margin Debt Growth (24hr)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    '${tradingData['marginDebtGrowth'].toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: tradingData['marginDebtGrowth'] < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Margin Long-short Postions Ratio (24hr)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    '${tradingData['longShortRatio'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Open Interest (5m)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    '${tradingData['openInterest'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Trader Long/Short Ratio - Positions (5m)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    '${tradingData['topTraderRatio'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChangeOrderButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit, color: const Color.fromARGB(255, 122, 79, 223), size: 18),
          SizedBox(width: 8),
          Text('Change Order', style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;
    final strokeWidth = 30.0;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // Data percentages
    final data = [
      {'percentage': 18.69, 'color': Colors.green, 'label': 'Large'},
      {'percentage': 12.33, 'color': Colors.green[300]!, 'label': 'Medium'},
      {'percentage': 4.91, 'color': Colors.green[200]!, 'label': 'Small'},
      {'percentage': 43.98, 'color': Colors.red, 'label': 'Large'},
      {'percentage': 14.23, 'color': Colors.red[300]!, 'label': 'Medium'},
      {'percentage': 5.85, 'color': Colors.red[200]!, 'label': 'Small'},
    ];
    
    double startAngle = -90 * (pi / 180); // Start from top
    
    for (var segment in data) {
      final sweepAngle = (segment['percentage'] as double) / 100 * 2 * pi;
      paint.color = segment['color'] as Color;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}