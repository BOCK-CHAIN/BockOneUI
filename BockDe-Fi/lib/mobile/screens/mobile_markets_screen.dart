import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileMarketsScreen extends StatefulWidget {
  @override
  _MobileMarketsScreenState createState() => _MobileMarketsScreenState();
}

class _MobileMarketsScreenState extends State<MobileMarketsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Timer _priceUpdateTimer;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample market data
  List<CoinData> cryptoCoins = [];
  List<CoinData> spotCoins = [];
  List<CoinData> usdmCoins = [];
  List<CoinData> coinmCoins = [];
  List<CoinData> optionsCoins = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeData();
    _startPriceUpdates();
  }

  void _initializeData() {
    cryptoCoins = [
      CoinData('BTC', 'Bitcoin', 116376.61, -0.65, '₹10,253,943.10', 'assets/btc.png'),
      CoinData('1INCH', '1inch', 0.2613, -2.75, '₹23.02', 'assets/1inch.png'),
      CoinData('AAVE', 'Aave', 306.58, -0.14, '₹27,012.76', 'assets/aave.png'),
      CoinData('ACM', 'AC Milan Fan Token', 0.908, 1.00, '₹80.00', 'assets/acm.png'),
      CoinData('ADA', 'Cardano', 0.9061, -0.69, '₹79.83', 'assets/ada.png'),
      CoinData('ALGO', 'Algorand', 0.2413, -1.79, '₹21.26', 'assets/algo.png'),
      CoinData('ALICE', 'My Neighbor Alice', 0.3684, -2.85, '₹32.45', 'assets/alice.png'),
      CoinData('ANKR', 'Ankr', 0.01518, -2.94, '₹1.33', 'assets/ankr.png'),
      CoinData('ARDR', 'Ardor', 0.08672, -1.36, '₹7.64', 'assets/ardr.png'),
    ];

    spotCoins = List.from(cryptoCoins);
    usdmCoins = List.from(cryptoCoins);
    coinmCoins = List.from(cryptoCoins);
    optionsCoins = List.from(cryptoCoins);
  }

  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _updatePrices(cryptoCoins);
        _updatePrices(spotCoins);
        _updatePrices(usdmCoins);
        _updatePrices(coinmCoins);
        _updatePrices(optionsCoins);
      });
    });
  }

  void _updatePrices(List<CoinData> coins) {
    final random = Random();
    for (var coin in coins) {
      // Random price change between -5% and +5%
      double changePercent = (random.nextDouble() - 0.5) * 10;
      coin.price24hChange = double.parse(changePercent.toStringAsFixed(2));
      
      // Update price based on change
      double newPrice = coin.lastPrice * (1 + changePercent / 100);
      coin.lastPrice = double.parse(newPrice.toStringAsFixed(coin.lastPrice < 1 ? 6 : 2));
      
      // Update INR price (assuming 1 USD = 88 INR approx)
      coin.inrPrice = '₹${(coin.lastPrice * 88).toStringAsFixed(2)}';
    }
  }

  List<CoinData> _getFilteredCoins(List<CoinData> coins) {
    if (_searchQuery.isEmpty) return coins;
    return coins.where((coin) =>
        coin.symbol.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        coin.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _priceUpdateTimer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Navigation Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: const Color.fromARGB(255, 122, 79, 223),
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              tabs: [
                Tab(text: 'Crypto'),
                Tab(text: 'Spot'),
                Tab(text: 'USD©-M'),
                Tab(text: 'COIN-M'),
                Tab(text: 'Options'),
              ],
            ),
          ),
          // Sub Navigation
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildSubNavItem('All', true),
                SizedBox(width: 20),
                _buildSubNavItem('BNB Chain', false),
                SizedBox(width: 20),
                _buildSubNavItem('Solana', false),
                SizedBox(width: 20),
                _buildSubNavItem('RWA', false),
                SizedBox(width: 20),
                _buildSubNavItem('Meme', false),
                SizedBox(width: 20),
                _buildSubNavItem('Payment', false),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Last Price',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '24h Chg%',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCoinList(_getFilteredCoins(cryptoCoins)),
                _buildCoinList(_getFilteredCoins(spotCoins)),
                _buildCoinList(_getFilteredCoins(usdmCoins)),
                _buildCoinList(_getFilteredCoins(coinmCoins)),
                _buildCoinList(_getFilteredCoins(optionsCoins)),
              ],
            ),
          ),
        ],
      ),
      //bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSubNavItem(String title, bool isSelected) {
    return Text(
      title,
      style: TextStyle(
        color: isSelected ? Colors.black : Colors.grey[600],
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _buildCoinList(List<CoinData> coins) {
    return ListView.builder(
      itemCount: coins.length,
      itemBuilder: (context, index) {
        final coin = coins[index];
        return _buildCoinItem(coin);
      },
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
        ),
        child: Row(
          children: [
            // Coin Icon and Info
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCoinColor(coin.symbol),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        coin.symbol.substring(0, min(3, coin.symbol.length)).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin.symbol,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        coin.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Price Info
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    coin.lastPrice.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    coin.inrPrice,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Change Percentage
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: coin.price24hChange >= 0 ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${coin.price24hChange >= 0 ? '+' : ''}${coin.price24hChange.toStringAsFixed(2)}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCoinColor(String symbol) {
    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.indigo,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ];
    return colors[symbol.hashCode % colors.length];
  }

  /*Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Markets'),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Trade'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Futures'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Assets'),
      ],
      currentIndex: 1,
    );
  }*/
}

class CoinData {
  String symbol;
  String name;
  double lastPrice;
  double price24hChange;
  String inrPrice;
  String iconPath;

  CoinData(this.symbol, this.name, this.lastPrice, this.price24hChange, this.inrPrice, this.iconPath);
}

class CoinDetailScreen extends StatefulWidget {
  final CoinData coin;

  CoinDetailScreen({required this.coin});

  @override
  _CoinDetailScreenState createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> with TickerProviderStateMixin {
  late TabController _detailTabController;
  late Timer _priceUpdateTimer;
  List<ChartData> chartData = [];
  List<OrderBookItem> bids = [];
  List<OrderBookItem> asks = [];

  @override
  void initState() {
    super.initState();
    _detailTabController = TabController(length: 5, vsync: this);
    _generateChartData();
    _generateOrderBookData();
    _startDetailPriceUpdates();
  }

  void _generateChartData() {
    final random = Random();
    double basePrice = widget.coin.lastPrice;
    
    for (int i = 0; i < 100; i++) {
      double variation = (random.nextDouble() - 0.5) * basePrice * 0.02;
      chartData.add(ChartData(i.toDouble(), basePrice + variation));
    }
  }

  void _generateOrderBookData() {
    final random = Random();
    double currentPrice = widget.coin.lastPrice;
    
    // Generate bids (buy orders) - prices below current price
    for (int i = 0; i < 25; i++) {
      double price = currentPrice - (random.nextDouble() * 20);
      double quantity = random.nextDouble() * 10;
      bids.add(OrderBookItem(quantity, price));
    }
    
    // Generate asks (sell orders) - prices above current price
    for (int i = 0; i < 25; i++) {
      double price = currentPrice + (random.nextDouble() * 20);
      double quantity = random.nextDouble() * 10;
      asks.add(OrderBookItem(quantity, price));
    }
    
    bids.sort((a, b) => b.price.compareTo(a.price)); // Highest bid first
    asks.sort((a, b) => a.price.compareTo(b.price)); // Lowest ask first
  }

  void _startDetailPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        // Update coin price
        final random = Random();
        double changePercent = (random.nextDouble() - 0.5) * 2;
        widget.coin.price24hChange = double.parse(changePercent.toStringAsFixed(2));
        widget.coin.lastPrice = widget.coin.lastPrice * (1 + changePercent / 100);
        
        // Update chart data
        chartData.removeAt(0);
        chartData.add(ChartData(99, widget.coin.lastPrice + (random.nextDouble() - 0.5) * widget.coin.lastPrice * 0.01));
        
        // Update order book
        _updateOrderBook();
      });
    });
  }

  void _updateOrderBook() {
    final random = Random();
    // Update some random orders
    for (int i = 0; i < 5; i++) {
      if (bids.isNotEmpty) {
        int index = random.nextInt(bids.length);
        bids[index].quantity = random.nextDouble() * 10;
      }
      if (asks.isNotEmpty) {
        int index = random.nextInt(asks.length);
        asks[index].quantity = random.nextDouble() * 10;
      }
    }
  }

  @override
  void dispose() {
    _detailTabController.dispose();
    _priceUpdateTimer.cancel();
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
        title: Row(
          children: [
            Text(
              '${widget.coin.symbol}/USDT',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
        actions: [
          Icon(Icons.auto_awesome, color: Colors.black),
          SizedBox(width: 16),
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
          // Price Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coin.lastPrice.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.coin.inrPrice,
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.coin.price24hChange >= 0 ? Colors.red[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${widget.coin.price24hChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: widget.coin.price24hChange >= 0 ? Colors.red : Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('POW', style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223), fontSize: 12)),
                        SizedBox(width: 16),
                        Text('Vol', style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223), fontSize: 12)),
                        SizedBox(width: 16),
                        Text('Price Protection', style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('24h High', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('117,900.00', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text('24h Low', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('116,075.00', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('24h Vol(BTC)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('9,774.42', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    Text('24h Vol(USDT)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('1.14B', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          // Detail Tabs
          TabBar(
            controller: _detailTabController,
            isScrollable: true,
            indicatorColor: const Color.fromARGB(255, 122, 79, 223),
            indicatorWeight: 2,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 14),
            tabs: [
              Tab(text: 'Price'),
              Tab(text: 'Info'),
              Tab(text: 'Trading Data'),
              Tab(text: 'Square'),
              Tab(text: 'Trade'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _detailTabController,
              children: [
                _buildPriceTab(),
                Center(child: Text('Info Tab')),
                Center(child: Text('Trading Data Tab')),
                Center(child: Text('Square Tab')),
                Center(child: Text('Trade Tab')),
              ],
            ),
          ),
          // Buy/Sell Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Buy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Sell', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTab() {
    return Column(
      children: [
        // Chart Area
        Container(
          height: 300,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Time frame buttons
              Row(
                children: [
                  _buildTimeFrameButton('15m', false),
                  _buildTimeFrameButton('1h', false),
                  _buildTimeFrameButton('4h', false),
                  _buildTimeFrameButton('1D', true),
                  Spacer(),
                  Text('More', style: TextStyle(color: Colors.grey[600])),
                  SizedBox(width: 16),
                  Text('Depth', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 16),
              // Simple chart representation
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomPaint(
                    painter: SimpleChartPainter(chartData),
                  ),
                ),
              ),
              // Performance indicators
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPerformanceItem('Today', '-0.95%', Colors.red),
                  _buildPerformanceItem('7 Days', '1.64%', Colors.green),
                  _buildPerformanceItem('30 Days', '2.61%', Colors.green),
                  _buildPerformanceItem('90 Days', '12.77%', Colors.green),
                ],
              ),
            ],
          ),
        ),
        // Order Book
        Expanded(
          child: Column(
            children: [
              // Order Book Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text('Order Book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text('Trades', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              // Buy/Sell ratio
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('34.11%', style: TextStyle(color: Colors.green, fontSize: 12)),
                    Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 34,
                              child: Container(color: Colors.green),
                            ),
                            Expanded(
                              flex: 66,
                              child: Container(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text('65.89%', style: TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Order Book Table
              Expanded(
                child: _buildOrderBookTable(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFrameButton(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.yellow[100] : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[600],
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(String period, String change, Color color) {
    return Column(
      children: [
        Text(period, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(change, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildOrderBookTable() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(child: Text('Bid', style: TextStyle(color: Colors.grey[600], fontSize: 12))),
              Expanded(child: Text('Ask', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 12))),
              Expanded(child: Text('0.01', textAlign: TextAlign.right, style: TextStyle(color: Colors.grey[600], fontSize: 12))),
            ],
          ),
          SizedBox(height: 8),
          // Order book entries
          Expanded(
            child: ListView.builder(
              itemCount: min(bids.length, asks.length),
              itemBuilder: (context, index) {
                final bid = bids[index];
                final ask = asks[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          bid.quantity.toStringAsFixed(5),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              bid.price.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              ask.price.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ask.quantity.toStringAsFixed(5),
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final double x;
  final double y;
  
  ChartData(this.x, this.y);
}

class OrderBookItem {
  double quantity;
  double price;
  
  OrderBookItem(this.quantity, this.price);
}

class SimpleChartPainter extends CustomPainter {
  final List<ChartData> data;
  
  SimpleChartPainter(this.data);
  
  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    final paint = Paint()
      ..color = const Color.fromARGB(255, 122, 79, 223)!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final fillPaint = Paint()
      ..color = Colors.yellow[100]!
      ..style = PaintingStyle.fill;
    
    final path = Path();
    final fillPath = Path();
    
    // Find min and max values
    double minY = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    double maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double range = maxY - minY;
    
    if (range == 0) range = 1; // Avoid division by zero
    
    // Draw the chart line
    for (int i = 0; i < data.length; i++) {
      double x = (i / (data.length - 1)) * size.width;
      double y = size.height - ((data[i].y - minY) / range) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    
    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    
    // Draw fill first, then line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
    
    // Draw current price line
    final currentPricePaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    double currentY = size.height - ((data.last.y - minY) / range) * size.height;
    canvas.drawLine(
      Offset(0, currentY),
      Offset(size.width, currentY),
      currentPricePaint,
    );
    
    // Draw price label
    final textPainter = TextPainter(
      text: TextSpan(
        text: data.last.y.toStringAsFixed(2),
        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // Draw price label with background
    final labelRect = Rect.fromLTWH(
      size.width - textPainter.width - 8,
      currentY - textPainter.height / 2,
      textPainter.width + 4,
      textPainter.height,
    );
    
    canvas.drawRect(
      labelRect,
      Paint()..color = const Color.fromARGB(255, 122, 79, 223)!,
    );
    
    textPainter.paint(
      canvas,
      Offset(size.width - textPainter.width - 6, currentY - textPainter.height / 2),
    );
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}