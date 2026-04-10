import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileCoinScreen extends StatefulWidget {
  @override
  _MobileCoinScreenState createState() => _MobileCoinScreenState();
}

class _MobileCoinScreenState extends State<MobileCoinScreen> {
  double currentPrice = 115928.0;
  double priceChange = -0.29;
  Timer? _priceTimer;
  TextEditingController _priceController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _priceController.text = currentPrice.toStringAsFixed(1);
    _startPriceUpdates();
  }

  void _startPriceUpdates() {
    _priceTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Simulate price movement
        double change = (Random().nextDouble() - 0.5) * 20;
        currentPrice += change;
        priceChange = (Random().nextDouble() - 0.5) * 2;
      });
    });
  }

  @override
  void dispose() {
    _priceTimer?.cancel();
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text('USD⊕-M', style: TextStyle(color: Colors.black, fontSize: 16)),
            SizedBox(width: 20),
            Text('COIN-M', style: TextStyle(color: Colors.black, fontSize: 16)),
            SizedBox(width: 20),
            Text('Options', style: TextStyle(color: Colors.grey, fontSize: 16)),
            SizedBox(width: 20),
            Text('Smart Mon', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
        actions: [
          Icon(Icons.menu, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),*/
      body:SafeArea(
        child: Column(
        children: [
          // Header with price and controls
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'BTCUSD CM',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Text('Perp', style: TextStyle(color: Colors.grey)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoinChartScreen(),
                              ),
                            );
                          },
                          child: Icon(Icons.candlestick_chart, color: Colors.grey),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.bar_chart, color: Colors.grey),
                        SizedBox(width: 16),
                        Icon(Icons.percent, color: Colors.grey),
                        SizedBox(width: 16),
                        Icon(Icons.more_horiz, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${priceChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: priceChange >= 0 ? Colors.green : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Trading controls
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Cross'),
                ),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('20x'),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Funding / Countdown', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('0.0100%/01:58:27', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Available balance
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Avbl', style: TextStyle(color: Colors.grey)),
                Spacer(),
                Text('0.0000 BTC', style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.attach_money, color: const Color.fromARGB(255, 122, 79, 223), size: 16),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Order form and order book
          Expanded(
            child: Row(
              children: [
                // Left side - Order form
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Limit order type
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey, size: 16),
                            SizedBox(width: 8),
                            Text('Limit', style: TextStyle(fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          ],
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Price input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price (USD)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Row(
                              children: [
                                Icon(Icons.remove, color: Colors.grey),
                                Expanded(
                                  child: TextField(
                                    controller: _priceController,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.add, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Amount input with BBO and Cont buttons
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(Icons.home, color: const Color.fromARGB(255, 122, 79, 223), size: 32),
                                  SizedBox(height: 8),
                                  Text('Amount', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            Icon(Icons.add, color: Colors.grey),
                            SizedBox(width: 16),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text('BBO', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('Cont'),
                                    Icon(Icons.keyboard_arrow_down, size: 16),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24),
                        
                        // TP/SL and Reduce Only checkboxes
                        Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(value: false, onChanged: (v) {}),
                                Text('TP/SL', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(value: false, onChanged: (v) {}),
                                Text('Reduce Only', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Max cost
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Max\nCost', style: TextStyle(color: Colors.grey)),
                            Text('0 Cont\n0.0000 BTC', textAlign: TextAlign.right),
                          ],
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Buy/Long button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Buy / Long', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                        
                        SizedBox(height: 8),
                        
                        // Max cost (second instance)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Max\nCost', style: TextStyle(color: Colors.grey)),
                            Text('0 Cont\n0.0000 BTC', textAlign: TextAlign.right),
                          ],
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Sell/Short button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Sell / Short', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Right side - Order book
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price\n(USD)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text('Amount\n(Cont)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        
                        // Order book data
                        Expanded(
                          child: ListView.builder(
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              bool isAsk = index < 10;
                              double price = currentPrice + (isAsk ? (10 - index) * 0.1 : -(index - 9) * 0.1);
                              int amount = Random().nextInt(100) + 1;
                              
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      price.toStringAsFixed(1),
                                      style: TextStyle(
                                        color: isAsk ? Colors.red : Colors.green,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      amount.toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Current price display
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                          child: Center(
                            child: Text(
                              currentPrice.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: priceChange >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        
                        // Progress bar
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Text('45.05%', style: TextStyle(fontSize: 10)),
                              Expanded(
                                child: Container(
                                  height: 4,
                                  child: LinearProgressIndicator(
                                    value: 0.4505,
                                    backgroundColor: Colors.red.shade300,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                  ),
                                ),
                              ),
                              Text('54.95%', style: TextStyle(fontSize: 10)),
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
          
          // Bottom tabs
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Positions (0)', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 24),
                Text('Open Orders (0)', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 24),
                Text('Bots', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class CoinChartScreen extends StatefulWidget {
  @override
  _CoinChartScreenState createState() => _CoinChartScreenState();
}

class _CoinChartScreenState extends State<CoinChartScreen> with TickerProviderStateMixin {
  double currentPrice = 115928.0;
  double priceChange = -0.29;
  Timer? _priceTimer;
  List<double> priceHistory = [];
  String selectedTimeframe = '15m';
  bool showOrderBook = false;
  List<OrderBookEntry> bids = [];
  List<OrderBookEntry> asks = [];

  @override
  void initState() {
    super.initState();
    _generateInitialData();
    _startPriceUpdates();
  }

  void _generateInitialData() {
    // Generate initial price history
    double basePrice = currentPrice;
    for (int i = 0; i < 100; i++) {
      double change = (Random().nextDouble() - 0.5) * 100;
      basePrice += change;
      priceHistory.add(basePrice);
    }

    // Generate order book data
    _generateOrderBook();
  }

  void _generateOrderBook() {
    bids.clear();
    asks.clear();
    
    // Generate bids (buy orders)
    for (int i = 0; i < 25; i++) {
      double price = currentPrice - (i * 0.1) - Random().nextDouble();
      int size = Random().nextInt(5000) + 100;
      bids.add(OrderBookEntry(price: price, size: size));
    }
    
    // Generate asks (sell orders)
    for (int i = 0; i < 25; i++) {
      double price = currentPrice + (i * 0.1) + Random().nextDouble();
      int size = Random().nextInt(5000) + 100;
      asks.add(OrderBookEntry(price: price, size: size));
    }
  }

  void _startPriceUpdates() {
    _priceTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Update price
        double change = (Random().nextDouble() - 0.5) * 50;
        currentPrice += change;
        priceChange = (Random().nextDouble() - 0.5) * 2;
        
        // Update price history
        priceHistory.add(currentPrice);
        if (priceHistory.length > 100) {
          priceHistory.removeAt(0);
        }
        
        // Update order book
        _generateOrderBook();
      });
    });
  }

  @override
  void dispose() {
    _priceTimer?.cancel();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('BTCUSD CM', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text('Perp', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
              ],
            ),
            Text(
              '${currentPrice.toStringAsFixed(1)} ${priceChange.toStringAsFixed(2)}%',
              style: TextStyle(
                color: priceChange >= 0 ? Colors.green : Colors.red,
                fontSize: 14,
              ),
            ),
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
          // Tab bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('Price', true),
                SizedBox(width: 24),
                _buildTab('Info', false),
                SizedBox(width: 24),
                _buildTab('Trading Data', false),
                SizedBox(width: 24),
                _buildTab('Square', false),
                SizedBox(width: 24),
                Row(
                  children: [
                    _buildTab('Trade', false),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text('New', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Price info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          currentPrice.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: priceChange >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                        Text(
                          '₹10,212,097.52 ${priceChange.toStringAsFixed(2)}%',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text('Mark Price ${(currentPrice - 0.6).toStringAsFixed(1)}', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        _buildPriceInfo('24h High', '116,475.0'),
                        _buildPriceInfo('24h Low', '115,134.6'),
                      ],
                    ),
                    SizedBox(width: 24),
                    Column(
                      children: [
                        _buildPriceInfo('24h Vol(Cont)', '8.98M'),
                        _buildPriceInfo('24h Vol(USD)', '898.08M'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Time frame selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Time', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 16),
                _buildTimeFrame('15m', selectedTimeframe == '15m'),
                SizedBox(width: 16),
                _buildTimeFrame('1h', selectedTimeframe == '1h'),
                SizedBox(width: 16),
                _buildTimeFrame('4h', selectedTimeframe == '4h'),
                SizedBox(width: 16),
                _buildTimeFrame('1D', selectedTimeframe == '1D'),
                SizedBox(width: 16),
                Text('More', style: TextStyle(color: Colors.grey)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showOrderBook = !showOrderBook;
                    });
                  },
                  child: Text('Depth', style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(width: 8),
                Icon(Icons.tune, color: Colors.grey),
                SizedBox(width: 8),
                Icon(Icons.grid_view, color: Colors.grey),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Chart
          Expanded(
            child: showOrderBook ? _buildOrderBookView() : _buildChartView(),
          ),
          
          // Performance indicators
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('MA', style: TextStyle(color: Colors.grey)),
                    Text('EMA', style: TextStyle(color: Colors.grey)),
                    Text('BOLL', style: TextStyle(color: Colors.grey)),
                    Text('SAR', style: TextStyle(color: Colors.grey)),
                    Text('AVL', style: TextStyle(color: Colors.grey)),
                    Text('VOL', style: TextStyle(color: Colors.grey)),
                    Text('MACD', style: TextStyle(color: Colors.grey)),
                    Text('RSI', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPerformanceItem('Today', '0.33%', Colors.green),
                    _buildPerformanceItem('7 Days', '0.12%', Colors.green),
                    _buildPerformanceItem('30 Days', '1.53%', Colors.green),
                    _buildPerformanceItem('90 Days', '12.37%', Colors.green),
                    _buildPerformanceItem('180 Days', '36.43%', Colors.green),
                    _buildPerformanceItem('1 Year', '82.00%', Colors.green),
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('Order Book', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 24),
                Text('Trades', style: TextStyle(color: Colors.grey)),
                Spacer(),
                Text('12.84%', style: TextStyle(color: Colors.green, fontSize: 12)),
                SizedBox(width: 16),
                Text('56.96%', style: TextStyle(color: Colors.red, fontSize: 12)),
              ],
            ),
          ),
          
          // Buy/Sell buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.more_horiz, color: Colors.grey),
                      SizedBox(width: 16),
                      Icon(Icons.grid_view, color: Colors.grey),
                      SizedBox(width: 16),
                      Icon(Icons.percent, color: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Long', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Short', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected)
          Container(
            margin: EdgeInsets.only(top: 4),
            height: 2,
            width: text.length * 8.0,
            color: const Color.fromARGB(255, 122, 79, 223),
          ),
      ],
    );
  }

  Widget _buildPriceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTimeFrame(String timeframe, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeframe = timeframe;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          timeframe,
          style: TextStyle(
            color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(String period, String percentage, Color color) {
    return Column(
      children: [
        Text(period, style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text(percentage, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildChartView() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // MA indicator
          Row(
            children: [
              Text('MA60 115,924.1', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Spacer(),
              Text('115,981.7', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(height: 16),
          
          // Chart area
          Expanded(
            child: Container(
              width: double.infinity,
              child: CustomPaint(
                painter: CandlestickChartPainter(priceHistory, currentPrice),
              ),
            ),
          ),
          
          // Volume indicators
          Container(
            height: 40,
            child: Row(
              children: [
                Text('Vol: 5,165', style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(width: 16),
                Text('MA(5): 5,517', style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223), fontSize: 12)),
                SizedBox(width: 16),
                Text('MA(10): 3,162', style: TextStyle(color: Colors.purple, fontSize: 12)),
              ],
            ),
          ),
          
          // Time stamps
          Container(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('2025-09-20 19:05', style: TextStyle(color: Colors.grey, fontSize: 10)),
                Text('2025-09-20 19:12', style: TextStyle(color: Colors.grey, fontSize: 10)),
                Text('2025-09-20 19:19', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderBookView() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Order book header
          Row(
            children: [
              Text('Order Book', style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text('Trades', style: TextStyle(color: Colors.grey)),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Buy/Sell percentage bar
          Container(
            height: 8,
            child: Row(
              children: [
                Text('44.84%', style: TextStyle(color: Colors.green, fontSize: 12)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: LinearProgressIndicator(
                      value: 0.4484,
                      backgroundColor: Colors.red.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ),
                Text('55.16%', style: TextStyle(color: Colors.red, fontSize: 12)),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Order book headers
          Row(
            children: [
              Expanded(flex: 2, child: Text('Bid', style: TextStyle(color: Colors.grey, fontSize: 12))),
              Expanded(flex: 3, child: Text('Size(Cont)', style: TextStyle(color: Colors.grey, fontSize: 12))),
              Expanded(flex: 3, child: Text('Price (USD)', style: TextStyle(color: Colors.grey, fontSize: 12))),
              Expanded(flex: 3, child: Text('Price (USD)', style: TextStyle(color: Colors.grey, fontSize: 12))),
              Expanded(flex: 3, child: Text('Size(Cont)', style: TextStyle(color: Colors.grey, fontSize: 12))),
              Expanded(flex: 2, child: Text('Ask', textAlign: TextAlign.end, style: TextStyle(color: Colors.grey, fontSize: 12))),
            ],
          ),
          
          SizedBox(height: 8),
          
          // Order book data
          Expanded(
            child: ListView.builder(
              itemCount: min(bids.length, asks.length),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      // Bid side
                      Expanded(
                        flex: 2,
                        child: Text(
                          bids[index].size.toString(),
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          bids[index].size.toString(),
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          bids[index].price.toStringAsFixed(1),
                          style: TextStyle(color: Colors.green, fontSize: 11),
                        ),
                      ),
                      
                      // Ask side
                      Expanded(
                        flex: 3,
                        child: Text(
                          asks[index].price.toStringAsFixed(1),
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          asks[index].size.toString(),
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          asks[index].size.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 11),
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

class OrderBookEntry {
  final double price;
  final int size;
  
  OrderBookEntry({required this.price, required this.size});
}

class CandlestickChartPainter extends CustomPainter {
  final List<double> prices;
  final double currentPrice;
  
  CandlestickChartPainter(this.prices, this.currentPrice);
  
  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;
    
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final fillPaint = Paint()
      ..style = PaintingStyle.fill;
    
    // Calculate price range
    double minPrice = prices.reduce((a, b) => a < b ? a : b);
    double maxPrice = prices.reduce((a, b) => a > b ? a : b);
    double priceRange = maxPrice - minPrice;
    
    if (priceRange == 0) priceRange = 1;
    
    // Draw background grid
    paint.color = Colors.grey.shade300;
    paint.strokeWidth = 0.5;
    
    for (int i = 0; i <= 5; i++) {
      double y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    for (int i = 0; i <= 10; i++) {
      double x = size.width * i / 10;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw candlesticks
    double candleWidth = size.width / prices.length * 0.8;
    
    for (int i = 0; i < prices.length - 3; i += 4) {
      if (i + 3 >= prices.length) break;
      
      double open = prices[i];
      double high = [prices[i], prices[i + 1], prices[i + 2], prices[i + 3]].reduce((a, b) => a > b ? a : b);
      double low = [prices[i], prices[i + 1], prices[i + 2], prices[i + 3]].reduce((a, b) => a < b ? a : b);
      double close = prices[i + 3];
      
      bool isGreen = close >= open;
      
      double x = (i / 4) * (size.width / (prices.length / 4));
      double openY = size.height - ((open - minPrice) / priceRange * size.height);
      double closeY = size.height - ((close - minPrice) / priceRange * size.height);
      double highY = size.height - ((high - minPrice) / priceRange * size.height);
      double lowY = size.height - ((low - minPrice) / priceRange * size.height);
      
      // Draw wick
      paint.color = isGreen ? Colors.green : Colors.red;
      paint.strokeWidth = 1;
      canvas.drawLine(Offset(x + candleWidth / 2, highY), Offset(x + candleWidth / 2, lowY), paint);
      
      // Draw candle body
      fillPaint.color = isGreen ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8);
      paint.color = isGreen ? Colors.green : Colors.red;
      paint.strokeWidth = 1;
      
      Rect candleRect = Rect.fromLTWH(x, min(openY, closeY), candleWidth, (openY - closeY).abs());
      canvas.drawRect(candleRect, fillPaint);
      canvas.drawRect(candleRect, paint);
    }
    
    // Draw moving average line
    paint.color = const Color.fromARGB(255, 122, 79, 223);
    paint.strokeWidth = 2;
    Path path = Path();
    
    for (int i = 0; i < prices.length - 5; i++) {
      double ma = prices.getRange(i, i + 5).reduce((a, b) => a + b) / 5;
      double x = i * (size.width / prices.length);
      double y = size.height - ((ma - minPrice) / priceRange * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw current price line
    paint.color = Colors.blue;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    
    double currentY = size.height - ((currentPrice - minPrice) / priceRange * size.height);
    Path dashPath = Path();
    double dashWidth = 5;
    double dashSpace = 3;
    double startX = 0;
    
    while (startX < size.width) {
      dashPath.addRect(Rect.fromLTWH(startX, currentY - 0.5, dashWidth, 1));
      startX += dashWidth + dashSpace;
    }
    
    canvas.drawPath(dashPath, paint);
    
    // Draw volume bars at bottom
    paint.style = PaintingStyle.fill;
    double volumeHeight = size.height * 0.2;
    double barWidth = size.width / prices.length;
    
    for (int i = 0; i < prices.length - 1; i++) {
      bool isGreen = i < prices.length - 1 ? prices[i + 1] >= prices[i] : true;
      double volume = Random().nextDouble() * volumeHeight;
      
      paint.color = isGreen ? Colors.green.withOpacity(0.6) : Colors.red.withOpacity(0.6);
      
      Rect volumeBar = Rect.fromLTWH(
        i * barWidth,
        size.height - volume,
        barWidth * 0.8,
        volume,
      );
      
      canvas.drawRect(volumeBar, paint);
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}