import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileDiscountBuyScreen extends StatefulWidget {
  const MobileDiscountBuyScreen({Key? key}) : super(key: key);

  @override
  State<MobileDiscountBuyScreen> createState() => _MobileDiscountBuyScreenState();
}

class _MobileDiscountBuyScreenState extends State<MobileDiscountBuyScreen> {
  String selectedCrypto = 'BTC';
  Timer? _timer;
  
  // Mock data for real-time updates
  List<Map<String, dynamic>> btcData = [
    {'price': 107009.0, 'percentage': 1.59, 'knockoutPrice': 112000.0, 'date': '2025-09-30', 'days': 5},
    {'price': 106685.0, 'percentage': 1.89, 'knockoutPrice': 111000.0, 'date': '2025-09-30', 'days': 5},
    {'price': 106287.0, 'percentage': 2.26, 'knockoutPrice': 110000.0, 'date': '2025-09-30', 'days': 5},
    {'price': 106772.0, 'percentage': 1.81, 'knockoutPrice': 115000.0, 'date': '2025-10-03', 'days': 8},
    {'price': 106566.0, 'percentage': 2.0, 'knockoutPrice': 114000.0, 'date': '2025-10-03', 'days': 8},
    {'price': 106231.0, 'percentage': 2.31, 'knockoutPrice': 113000.0, 'date': '2025-10-03', 'days': 8},
  ];

  List<Map<String, dynamic>> ethData = [
    {'price': 3789.0, 'percentage': 2.15, 'knockoutPrice': 4000.0, 'date': '2025-09-30', 'days': 5},
    {'price': 3756.0, 'percentage': 2.41, 'knockoutPrice': 3950.0, 'date': '2025-09-30', 'days': 5},
    {'price': 3723.0, 'percentage': 2.68, 'knockoutPrice': 3900.0, 'date': '2025-09-30', 'days': 5},
    {'price': 3812.0, 'percentage': 1.89, 'knockoutPrice': 4100.0, 'date': '2025-10-03', 'days': 8},
    {'price': 3798.0, 'percentage': 2.05, 'knockoutPrice': 4050.0, 'date': '2025-10-03', 'days': 8},
    {'price': 3784.0, 'percentage': 2.21, 'knockoutPrice': 4000.0, 'date': '2025-10-03', 'days': 8},
  ];

  double myHoldings = 0.0;
  double totalProfit = 0.0;

  @override
  void initState() {
    super.initState();
    _startRealTimeUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRealTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _updatePrices();
      });
    });
  }

  void _updatePrices() {
    final random = Random();
    if (selectedCrypto == 'BTC') {
      for (var item in btcData) {
        // Small random price fluctuations
        double change = (random.nextDouble() - 0.5) * 100;
        item['price'] = (item['price'] + change).clamp(100000.0, 120000.0);
        
        // Recalculate percentage
        double basePrice = selectedCrypto == 'BTC' ? 108000.0 : 3800.0;
        item['percentage'] = ((basePrice - item['price']) / basePrice * 100).abs();
      }
    } else {
      for (var item in ethData) {
        double change = (random.nextDouble() - 0.5) * 10;
        item['price'] = (item['price'] + change).clamp(3500.0, 4200.0);
        
        double basePrice = 3800.0;
        item['percentage'] = ((basePrice - item['price']) / basePrice * 100).abs();
      }
    }
    
    // Update holdings and profit with small random changes
    myHoldings += (random.nextDouble() - 0.5) * 10;
    totalProfit += (random.nextDouble() - 0.5) * 5;
  }

  List<Map<String, dynamic>> get currentData {
    return selectedCrypto == 'BTC' ? btcData : ethData;
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Discount Buy - Buy Crypto a...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Text(
              'Discount Buy',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Buy Crypto at a Discount, Earn Rewards with Ease',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            
            // What is Discount Buy Section
            Row(
              children: [
                const Text(
                  'What is Discount Buy?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Holdings and Profit Section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'My Holdings',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '≈ \$${myHoldings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Total Profit',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '≈ \$${totalProfit.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Crypto Toggle Buttons
            Row(
              children: [
                _buildCryptoToggle('BTC', Icons.currency_bitcoin, const Color.fromARGB(255, 122, 79, 223)),
                const SizedBox(width: 12),
                _buildCryptoToggle('ETH', Icons.diamond, Colors.blue),
              ],
            ),
            const SizedBox(height: 30),
            
            // Table Header
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Target Buy Price',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Knockout APR / Price',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Dynamic Data Rows
            ...currentData.map((item) => _buildDataRow(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoToggle(String crypto, IconData icon, Color iconColor) {
    bool isSelected = selectedCrypto == crypto;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCrypto = crypto;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              crypto,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> item) {
    String currency = selectedCrypto == 'BTC' ? 'USDT' : 'USDT';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['price'].toStringAsFixed(selectedCrypto == 'BTC' ? 0 : 0)} $currency',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.green,
                      size: 16,
                    ),
                    Text(
                      '${item['percentage'].toStringAsFixed(2)}%',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '30%',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
                        text: ' / ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: '${item['knockoutPrice'].toStringAsFixed(0)} $currency',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['date']} / ${item['days']} Days',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}