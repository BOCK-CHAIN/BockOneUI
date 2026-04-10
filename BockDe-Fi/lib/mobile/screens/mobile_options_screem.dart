import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileOptionsScreen extends StatefulWidget {
  @override
  _MobileOptionsScreenState createState() => _MobileOptionsScreenState();
}

class _MobileOptionsScreenState extends State<MobileOptionsScreen> {
  String selectedCoin = 'ETH';
  double currentPrice = 4469.9;
  Timer? _priceTimer;
  Timer? _countdownTimer;
  
  // Available coins
  final List<Map<String, dynamic>> coins = [
    {'symbol': 'ETH', 'name': 'Ethereum', 'price': 4469.9},
    {'symbol': 'BTC', 'name': 'Bitcoin', 'price': 68500.0},
    {'symbol': 'USDT', 'name': 'Tether', 'price': 1.0},
    {'symbol': 'BNB', 'name': 'BOCK De-Fi Coin', 'price': 625.4},
    {'symbol': 'SOL', 'name': 'Solana', 'price': 185.2},
  ];
  
  // Expiry countdown
  Duration timeToExpiry = Duration(hours: 2, minutes: 56, seconds: 45);
  
  // Selected dates
  List<String> dates = ['25-09-20', '25-09-21', '25-09-22', '25-09-26', '25-10-'];
  int selectedDateIndex = 2; // Default to middle date
  
  @override
  void initState() {
    super.initState();
    _startPriceUpdates();
    _startCountdown();
  }
  
