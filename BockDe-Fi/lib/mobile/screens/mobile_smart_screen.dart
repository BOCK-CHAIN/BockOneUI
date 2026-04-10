import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MobileSmartScreen extends StatefulWidget {
  @override
  _MobileSmartScreenState createState() => _MobileSmartScreenState();
}

class _MobileSmartScreenState extends State<MobileSmartScreen> {
  String selectedPeriod = '30D';
  String sortBy = 'PnL: High to Low';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Smart Money',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lock_outline, color: Colors.black),
            onPressed: () {},
          ),
          /*CircleAvatar(
            radius: 16,
            backgroundColor: const Color.fromARGB(255, 122, 79, 223),
            child: Text('😎', style: TextStyle(fontSize: 16)),
          ),*/
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'My Subscriptions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: const Color.fromARGB(255, 122, 79, 223), width: 3),
                      ),
                    ),
                    child: Text(
                      'Top Traders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filters
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip(selectedPeriod, ['1D', '7D', '30D', '90D']),
                SizedBox(width: 16),
                _buildFilterChip(sortBy, ['PnL: High to Low', 'PnL: Low to High', 'ROI: High to Low']),
                Spacer(),
                Icon(Icons.search, color: Colors.grey[600]),
                SizedBox(width: 16),
                Icon(Icons.filter_list, color: Colors.grey[600]),
              ],
            ),
          ),
          
          // Traders List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildTraderCard(
                  name: 'Satoshi',
                  subtitle: 'Sas Capital',
                  subscribers: '35,781 Subscribers',
                  pnl: '+3,990,194.40',
                  roi: '+28.37%',
                  assets: '2,088,616.13',
                  chartData: _generateChartData(true),
                  avatarColor: const Color.fromARGB(255, 122, 79, 223)!,
                ),
                SizedBox(height: 16),
                _buildTraderCard(
                  name: 'Andrew',
                  subtitle: 'Main',
                  subscribers: '40,481 Subscribers',
                  pnl: '+3,822,271.92',
                  roi: '+36.98%',
                  assets: '7,733,329.33',
                  chartData: _generateChartData(true),
                  avatarColor: const Color.fromARGB(255, 122, 79, 223)!,
                ),
                SizedBox(height: 16),
                _buildTraderCard(
                  name: 'ZetaCentauri',
                  subtitle: 'Main',
                  subscribers: '23,608 Subscribers',
                  pnl: '+3,673,376.10',
                  roi: '+22.70%',
                  assets: '4,320,710.05',
                  chartData: _generateChartData(true),
                  avatarColor: const Color.fromARGB(255, 122, 79, 223)!,
                ),
                SizedBox(height: 16),
                _buildTraderCard(
                  name: 'ShangusCapital',
                  subtitle: 'SG CAPITAL',
                  subscribers: '27,207 Subscribers',
                  pnl: '+3,049,839.19',
                  roi: '+229.11%',
                  assets: '',
                  chartData: _generateChartData(true),
                  avatarColor: const Color.fromARGB(255, 122, 79, 223)!,
                  showPartialChart: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String currentValue, List<String> options) {
    return GestureDetector(
      onTap: () {
        // Handle filter selection
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentValue,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildTraderCard({
    required String name,
    required String subtitle,
    required String subscribers,
    required String pnl,
    required String roi,
    required String assets,
    required List<FlSpot> chartData,
    required Color avatarColor,
    bool showPartialChart = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: avatarColor,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      subscribers,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Subscribe',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Performance Data and Chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Performance Data
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30D PnL (USD)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      pnl,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (assets.isNotEmpty) ...[
                      Text(
                        'Assets (USD)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        assets,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Center - Chart
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: chartData.length.toDouble() - 1,
                      minY: chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.95,
                      maxY: chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.05,
                      lineBarsData: [
                        LineChartBarData(
                          spots: showPartialChart 
                            ? chartData.sublist(0, (chartData.length * 0.7).round())
                            : chartData,
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Right Column - ROI
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '30D ROI',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      roi,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
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

  List<FlSpot> _generateChartData(bool isPositive) {
    List<FlSpot> spots = [];
    double baseValue = 100;
    
    for (int i = 0; i < 20; i++) {
      double variation = (i / 20) * (isPositive ? 50 : -30);
      double noise = (i % 3 - 1) * 5; // Add some noise
      spots.add(FlSpot(i.toDouble(), baseValue + variation + noise));
    }
    
    return spots;
  }
}