import 'package:flutter/material.dart';

class MobileP2pScreen extends StatefulWidget {
  @override
  _MobileP2pScreenState createState() => _MobileP2pScreenState();
}

class _MobileP2pScreenState extends State<MobileP2pScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isBuySelected = true;
  String selectedCurrency = 'USDT';
  String selectedAmount = 'Amount';
  String selectedPayment = 'Payment';

  // Sample trader data
  List<TraderData> traders = [
    TraderData(
      name: 'POWERLIFTE',
      trades: 4121,
      completion: 100.0,
      rating: 99.05,
      price: 95.49,
      limit: '200.00 - 500.00 INR',
      available: 79.67,
      paymentMethod: 'Lightning UPI',
      isVerified: true,
      timeLimit: 15,
      isSaferAd: true,
    ),
    TraderData(
      name: 'Thalapathy_sugumar',
      trades: 1479,
      completion: 94.20,
      rating: 98.23,
      price: 94.00,
      limit: '3,999.00 - 4,000.00 INR',
      available: 115.86,
      paymentMethod: 'Digital eRupee',
      isVerified: true,
      timeLimit: 15,
    ),
    TraderData(
      name: 'Thalapathy_sugumar',
      trades: 1479,
      completion: 94.20,
      rating: 98.23,
      price: 94.00,
      limit: '4,999.00 - 5,000.00 INR',
      available: 115.86,
      paymentMethod: 'Digital eRupee',
      isVerified: true,
      timeLimit: 15,
    ),
    TraderData(
      name: 'Salasar-1234',
      trades: 1689,
      completion: 97.90,
      rating: 96.60,
      price: 93.75,
      limit: '1,000.00 - 10,000.00 INR',
      available: 95.23,
      paymentMethod: 'UPI',
      isVerified: true,
      timeLimit: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Express'),
              Tab(text: 'P2P'),
              Tab(text: 'Block Trade'),
            ],
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'INR',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExpressTab(),
          _buildP2PTab(),
          _buildBlockTradeTab(),
        ],
      ),
    );
  }

  Widget _buildExpressTab() {
    return Center(
      child: Text('Express Tab Content', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildP2PTab() {
    return Column(
      children: [
        // Buy/Sell Toggle
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => isBuySelected = true),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: isBuySelected ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      color: isBuySelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => isBuySelected = false),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: !isBuySelected ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Sell',
                    style: TextStyle(
                      color: !isBuySelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Filters Row
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterDropdown(selectedCurrency, ['USDT', 'BTC', 'ETH']),
              SizedBox(width: 16),
              _buildFilterDropdown(selectedAmount, ['Amount', '100-500', '500-1000']),
              SizedBox(width: 16),
              _buildFilterDropdown(selectedPayment, ['Payment', 'UPI', 'Bank Transfer']),
              Spacer(),
              Icon(Icons.tune, color: const Color.fromARGB(255, 122, 79, 223)),
            ],
          ),
        ),
        
        SizedBox(height: 16),
        
        // Traders List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: traders.length,
            itemBuilder: (context, index) {
              return _buildTraderCard(traders[index], index == 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBlockTradeTab() {
    return Center(
      child: Text('Block Trade Tab Content', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildFilterDropdown(String value, List<String> options) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value == selectedCurrency) ...[
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'T',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
        ],
      ),
    );
  }

  Widget _buildTraderCard(TraderData trader, bool isFeatured) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFeatured ? const Color.fromARGB(255, 122, 79, 223)! : Colors.grey[200]!,
          width: isFeatured ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isFeatured)
            Container(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Safer and Faster Ad',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    trader.name[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          trader.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        if (trader.isVerified) ...[
                          SizedBox(width: 4),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 122, 79, 223),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Trade: ${trader.trades} Trades (${trader.completion}%)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.thumb_up, color: Colors.grey[600], size: 14),
                        SizedBox(width: 4),
                        Text(
                          '${trader.rating}%',
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
          
          SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '₹ ${trader.price}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/USDT',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Limit ${trader.limit}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Available ${trader.available} USDT',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        trader.paymentMethod,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: trader.paymentMethod.contains('Lightning') 
                              ? const Color.fromARGB(255, 122, 79, 223) 
                              : Colors.blue[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600], size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${trader.timeLimit} min',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[500],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Buy',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TraderData {
  final String name;
  final int trades;
  final double completion;
  final double rating;
  final double price;
  final String limit;
  final double available;
  final String paymentMethod;
  final bool isVerified;
  final int timeLimit;
  final bool isSaferAd;

  TraderData({
    required this.name,
    required this.trades,
    required this.completion,
    required this.rating,
    required this.price,
    required this.limit,
    required this.available,
    required this.paymentMethod,
    required this.isVerified,
    required this.timeLimit,
    this.isSaferAd = false,
  });
}