  @override
  void dispose() {
    _priceTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  void _startPriceUpdates() {
    _priceTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Simulate price fluctuation
        double change = (Random().nextDouble() - 0.5) * 100;
        currentPrice = (currentPrice + change).clamp(1000, 10000);
        
        // Update the selected coin price in the coins list
        int index = coins.indexWhere((coin) => coin['symbol'] == selectedCoin);
        if (index != -1) {
          coins[index]['price'] = currentPrice;
        }
      });
    });
  }
  
  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeToExpiry.inSeconds > 0) {
          timeToExpiry = timeToExpiry - Duration(seconds: 1);
        }
      });
    });
  }
  
  String _formatCountdown(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
  
  List<Map<String, dynamic>> _generateOptions() {
    List<Map<String, dynamic>> options = [];
    double basePrice = currentPrice;
    
    // Generate 5 call options with different strike prices
    for (int i = 0; i < 5; i++) {
      double strikePrice = basePrice - 500 + (i * 100);
      double markPrice = 469.9 - (i * 100);
      double multiplier = 9.51 + (i * 3);
      double profitProb = 49.68 + (i * 0.02);
      
      options.add({
        'type': 'Call',
        'strikePrice': strikePrice,
        'multiplier': multiplier,
        'breakeven': basePrice,
        'breakevenPercent': 0.00,
        'profitProb': profitProb,
        'markPrice': markPrice,
      });
    }
    
    return options;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Row(
          children: [
            Text(
              '$selectedCoin Options',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: _showCoinSelector,
              child: Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.help_outline, color: Colors.grey[600], size: 20),
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              currentPrice.toStringAsFixed(1),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 24),
          
          // Date selector
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (context, index) {
                bool isSelected = index == selectedDateIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == dates.length - 1 ? 16 : 0),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      dates[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.grey[600],
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Price and expiry info
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Index Price: ${currentPrice.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Time to Expiry: ${_formatCountdown(timeToExpiry)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Options list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _generateOptions().length,
              itemBuilder: (context, index) {
                var option = _generateOptions()[index];
                return _buildOptionCard(option);
              },
            ),
          ),
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 122, 79, 223),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.flag, color: Colors.white, size: 16),
            ),
            label: 'Futures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Assets',
          ),
        ],
      ),*/
    );
  }
  
  Widget _buildOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: GestureDetector(
        onTap: () => _navigateToOptionDetail(option),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star_border, color: Colors.grey[400], size: 20),
                SizedBox(width: 8),
                Text(
                  '${option['strikePrice'].toStringAsFixed(1)} ${option['type']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  '${option['multiplier'].toStringAsFixed(2)}x',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Breakeven (%)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${option['breakeven'].toStringAsFixed(3)} (${option['breakevenPercent'].toStringAsFixed(2)}%)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                        'Prob of Profit',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${option['profitProb'].toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Mark Price',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      option['markPrice'].toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCoinSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Cryptocurrency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: coins.length,
                  itemBuilder: (context, index) {
                    var coin = coins[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        child: Text(
                          coin['symbol'][0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(coin['name']),
                      subtitle: Text(coin['symbol']),
                      trailing: Text(
                        '\$${coin['price'].toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          selectedCoin = coin['symbol'];
                          currentPrice = coin['price'];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _navigateToOptionDetail(Map<String, dynamic> option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionDetailScreen(
          coin: selectedCoin,
          option: option,
          currentPrice: currentPrice,
          timeToExpiry: timeToExpiry,
        ),
      ),
    );
  }
}

class OptionDetailScreen extends StatefulWidget {
  final String coin;
  final Map<String, dynamic> option;
  final double currentPrice;
  final Duration timeToExpiry;
  
  OptionDetailScreen({
    required this.coin,
    required this.option,
    required this.currentPrice,
    required this.timeToExpiry,
  });
  
  @override
  _OptionDetailScreenState createState() => _OptionDetailScreenState();
}

class _OptionDetailScreenState extends State<OptionDetailScreen> {
  bool isOpenSelected = true;
  double selectedPrice = 470.2;
  double maxAmount = 0.0;
  Timer? _countdownTimer;
  Duration timeToExpiry = Duration();
  
  @override
  void initState() {
    super.initState();
    timeToExpiry = widget.timeToExpiry;
    _startCountdown();
  }
  
  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
  
  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeToExpiry.inSeconds > 0) {
          timeToExpiry = timeToExpiry - Duration(seconds: 1);
        }
      });
    });
  }
  
  String _formatCountdown(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
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
        title: Text(
          '${widget.coin}USDT ${widget.currentPrice.toStringAsFixed(1)}',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Icon(Icons.share, color: Colors.grey),
          SizedBox(width: 16),
          Icon(Icons.bookmark_border, color: Colors.grey),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.grey),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Open/Close tabs
          Container(
            margin: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isOpenSelected = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isOpenSelected ? Colors.white : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isOpenSelected ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ] : [],
                      ),
                      child: Text(
                        'Open',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isOpenSelected ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isOpenSelected = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: !isOpenSelected ? Colors.white : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: !isOpenSelected ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ] : [],
                      ),
                      child: Text(
                        'Close',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !isOpenSelected ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Buy title and price
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Buy ${widget.coin} ${widget.option['strikePrice'].toStringAsFixed(1)} Call',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.option['markPrice'].toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Time to expiry
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Time to Expiry: ${_formatCountdown(timeToExpiry)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Available balance
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 16),
                Spacer(),
                Text(
                  '0.0000 USDT',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Icon(Icons.account_balance_wallet, color: const Color.fromARGB(255, 122, 79, 223), size: 16),
              ],
            ),
          ),
          
          // Amount section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount (Cont)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Icon(Icons.add, color: Colors.grey[400]),
                  ],
                ),
                SizedBox(height: 16),
                
                // Percentage buttons
                Row(
                  children: ['25%', '50%', '75%', '100%'].map((percentage) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: percentage != '100%' ? 8 : 0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(percentage),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                SizedBox(height: 16),
                
                // Max Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Max Amount',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '0.00',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Price section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() => selectedPrice = (selectedPrice - 0.1).clamp(0, 1000)),
                  icon: Icon(Icons.remove, color: Colors.grey[600]),
                ),
                Column(
                  children: [
                    Text(
                      'Price (USDT)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      selectedPrice.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => selectedPrice += 0.1),
                      icon: Icon(Icons.add, color: Colors.grey[600]),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'BBO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Order book info
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bid Price / Size',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '54.0 / 1.00',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Last Price',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '464.8',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Ask Price / Size',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '1,000.0 / 5.30',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Estimated PnL section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Estimated PnL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.info_outline, color: Colors.grey[400], size: 16),
                  ],
                ),
                SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Max Profit', style: TextStyle(color: Colors.grey[600])),
                    Text('--', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Max Loss', style: TextStyle(color: Colors.grey[600])),
                    Text('--', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Breakeven Price (%)', style: TextStyle(color: Colors.grey[600])),
                    Text('--', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          
          Spacer(),
          
          // Total cost and open account button
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Cost',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '0.0000 USDT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Open Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.arrow_back, color: Colors.grey),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
            ),
            Icon(Icons.menu, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}