import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Main Spot Trading Screen
class MobileSpotScreen extends StatefulWidget {
  @override
  _MobileSpotScreenState createState() => _MobileSpotScreenState();
}

class _MobileSpotScreenState extends State<MobileSpotScreen>
    with TickerProviderStateMixin {
  bool isBuySelected = true;
  bool isLimitOrder = true;
  bool tpSlEnabled = false;
  bool icebergEnabled = false;
  double currentPrice = 4476.18;
  double priceChange = -1.40;
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    priceController.text = currentPrice.toString();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    // Simulate real-time price updates
    _startPriceUpdates();
  }

  void _startPriceUpdates() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          currentPrice += (0.5 - 1.0 * 0.5) * 2; // Random price change
          priceController.text = currentPrice.toStringAsFixed(2);
        });
        _startPriceUpdates();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    priceController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text('Jio', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.trending_up, color: Colors.white, size: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),*/
      body: Column(
        children: [
          // Navigation tabs
          /*Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildNavTab('Convert', false),
                _buildNavTab('Spot', true),
                _buildNavTab('Margin', false),
                _buildNavTab('Buy/Sell', false),
                _buildNavTab('P2P', false),
              ],
            ),
          ),*/
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Currency pair header
                  _buildCurrencyHeader(),
                  
                  SizedBox(height: 16),
                  
                  // Buy/Sell toggle
                  _buildBuySellToggle(),
                  
                  SizedBox(height: 16),
                  
                  // Order type and price input
                  _buildOrderSection(),
                  
                  SizedBox(height: 16),
                  
                  // Order book preview
                  _buildOrderBookPreview(),
                  
                  SizedBox(height: 16),
                  
                  // Additional options
                  _buildAdditionalOptions(),
                  
                  SizedBox(height: 20),
                  
                  // Buy button
                  _buildBuyButton(),
                  
                  SizedBox(height: 20),
                  
                  // Bottom tabs
                  _buildBottomTabs(),
                  
                  SizedBox(height: 16),
                  
                  // Available funds
                  _buildAvailableFunds(),
                ],
              ),
            ),
          ),
          
          // Bottom navigation
          //_buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildNavTab(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCurrencyHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'BTC/USDT',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChartScreen(),
                      ),
                    );
                  },
                  child: Icon(Icons.candlestick_chart, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            Text(
              '${priceChange.toStringAsFixed(2)}%',
              style: TextStyle(
                color: priceChange < 0 ? Colors.red : Colors.green,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuySellToggle() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isBuySelected = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isBuySelected ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      color: isBuySelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isBuySelected = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isBuySelected ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Sell',
                    style: TextStyle(
                      color: !isBuySelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSection() {
    return Column(
      children: [
        // Order type selector
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 16),
              SizedBox(width: 8),
              Text('Limit', style: TextStyle(fontSize: 16)),
              Spacer(),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
        
        SizedBox(height: 12),
        
        // Price input
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price (USDT)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 16),
                          onPressed: () {
                            double currentVal = double.tryParse(priceController.text) ?? 0;
                            priceController.text = (currentVal - 0.01).toStringAsFixed(2);
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '4476.18',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 16),
                          onPressed: () {
                            double currentVal = double.tryParse(priceController.text) ?? 0;
                            priceController.text = (currentVal + 0.01).toStringAsFixed(2);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12),
        
        // Amount input
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount (ETH)', style: TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.0000',
                        contentPadding: EdgeInsets.all(12),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 16),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: 8),
        
        // Percentage buttons
        Row(
          children: [
            Icon(Icons.swap_horiz, color: Colors.grey, size: 16),
            Spacer(),
          ],
        ),
        
        SizedBox(height: 12),
        
        // Total
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total (USDT)', style: TextStyle(color: Colors.grey)),
              Text('--', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderBookPreview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Price (USDT)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Amount (ETH)', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 8),
          ...List.generate(7, (index) {
            double price = 4476.60 - (index * 0.01);
            double amount = [0.0024, 0.0012, 0.0024, 2.4522, 0.0048, 0.0096, 7.9105][index];
            bool isBest = index == 6;
            
            return Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: isBest ? Colors.red[50] : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price.toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Text(
                    amount.toStringAsFixed(4),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
          
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '4,476.53',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Text('≈ ₹394,382.29', style: TextStyle(fontSize: 10, color: Colors.grey)),
          
          SizedBox(height: 8),
          
          ...List.generate(5, (index) {
            double price = 4476.53 + ((index + 1) * 0.01);
            double amount = [68.2132, 3.8237, 0.7331, 0.0483, 0.0024][index];
            
            return Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price.toStringAsFixed(2),
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                  Text(
                    amount.toStringAsFixed(4),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }),
          
          SizedBox(height: 8),
          
          // Buy/Sell ratio
          Row(
            children: [
              Container(
                width: 12,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(2)),
                ),
              ),
              Expanded(
                child: Container(
                  height: 4,
                  color: Colors.green,
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  width: 20,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('88.07%', style: TextStyle(color: Colors.green, fontSize: 12)),
              Text('11.93%', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: tpSlEnabled,
              onChanged: (value) => setState(() => tpSlEnabled = value!),
            ),
            Text('TP/SL', style: TextStyle(fontSize: 14)),
            SizedBox(width: 20),
            Checkbox(
              value: icebergEnabled,
              onChanged: (value) => setState(() => icebergEnabled = value!),
            ),
            Text('Iceberg', style: TextStyle(fontSize: 14)),
          ],
        ),
        
        SizedBox(height: 12),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Avbl', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Max Buy', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Est. Fee', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text('0 USDT', style: TextStyle(fontSize: 12)),
                    Icon(Icons.add_circle, color: const Color.fromARGB(255, 122, 79, 223), size: 16),
                  ],
                ),
                Text('0 ETH', style: TextStyle(fontSize: 12)),
                Text('-- ETH', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuyButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle buy order
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isBuySelected ? Colors.green : Colors.red,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          isBuySelected ? 'Buy ETH' : 'Sell ETH',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 122, 79, 223), width: 2)),
          ),
          child: Text(
            'Open Orders (0)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 20),
        Text('Holdings (0)', style: TextStyle(color: Colors.grey)),
        SizedBox(width: 20),
        Text('Spot Grid', style: TextStyle(color: Colors.grey)),
        Spacer(),
        Icon(Icons.copy, color: Colors.grey, size: 16),
      ],
    );
  }

  Widget _buildAvailableFunds() {
    return Column(
      children: [
        SizedBox(height: 40),
        Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.grey[300]),
        SizedBox(height: 8),
        Text(
          'Available Funds: 0.00 USDT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'Transfer funds to your Spot wallet to trade',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 122, 79, 223),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Increase Balance', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 20),
        Text('ETH/USDT Chart', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Icon(Icons.keyboard_arrow_up, color: Colors.grey),
      ],
    );
  }

  /*Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.trending_up, 'Markets', false),
          _buildNavItem(Icons.swap_horiz, 'Trade', true),
          _buildNavItem(Icons.document_scanner, 'Futures', false),
          _buildNavItem(Icons.account_balance_wallet, 'Assets', false),
        ],
      ),
    );
  }*/

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey,
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// Chart Screen (Images 2 and 3)
class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> with TickerProviderStateMixin {
  bool showOrderBook = false;
  double currentPrice = 4476.69;
  double priceChange = -1.37;
  String selectedTimeframe = '15m';
  late AnimationController _priceAnimationController;
  
  @override
  void initState() {
    super.initState();
    _priceAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _startRealTimeUpdates();
  }

  void _startRealTimeUpdates() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          currentPrice += (0.5 - 1.0) * 2; // Simulate price movement
          priceChange = ((currentPrice - 4476.69) / 4476.69) * 100;
        });
        _priceAnimationController.forward().then((_) {
          _priceAnimationController.reset();
        });
        _startRealTimeUpdates();
      }
    });
  }

  @override
  void dispose() {
    _priceAnimationController.dispose();
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
              'BTC/USDT',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
        actions: [
          Icon(Icons.auto_awesome, color: Colors.blue),
          SizedBox(width: 8),
          Icon(Icons.star_border, color: const Color.fromARGB(255, 122, 79, 223)),
          SizedBox(width: 8),
          Icon(Icons.share, color: Colors.black),
          SizedBox(width: 8),
          Icon(Icons.notifications_outlined, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Price info and tabs
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabs
                Row(
                  children: [
                    _buildTab('Price', true),
                    _buildTab('Info', false),
                    _buildTab('Trading Data', false),
                    _buildTab('Square', false),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Trade', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text('New', style: TextStyle(color: Colors.white, fontSize: 8)),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Price display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedBuilder(
                      animation: _priceAnimationController,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            color: _priceAnimationController.isAnimating 
                                ? (priceChange >= 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Text(
                            currentPrice.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: priceChange >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('24h High', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('4,549.00', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        Text('24h Low', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('4,435.70', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('24h Vol(ETH)', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('270,592.28', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        Text('24h Vol(USDT)', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('1.21B', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                
                Row(
                  children: [
                    Text(
                      '₹394,396.38',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${priceChange.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: priceChange >= 0 ? Colors.green : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // Layer info
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Layer 1 / Layer...', style: TextStyle(fontSize: 10, color: const Color.fromARGB(255, 122, 79, 223))),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Vol', style: TextStyle(fontSize: 10, color: const Color.fromARGB(255, 122, 79, 223))),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Price Protection', style: TextStyle(fontSize: 10, color: const Color.fromARGB(255, 122, 79, 223))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Chart section
          Expanded(
            child: showOrderBook ? _buildOrderBook() : _buildChart(),
          ),
          
          // Bottom buttons
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Buy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Sell', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
            IconButton(icon: Icon(Icons.apps), onPressed: () {}),
            IconButton(icon: Icon(Icons.percent), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? const Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Timeframe selector
          Row(
            children: [
              Text('Time', style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(width: 16),
              ...['15m', '1h', '4h', '1D'].map((timeframe) => 
                GestureDetector(
                  onTap: () => setState(() => selectedTimeframe = timeframe),
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectedTimeframe == timeframe ? Colors.orange[100] : null,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      timeframe,
                      style: TextStyle(
                        color: selectedTimeframe == timeframe ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ).toList(),
              Text('More', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
              Spacer(),
              Text('Depth', style: TextStyle(color: Colors.grey, fontSize: 12)),
              SizedBox(width: 8),
              Icon(Icons.tune, color: Colors.grey, size: 16),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => showOrderBook = !showOrderBook),
                child: Icon(Icons.grid_view, color: Colors.grey, size: 16),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // MA indicator
          Row(
            children: [
              Text('MA60 4,473.83', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Spacer(),
              Text('4,478.19', style: TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Chart area (simplified representation)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: CandlestickChartPainter(currentPrice),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Volume indicator
          Row(
            children: [
              Text('Vol: 45.1226', style: TextStyle(color: Colors.grey, fontSize: 10)),
              SizedBox(width: 16),
              Text('MA(5): 45.5576', style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223), fontSize: 10)),
              SizedBox(width: 16),
              Text('MA(10): 53.9367', style: TextStyle(color: Colors.purple, fontSize: 10)),
              Spacer(),
              Text('263', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          
          SizedBox(height: 8),
          
          // Volume bars (simplified)
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(20, (index) {
                bool isGreen = index % 3 != 0;
                double height = 20 + (index % 4) * 10.0;
                return Container(
                  width: (MediaQuery.of(context).size.width - 64) / 20,
                  height: height,
                  margin: EdgeInsets.only(right: 1),
                  color: isGreen ? Colors.green : Colors.red,
                );
              }),
            ),
          ),
          
          SizedBox(height: 8),
          
          // Technical indicators
          Row(
            children: [
              ...['MA', 'EMA', 'BOLL', 'SAR', 'AVL', 'VOL', 'MACD', 'RSI'].map((indicator) =>
                Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Text(indicator, style: TextStyle(color: Colors.grey, fontSize: 10)),
                ),
              ).toList(),
              Icon(Icons.show_chart, color: Colors.grey, size: 16),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Performance indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPerformanceItem('Today', '0.38%', Colors.green),
              _buildPerformanceItem('7 Days', '-2.93%', Colors.red),
              _buildPerformanceItem('30 Days', '3.03%', Colors.green),
              _buildPerformanceItem('90 Days', '86.59%', Colors.green),
              _buildPerformanceItem('180 Days', '124.65%', Colors.green),
              _buildPerformanceItem('1 Year', '80.81%', Colors.green),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Order book toggle
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => showOrderBook = false),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: showOrderBook ? Colors.transparent : const Color.fromARGB(255, 122, 79, 223), width: 2)),
                  ),
                  child: Text(
                    'Order Book',
                    style: TextStyle(
                      color: showOrderBook ? Colors.grey : Colors.black,
                      fontWeight: showOrderBook ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => setState(() => showOrderBook = true),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Trades',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          
          // Buy/Sell ratio
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 99,
                  child: Container(
                    height: 4,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 4,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('99.23%', style: TextStyle(color: Colors.green, fontSize: 12)),
              Text('0.77%', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderBook() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Order book header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bid', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Ask', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                children: [
                  Text('0.01', style: TextStyle(fontSize: 12)),
                  Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // Order book data
          Expanded(
            child: ListView(
              children: [
                ...List.generate(25, (index) {
                  List<List<double>> bids = [
                    [132.0079, 4476.99, 10.4757],
                    [4.6833, 4476.98, 0.0108],
                    [6.8257, 4476.97, 0.0012],
                    [0.0247, 4476.96, 0.0012],
                    [0.0024, 4476.94, 0.0048],
                    [0.0036, 4476.93, 0.0132],
                    [1.7743, 4476.92, 0.0050],
                    [0.0024, 4476.89, 0.0034],
                    [0.0012, 4476.86, 0.0024],
                    [0.4036, 4476.85, 0.1153],
                    [1.0347, 4476.84, 0.1786],
                    [0.0012, 4476.81, 0.0447],
                    [9.4513, 4476.80, 0.0024],
                    [0.0235, 4476.78, 1.1864],
                    [6.5628, 4476.77, 0.0135],
                    [3.3511, 4476.76, 1.8070],
                    [1.9067, 4476.74, 0.0336],
                    [8.2645, 4476.68, 0.0201],
                    [0.2200, 4476.66, 0.0023],
                    [3.6825, 4476.65, 0.0314],
                    [0.0223, 4476.62, 0.1957],
                    [0.0235, 4476.60, 8.9286],
                    [3.9073, 4476.57, 2.4811],
                    [35.2333, 4476.56, 0.6455],
                    [27.4449, 4476.55, 0.1000],
                  ];
                  
                  List<List<double>> asks = [
                    [4477.00, 10.4757],
                    [4477.01, 0.0108],
                    [4477.04, 0.0012],
                    [4477.05, 0.0012],
                    [4477.06, 0.0048],
                    [4477.07, 0.0132],
                    [4477.09, 0.0050],
                    [4477.10, 0.0034],
                    [4477.11, 0.0024],
                    [4477.12, 0.1153],
                    [4477.13, 0.1786],
                    [4477.15, 0.0447],
                    [4477.17, 0.0024],
                    [4477.18, 1.1864],
                    [4477.21, 0.0135],
                    [4477.22, 1.8070],
                    [4477.25, 0.0336],
                    [4477.26, 0.0201],
                    [4477.38, 0.0023],
                    [4477.43, 0.0314],
                    [4477.44, 0.1957],
                    [4477.45, 8.9286],
                    [4477.50, 2.4811],
                    [4477.52, 0.6455],
                    [4477.53, 0.1000],
                  ];
                  
                  if (index < bids.length) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              bids[index][0].toStringAsFixed(4),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bids[index][1].toStringAsFixed(2),
                              style: TextStyle(color: Colors.green, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              asks[index][0].toStringAsFixed(2),
                              style: TextStyle(color: Colors.red, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              asks[index][1].toStringAsFixed(4),
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(String period, String percentage, Color color) {
    return Column(
      children: [
        Text(period, style: TextStyle(color: Colors.grey, fontSize: 10)),
        SizedBox(height: 2),
        Text(percentage, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Custom painter for candlestick chart
class CandlestickChartPainter extends CustomPainter {
  final double currentPrice;
  
  CandlestickChartPainter(this.currentPrice);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color.fromARGB(255, 122, 79, 223)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final Paint candlePaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    
    final Paint maPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Draw moving average line
    Path maPath = Path();
    for (int i = 0; i < 50; i++) {
      double x = (i / 49) * size.width;
      double y = size.height * 0.6 + sin(i * 0.2) * 20;
      if (i == 0) {
        maPath.moveTo(x, y);
      } else {
        maPath.lineTo(x, y);
      }
    }
    canvas.drawPath(maPath, maPaint);
    
    // Draw candlesticks
    for (int i = 0; i < 20; i++) {
      double x = (i / 19) * size.width;
      double candleWidth = size.width / 25;
      
      // Generate random OHLC data
      double open = size.height * 0.6 + (sin(i * 0.3) * 30);
      double close = open + (cos(i * 0.4) * 20);
      double high = [open, close].reduce((a, b) => a > b ? a : b) + 10;
      double low = [open, close].reduce((a, b) => a < b ? a : b) - 10;
      
      bool isGreen = close > open;
      candlePaint.color = isGreen ? Colors.green : Colors.red;
      
      // Draw high-low line
      canvas.drawLine(
        Offset(x, high),
        Offset(x, low),
        Paint()..color = candlePaint.color..strokeWidth = 1,
      );
      
      // Draw candle body
      canvas.drawRect(
        Rect.fromLTWH(
          x - candleWidth / 2,
          isGreen ? close : open,
          candleWidth,
          (open - close).abs(),
        ),
        candlePaint,
      );
    }
    
    // Draw main price line
    Path pricePath = Path();
    for (int i = 0; i < 100; i++) {
      double x = (i / 99) * size.width;
      double y = size.height * 0.4 + sin(i * 0.1) * 40 + cos(i * 0.05) * 20;
      if (i == 0) {
        pricePath.moveTo(x, y);
      } else {
        pricePath.lineTo(x, y);
      }
    }
    canvas.drawPath(pricePath, linePaint);
    
    // Draw current price indicator
    final double priceY = size.height * 0.5;
    canvas.drawLine(
      Offset(0, priceY),
      Offset(size.width, priceY),
      Paint()..color = Colors.red.withOpacity(0.5)..strokeWidth = 1..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}