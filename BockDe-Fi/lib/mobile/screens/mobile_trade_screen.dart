/*import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_buy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_p2p_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spot_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MobileTradeScreen extends StatefulWidget {
  @override
  _MobileTradeScreenState createState() => _MobileTradeScreenState();
}

class _MobileTradeScreenState extends State<MobileTradeScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _subTabController;
  late PageController _pageController;
  
  // Current selections
  int _currentMainTab = 0;
  int _currentSubTab = 0;
  int _currentPage = 0;
  
  // Form controllers
  TextEditingController _fromAmountController = TextEditingController();
  TextEditingController _toAmountController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  
  // Selected cryptocurrencies
  String _selectedFromCoin = 'BARD';
  String _selectedToCoin = 'USDT';
  
  // Available coins with real prices (simulated)
  final Map<String, Map<String, dynamic>> _coins = {
    'BARD': {'name': 'Bard', 'price': 0.011, 'icon': '🟢', 'balance': 0.0},
    'USDT': {'name': 'Tether', 'price': 1.0, 'icon': '🔵', 'balance': 0.0},
    'BTC': {'name': 'Bitcoin', 'price': 45000.0, 'icon': '🟠', 'balance': 0.0},
    'ETH': {'name': 'Ethereum', 'price': 2800.0, 'icon': '🔷', 'balance': 0.0},
    'BNB': {'name': 'BOCK De-Fi Coin', 'price': 320.0, 'icon': '🟡', 'balance': 0.0},
    'ADA': {'name': 'Cardano', 'price': 0.45, 'icon': '🔵', 'balance': 0.0},
    'SOL': {'name': 'Solana', 'price': 95.0, 'icon': '🟣', 'balance': 0.0},
    'DOT': {'name': 'Polkadot', 'price': 6.2, 'icon': '🔴', 'balance': 0.0},
    'MATIC': {'name': 'Polygon', 'price': 0.85, 'icon': '🟣', 'balance': 0.0},
    'LINK': {'name': 'Chainlink', 'price': 12.5, 'icon': '🔵', 'balance': 0.0},
  };
  
  // Timer for real-time updates
  Timer? _priceUpdateTimer;
  
  // Recurring plan settings
  String _frequency = 'Daily, 0.5:00 (UTC+5)';
  String _assetsDestination = 'Spot Account';
  double _recurringPercentage = 100.0;
  
  // Limit order settings
  String _orderExpiry = 'Expires in 30 days';

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 6, vsync: this);
    _subTabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0);
    
    // Listen to tab changes
    _mainTabController.addListener(() {
      if (!_mainTabController.indexIsChanging) {
        int targetPage = _mainTabController.index;
        if (targetPage == 0) {
          targetPage = _currentSubTab;
        } else {
          targetPage = targetPage + 2;
        }
        _pageController.animateToPage(
          targetPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    _subTabController.addListener(() {
      if (!_subTabController.indexIsChanging && _currentPage < 3) {
        _pageController.animateToPage(
          _subTabController.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    // Start real-time price updates
    _startPriceUpdates();
  }
  
  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        // Simulate price fluctuations
        _coins.forEach((key, value) {
          double basePrice = value['price'];
          double fluctuation = (Random().nextDouble() - 0.5) * 0.02; // ±1% change
          _coins[key]!['price'] = basePrice * (1 + fluctuation);
        });
        _updateConversion();
      });
    });
  }
  
  void _updateConversion() {
    if (_fromAmountController.text.isNotEmpty) {
      double fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
      double fromPrice = _coins[_selectedFromCoin]!['price'];
      double toPrice = _coins[_selectedToCoin]!['price'];
      double toAmount = (fromAmount * fromPrice) / toPrice;
      _toAmountController.text = toAmount.toStringAsFixed(6);
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      
      // Update subtab controller for Convert pages
      if (page < 3) {
        _currentSubTab = page;
        _subTabController.animateTo(page);
        if (_mainTabController.index != 0) {
          _mainTabController.animateTo(0);
        }
      } else {
        // Update main tab controller for other pages
        int mainTabIndex = page - 2;
        if (_mainTabController.index != mainTabIndex) {
          _mainTabController.animateTo(mainTabIndex);
        }
      }
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _subTabController.dispose();
    _pageController.dispose();
    _priceUpdateTimer?.cancel();
    _fromAmountController.dispose();
    _toAmountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Main Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _mainTabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.transparent,
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                tabs: [
                  Tab(text: 'Convert'),
                  Tab(text: 'Spot'),
                  Tab(text: 'Margin'),
                  Tab(text: 'Buy/Sell'),
                  Tab(text: 'P2P'),
                  Tab(text: 'Alpha'),
                ],
              ),
            ),
            
            // Content with PageView for smooth swiping
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildInstantTab(),
                  _buildRecurringTab(),
                  _buildLimitTab(),
                  _buildSpotTab(),
                  _buildMarginTab(),
                  _buildBuySellTab(),
                  _buildP2PTab(),
                  _buildAlphaTab(),
                ],
              ),
            ),
            
            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstantTab() {
    return Column(
      children: [
        // Sub Tabs - only show when in convert pages
        if (_currentPage < 3)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _subTabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: 'Instant'),
                Tab(text: 'Recurring'),
                Tab(text: 'Limit'),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('From', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Row(
                      children: [
                        Text('Available ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('${_coins[_selectedFromCoin]!['balance']} $_selectedFromCoin', 
                             style: TextStyle(color: Colors.black, fontSize: 12)),
                        SizedBox(width: 4),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 122, 79, 223),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // From coin selection
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildCoinDropdown(_selectedFromCoin, (value) {
                        setState(() {
                          _selectedFromCoin = value!;
                          _updateConversion();
                        });
                      }),
                      Expanded(
                        child: TextField(
                          controller: _fromAmountController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.011',
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onChanged: (value) => _updateConversion(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Swap icon
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.swap_vert, color: Colors.grey),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // To section
                Text('To', style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(height: 8),
                
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildCoinDropdown(_selectedToCoin, (value) {
                        setState(() {
                          _selectedToCoin = value!;
                          _updateConversion();
                        });
                      }),
                      Expanded(
                        child: TextField(
                          controller: _toAmountController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.01',
                            contentPadding: EdgeInsets.all(16),
                          ),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Spacer(),
                
                // Preview button
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _showPreviewDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Preview',
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringTab() {
    return Column(
      children: [
        // Sub Tabs - only show when in convert pages
        if (_currentPage < 3)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _subTabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: 'Instant'),
                Tab(text: 'Recurring'),
                Tab(text: 'Limit'),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('From', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Row(
                      children: [
                        Text('Available ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('0 USDT', style: TextStyle(color: Colors.black, fontSize: 12)),
                        SizedBox(width: 4),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 122, 79, 223),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // From USDT
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildCoinDropdown('USDT', (value) {}),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.1 = 4900000',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // To section with percentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('To (100%/100%)', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 8),
                
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildCoinDropdown('BTC', (value) {}),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('100%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.close, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Frequency
                _buildSettingRow('Frequency', _frequency, () {
                  _showFrequencyDialog();
                }),
                
                SizedBox(height: 16),
                
                // Assets Destination
                _buildSettingRow('Assets Destination', _assetsDestination, () {
                  _showDestinationDialog();
                }),
                
                SizedBox(height: 16),
                
                // Advanced Options
                Row(
                  children: [
                    Text('Advanced Options', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
                
                Spacer(),
                
                // Create a plan button
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _showCreatePlanDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Create a plan',
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Recurring Plan section
                Text('Recurring Plan (0)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLimitTab() {
    return Column(
      children: [
        // Sub Tabs - only show when in convert pages
        if (_currentPage < 3)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _subTabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: 'Instant'),
                Tab(text: 'Recurring'),
                Tab(text: 'Limit'),
              ],
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('From', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Row(
                      children: [
                        Text('Available ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('0 BARD', style: TextStyle(color: Colors.black, fontSize: 12)),
                        SizedBox(width: 4),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 122, 79, 223),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // From BARD
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildCoinDropdown('BARD', (value) {}),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.011 = 8600',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Swap icon
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.swap_vert, color: Colors.grey),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // To section
                Text('To', style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(height: 8),
                
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildCoinDropdown('BNB', (value) {}),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00001 = 8.1',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Price section
                Text('Price', style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(height: 8),
                
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildCoinDropdown('BNB', (value) {}),
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.000945',
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Expires in
                _buildSettingRow('Expires in', _orderExpiry, () {
                  _showExpiryDialog();
                }),
                
                Spacer(),
                
                // Preview button
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLimitPreviewDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Preview',
                      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Open Orders section
                Text('Open Orders (0)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoinDropdown(String selectedCoin, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DropdownButton<String>(
        value: selectedCoin,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down),
        onChanged: onChanged,
        items: _coins.keys.map((String coin) {
          return DropdownMenuItem<String>(
            value: coin,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_coins[coin]!['icon'], style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text(coin, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingRow(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
          Row(
            children: [
              Text(value, style: TextStyle(color: Colors.black, fontSize: 14)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpotTab() {
    return MobileSpotScreen();
  }

  Widget _buildMarginTab() {
    return MobileSpotScreen();
  }

  Widget _buildBuySellTab() {
    return MobileBuyScreen();
  }

  Widget _buildP2PTab() {
    return MobileP2pScreen();
  }

  Widget _buildAlphaTab() {
    return MobileAlphaScreen();
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
    );
  }

  // Dialog methods
  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Convert Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${_fromAmountController.text} $_selectedFromCoin'),
            Text('To: ${_toAmountController.text} $_selectedToCoin'),
            Text('Rate: 1 $_selectedFromCoin = ${(_coins[_selectedFromCoin]!['price'] / _coins[_selectedToCoin]!['price']).toStringAsFixed(6)} $_selectedToCoin'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Conversion executed successfully!')),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showCreatePlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Recurring Plan'),
        content: Text('Your recurring plan will be created with the specified parameters.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recurring plan created successfully!')),
              );
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showLimitPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limit Order Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Type: Limit'),
            Text('Price: ${_priceController.text} BNB'),
            Text('Expires: $_orderExpiry'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Limit order placed successfully!')),
              );
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }

  void _showFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Daily, 0.5:00 (UTC+5)',
            'Weekly, Monday',
            'Monthly, 1st day',
          ].map((freq) => RadioListTile<String>(
            title: Text(freq),
            value: freq,
            groupValue: _frequency,
            onChanged: (value) {
              setState(() {
                _frequency = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showDestinationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assets Destination'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Spot Account',
            'Futures Account',
            'Margin Account',
          ].map((dest) => RadioListTile<String>(
            title: Text(dest),
            value: dest,
            groupValue: _assetsDestination,
            onChanged: (value) {
              setState(() {
                _assetsDestination = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showExpiryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Expiry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Expires in 1 day',
            'Expires in 7 days',
            'Expires in 30 days',
            'Good Till Cancelled',
          ].map((expiry) => RadioListTile<String>(
            title: Text(expiry),
            value: expiry,
            groupValue: _orderExpiry,
            onChanged: (value) {
              setState(() {
                _orderExpiry = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }
}*/

// ============================================
// FILE: lib/mobile/screens/mobile_trade_screen.dart
// COMPLETE REAL-TIME VERSION - READY TO USE
// ============================================

/*import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_buy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_p2p_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spot_screen.dart';
import 'package:bockchain/services/blockchain_service.dart'; // ← Using BlockchainService
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class MobileTradeScreen extends StatefulWidget {
  @override
  _MobileTradeScreenState createState() => _MobileTradeScreenState();
}

class _MobileTradeScreenState extends State<MobileTradeScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late PageController _pageController;
  
  // Current selections
  int _currentPage = 0;
  
  // Form controllers
  TextEditingController _fromAmountController = TextEditingController();
  TextEditingController _toAmountController = TextEditingController();
  
  // Selected cryptocurrencies
  String _selectedFromCoin = 'BARD';
  String _selectedToCoin = 'USDT';
  
  // Slippage settings
  double _slippage = 0.5;
  
  // Loading states
  bool _isLoadingQuote = false;
  bool _isExecutingSwap = false;
  
  // Real-time features
  bool _isRealTimeEnabled = true;
  int? _lastUpdateTimestamp;
  
  // Quote data from blockchain
  Map<String, dynamic>? _currentQuote;
  
  // Contract addresses (BSC Mainnet)
  final Map<String, String> _tokenAddresses = {
    'BARD': '0x1234567890123456789012345678901234567890', // Replace with actual
    'USDT': '0x55d398326f99059fF775485246999027B3197955', // Real USDT on BSC
    'BTC': '0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c',
    'ETH': '0x2170Ed0880ac9A755fd29B2688956BD959F933F8',
    'BNB': '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c',
    'ADA': '0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47',
    'SOL': '0x570A5D26f7765Ecb712C0924E4De545B89fD43dF',
    'DOT': '0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402',
    'MATIC': '0xCC42724C6683B7E57334c4E856f4c9965ED682bD',
    'LINK': '0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD',
  };
  
  // Available coins with balances
  final Map<String, Map<String, dynamic>> _coins = {
    'BARD': {'name': 'Bard', 'icon': '🟢', 'balance': 1500.50, 'decimals': 18},
    'USDT': {'name': 'Tether', 'icon': '🔵', 'balance': 2500.00, 'decimals': 18},
    'BTC': {'name': 'Bitcoin', 'icon': '🟠', 'balance': 0.05, 'decimals': 8},
    'ETH': {'name': 'Ethereum', 'icon': '🔷', 'balance': 1.25, 'decimals': 18},
    'BNB': {'name': 'BOCK De-Fi Coin', 'icon': '🟡', 'balance': 5.50, 'decimals': 18},
    'ADA': {'name': 'Cardano', 'icon': '🔵', 'balance': 1000.0, 'decimals': 18},
    'SOL': {'name': 'Solana', 'icon': '🟣', 'balance': 10.0, 'decimals': 9},
    'DOT': {'name': 'Polkadot', 'icon': '🔴', 'balance': 50.0, 'decimals': 10},
    'MATIC': {'name': 'Polygon', 'icon': '🟣', 'balance': 500.0, 'decimals': 18},
    'LINK': {'name': 'Chainlink', 'icon': '🔵', 'balance': 100.0, 'decimals': 18},
  };
  
  // Timer for debouncing
  Timer? _debounceTimer;
  
  // User wallet address
  String? _walletAddress;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 5, vsync: this);
    _pageController = PageController(initialPage: 0);
    
    _mainTabController.addListener(() {
      if (!_mainTabController.indexIsChanging) {
        _pageController.animateToPage(
          _mainTabController.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    _initializeWallet();
  }
  
  void _initializeWallet() {
    setState(() {
      _walletAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';
    });
  }
  
  // ============================================
  // REAL-TIME: Start automatic price updates
  // ============================================
  void _startRealTimeQuotes() {
    if (_fromAmountController.text.isEmpty || 
        _selectedFromCoin.isEmpty || 
        _selectedToCoin.isEmpty ||
        !_isRealTimeEnabled) {
      return;
    }
    
    // Stop any existing updates
    BlockchainService.stopRealTimeUpdates();
    
    try {
      // Convert amount to Wei
      double amount = double.parse(_fromAmountController.text);
      int decimals = _coins[_selectedFromCoin]!['decimals'];
      BigInt amountWei = BigInt.from((amount * pow(10, decimals)).toInt());
      
      setState(() {
        _isLoadingQuote = true;
      });
      
      // Start real-time updates
      BlockchainService.startRealTimeUpdates(
        tokenIn: _tokenAddresses[_selectedFromCoin]!,
        tokenOut: _tokenAddresses[_selectedToCoin]!,
        amountIn: amountWei.toString(),
        interval: Duration(seconds: 5), // Update every 5 seconds
        slippage: _slippage,
        onUpdate: (quote) {
          if (!mounted) return;
          
          setState(() {
            _currentQuote = quote;
            _lastUpdateTimestamp = quote['timestamp'];
            _isLoadingQuote = false;
            
            // Update output amount
            double amountOut = double.parse(quote['amount_out']) / 
                pow(10, _coins[_selectedToCoin]!['decimals']);
            _toAmountController.text = amountOut.toStringAsFixed(6);
          });
        },
      );
    } catch (e) {
      print('Error starting real-time updates: $e');
      setState(() {
        _isLoadingQuote = false;
      });
    }
  }
  
  // ============================================
  // Handle amount input changes
  // ============================================
  void _onAmountChanged(String value) {
    _debounceTimer?.cancel();
    
    if (value.isEmpty) {
      BlockchainService.stopRealTimeUpdates();
      setState(() {
        _currentQuote = null;
        _toAmountController.clear();
        _lastUpdateTimestamp = null;
      });
      return;
    }
    
    // Debounce: wait 500ms before starting real-time updates
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _startRealTimeQuotes();
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      if (_mainTabController.index != page) {
        _mainTabController.animateTo(page);
      }
    });
  }

  @override
  void dispose() {
    // IMPORTANT: Stop real-time updates and clean up
    BlockchainService.stopRealTimeUpdates();
    BlockchainService.dispose();
    
    _mainTabController.dispose();
    _pageController.dispose();
    _debounceTimer?.cancel();
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Main Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _mainTabController,
                isScrollable: true,
                labelColor: Color.fromARGB(255, 122, 79, 223),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color.fromARGB(255, 122, 79, 223),
                indicatorWeight: 3,
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                tabs: [
                  Tab(text: 'Convert'),
                  Tab(text: 'Spot'),
                  Tab(text: 'Margin'),
                  Tab(text: 'Buy/Sell'),
                  Tab(text: 'P2P'),
                ],
              ),
            ),
            
            // Content with PageView for smooth swiping
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildConvertTab(),
                  MobileSpotScreen(),
                  MobileSpotScreen(),
                  MobileBuyScreen(),
                  MobileP2pScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvertTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Connection Status
            if (_walletAddress != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, 
                         color: Color.fromARGB(255, 122, 79, 223), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${_walletAddress!.substring(0, 6)}...${_walletAddress!.substring(_walletAddress!.length - 4)}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 122, 79, 223),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('Connected', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            
            SizedBox(height: 16),
            
            // Swap Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Settings and Real-time indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Swap',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            // Real-time indicator
                            if (_lastUpdateTimestamp != null)
                              _buildUpdateIndicator(),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.history,
                                color: Color.fromARGB(255, 122, 79, 223),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: _showSlippageSettings,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.settings_outlined,
                                  color: Color.fromARGB(255, 122, 79, 223),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // From Section
                    _buildTokenInputCard(
                      label: 'From',
                      coin: _selectedFromCoin,
                      balance: _coins[_selectedFromCoin]!['balance'],
                      controller: _fromAmountController,
                      onCoinChange: (value) {
                        setState(() {
                          _selectedFromCoin = value!;
                          _onAmountChanged(_fromAmountController.text);
                        });
                      },
                      onAmountChange: _onAmountChanged,
                      readOnly: false,
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Swap Icon Button
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            String temp = _selectedFromCoin;
                            _selectedFromCoin = _selectedToCoin;
                            _selectedToCoin = temp;
                            _onAmountChanged(_fromAmountController.text);
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: _isLoadingQuote
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 122, 79, 223),
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Color.fromARGB(255, 122, 79, 223),
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // To Section
                    _buildTokenInputCard(
                      label: 'To',
                      coin: _selectedToCoin,
                      balance: _coins[_selectedToCoin]!['balance'],
                      controller: _toAmountController,
                      onCoinChange: (value) {
                        setState(() {
                          _selectedToCoin = value!;
                          _onAmountChanged(_fromAmountController.text);
                        });
                      },
                      onAmountChange: null,
                      readOnly: true,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Price Info from Blockchain
                    if (_currentQuote != null)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Price Impact',
                              '< ${(_currentQuote!['price_impact'] * 100).toStringAsFixed(2)}%',
                              null,
                              valueColor: _currentQuote!['price_impact'] < 0.01 
                                  ? Colors.green 
                                  : const Color.fromRGBO(255, 152, 0, 1),
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Minimum Received',
                              '${(double.parse(_currentQuote!['min_amount_out']) / pow(10, _coins[_selectedToCoin]!['decimals'])).toStringAsFixed(6)} $_selectedToCoin',
                              Icons.info_outline,
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Trading Fee (0.2%)',
                              '${(double.parse(_currentQuote!['fee']) / pow(10, _coins[_selectedFromCoin]!['decimals'])).toStringAsFixed(6)} $_selectedFromCoin',
                              null,
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Slippage Tolerance',
                              '${_slippage.toStringAsFixed(2)}%',
                              Icons.info_outline,
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Response Time',
                              '${_currentQuote!['response_time_ms']} ms',
                              null,
                            ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    
                    // Real-time Toggle
                    _buildRealTimeToggle(),
                    
                    SizedBox(height: 20),
                    
                    // Swap Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _fromAmountController.text.isEmpty || _isExecutingSwap
                            ? null
                            : () {
                                _showSwapConfirmation();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 122, 79, 223),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isExecutingSwap
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _walletAddress == null
                                    ? 'Connect Wallet'
                                    : _fromAmountController.text.isEmpty
                                        ? 'Enter an amount'
                                        : 'Swap',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Route Information
            if (_currentQuote != null && _currentQuote!['route'] != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Route',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _currentQuote!['source'] == 'blockchain'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentQuote!['source'] == 'blockchain' 
                                ? '🟢 Live'
                                : '🟠 Mock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _currentQuote!['source'] == 'blockchain'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedFromCoin,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedToCoin,
                            style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildTokenInputCard({
    required String label,
    required String coin,
    required double balance,
    required TextEditingController controller,
    required ValueChanged<String?>? onCoinChange,
    required ValueChanged<String>? onAmountChange,
    required bool readOnly,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Balance: ${balance.toStringAsFixed(4)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Token and Amount Input
          Row(
            children: [
              // Token Selector
              GestureDetector(
                onTap: () => _showTokenSelector(onCoinChange),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _coins[coin]!['icon'],
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(width: 8),
                      Text(
                        coin,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Amount Input
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  readOnly: readOnly,
                  onChanged: onAmountChange,
                ),
              ),
            ],
          ),
          
          // Max Button (only for 'From' field)
          if (!readOnly)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  controller.text = balance.toString();
                  if (onAmountChange != null) {
                    onAmountChange(balance.toString());
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size(0, 0),
                ),
                child: Text(
                  'MAX',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData? icon, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 4),
              Icon(icon, size: 16, color: Colors.grey.shade600),
            ],
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================
  // Real-time Toggle
  // ============================================
  Widget _buildRealTimeToggle() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: _isRealTimeEnabled ? Color.fromARGB(255, 122, 79, 223) : Colors.grey,
                size: 20,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real-time Updates',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _isRealTimeEnabled ? 'Updates every 5s' : 'Disabled',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: _isRealTimeEnabled,
            onChanged: (value) {
              setState(() {
                _isRealTimeEnabled = value;
              });
              if (value && _fromAmountController.text.isNotEmpty) {
                _startRealTimeQuotes();
              } else {
                BlockchainService.stopRealTimeUpdates();
              }
            },
            activeColor: Color.fromARGB(255, 122, 79, 223),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Update Indicator
  // ============================================
  Widget _buildUpdateIndicator() {
    if (_lastUpdateTimestamp == null) return SizedBox.shrink();
    
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(_lastUpdateTimestamp!);
    final timeDiff = DateTime.now().difference(lastUpdate);
    final isRecent = timeDiff.inSeconds < 10;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isRecent ? Colors.green.withOpacity(0.1) : const Color.fromRGBO(255, 152, 0, 1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isRecent ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            '${timeDiff.inSeconds}s',
            style: TextStyle(
              fontSize: 10,
              color: isRecent ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showTokenSelector(ValueChanged<String?>? onCoinChange) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select a token',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Search
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search name or paste address',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Token List
            Expanded(
              child: ListView.builder(
                itemCount: _coins.length,
                itemBuilder: (context, index) {
                  String coin = _coins.keys.elementAt(index);
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _coins[coin]!['icon'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    title: Text(
                      coin,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      _coins[coin]!['name'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      _coins[coin]!['balance'].toStringAsFixed(4),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      if (onCoinChange != null) {
                        onCoinChange(coin);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSlippageSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              Text(
                'Slippage Tolerance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  _buildSlippageButton('0.1', setModalState),
                  SizedBox(width: 8),
                  _buildSlippageButton('0.5', setModalState),
                  SizedBox(width: 8),
                  _buildSlippageButton('1.0', setModalState),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${_slippage}%',
                        ),
                        onSubmitted: (value) {
                          setModalState(() {
                            setState(() {
                              _slippage = double.tryParse(value) ?? _slippage;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlippageButton(String value, StateSetter setModalState) {
    double slippageValue = double.parse(value);
    bool isSelected = _slippage == slippageValue;
    
    return GestureDetector(
      onTap: () {
        setModalState(() {
          setState(() {
            _slippage = slippageValue;
          });
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223).withOpacity(0.1) : Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          '$value%',
          style: TextStyle(
            color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showSwapConfirmation() {
    if (_currentQuote == null || _walletAddress == null) return;
    
    double fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    double toAmount = double.tryParse(_toAmountController.text) ?? 0;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Swap',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 20),
            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From'),
                      Row(
                        children: [
                          Text(
                            '$fromAmount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _selectedFromCoin,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Icon(Icons.arrow_downward, color: Color.fromARGB(255, 122, 79, 223)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('To (estimated)'),
                      Row(
                        children: [
                          Text(
                            '${toAmount.toStringAsFixed(6)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _selectedToCoin,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price Impact'),
                      Text(
                        '< ${(_currentQuote!['price_impact'] * 100).toStringAsFixed(2)}%',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Minimum Received'),
                      Text(
                        '${(double.parse(_currentQuote!['min_amount_out']) / pow(10, _coins[_selectedToCoin]!['decimals'])).toStringAsFixed(6)} $_selectedToCoin',
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trading Fee'),
                      Text('${(double.parse(_currentQuote!['fee']) / pow(10, _coins[_selectedFromCoin]!['decimals'])).toStringAsFixed(6)} $_selectedFromCoin'),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Color.fromARGB(255, 122, 79, 223)),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _executeSwap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 122, 79, 223),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirm Swap',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _executeSwap() async {
    if (_currentQuote == null || _walletAddress == null) return;
    
    setState(() {
      _isExecutingSwap = true;
    });
    
    try {
      // Calculate deadline (20 minutes from now)
      int deadline = DateTime.now().add(Duration(minutes: 20)).millisecondsSinceEpoch ~/ 1000;
      
      // Execute swap through BlockchainService
      final result = await BlockchainService.executeSwap(
        tokenIn: _tokenAddresses[_selectedFromCoin]!,
        tokenOut: _tokenAddresses[_selectedToCoin]!,
        amountIn: _currentQuote!['amount_in'],
        minAmountOut: _currentQuote!['min_amount_out'],
        recipient: _walletAddress!,
        deadline: deadline,
      );
      
      setState(() {
        _isExecutingSwap = false;
      });
      
      // Show success message with transaction hash
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result['status'] == 'success' 
                    ? 'Swap successful!' 
                    : 'Transaction submitted!'),
                SizedBox(height: 4),
                Text(
                  'TX: ${result['transaction_hash'].substring(0, 10)}...',
                  style: TextStyle(fontSize: 12),
                ),
                if (result['note'] != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      result['note'],
                      style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Open block explorer
              },
            ),
          ),
        );
      }
      
      // Clear inputs
      _fromAmountController.clear();
      _toAmountController.clear();
      setState(() {
        _currentQuote = null;
      });
      
    } catch (e) {
      setState(() {
        _isExecutingSwap = false;
      });
      
      print('Error executing swap: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Swap failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'wallet_connect_service.dart';
import 'transaction_history_screen.dart';

class MobileTradeScreen extends StatefulWidget {
  final WalletConnectService? walletService;

  const MobileTradeScreen({Key? key, this.walletService}) : super(key: key);

  @override
  _MobileTradeScreenState createState() => _MobileTradeScreenState();
}

class _MobileTradeScreenState extends State<MobileTradeScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late PageController _pageController;
  
  // Wallet service
  WalletConnectService? _walletService;
  
  // Current selections
  int _currentPage = 0;
  
  // Form controllers
  TextEditingController _fromAmountController = TextEditingController();
  TextEditingController _toAmountController = TextEditingController();
  
  // Selected cryptocurrencies
  String _selectedFromCoin = 'ETH';
  String _selectedToCoin = 'USDT';
  
  // Slippage settings
  double _slippage = 0.5;
  
  // Loading states
  bool _isLoadingQuote = false;
  bool _isExecutingSwap = false;
  
  // Real-time features
  Timer? _quoteUpdateTimer;
  
  // Quote data
  Map<String, dynamic>? _currentQuote;
  
  // Token prices (mock data - in production, fetch from API)
  final Map<String, double> _tokenPrices = {
    'ETH': 2500.0,
    'USDT': 1.0,
    'BTC': 45000.0,
    'BNB': 300.0,
    'USDC': 1.0,
  };
  
  // Available coins with balances
  final Map<String, Map<String, dynamic>> _coins = {
    'ETH': {'name': 'Ethereum', 'icon': '⟠', 'balance': 0.0, 'decimals': 18},
    'USDT': {'name': 'Tether', 'icon': '₮', 'balance': 0.0, 'decimals': 6},
    'BTC': {'name': 'Bitcoin', 'icon': '₿', 'balance': 0.0, 'decimals': 8},
    'BNB': {'name': 'BNB', 'icon': '◆', 'balance': 0.0, 'decimals': 18},
    'USDC': {'name': 'USD Coin', 'icon': '◎', 'balance': 0.0, 'decimals': 6},
  };
  
  // Timer for debouncing
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _walletService = widget.walletService ?? WalletConnectService();
    _mainTabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0);
    
    _mainTabController.addListener(() {
      if (!_mainTabController.indexIsChanging) {
        _pageController.animateToPage(
          _mainTabController.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    _updateBalances();
  }
  
  // Update balances from wallet
  Future<void> _updateBalances() async {
    if (_walletService?.isConnected == true) {
      final balance = await _walletService!.getBalance();
      setState(() {
        _coins['ETH']!['balance'] = double.tryParse(balance) ?? 0.0;
        // In production, fetch balances for all tokens
      });
    }
  }
  
  // Calculate quote based on current prices
  void _calculateQuote() {
    if (_fromAmountController.text.isEmpty) {
      setState(() {
        _currentQuote = null;
        _toAmountController.clear();
      });
      return;
    }

    try {
      final fromAmount = double.parse(_fromAmountController.text);
      final fromPrice = _tokenPrices[_selectedFromCoin] ?? 1.0;
      final toPrice = _tokenPrices[_selectedToCoin] ?? 1.0;
      
      // Calculate output amount
      final valueInUsd = fromAmount * fromPrice;
      final toAmount = valueInUsd / toPrice;
      
      // Apply 0.3% trading fee
      final fee = toAmount * 0.003;
      final amountAfterFee = toAmount - fee;
      
      // Calculate minimum with slippage
      final minAmount = amountAfterFee * (1 - _slippage / 100);
      
      // Price impact (simplified)
      final priceImpact = (fromAmount * fromPrice) > 10000 ? 0.5 : 0.1;
      
      setState(() {
        _toAmountController.text = amountAfterFee.toStringAsFixed(6);
        _currentQuote = {
          'amount_out': amountAfterFee.toStringAsFixed(6),
          'min_amount_out': minAmount.toStringAsFixed(6),
          'fee': fee.toStringAsFixed(6),
          'price_impact': priceImpact,
          'rate': (toAmount / fromAmount).toStringAsFixed(6),
        };
      });
    } catch (e) {
      print('Error calculating quote: $e');
    }
  }
  
  void _onAmountChanged(String value) {
    _debounceTimer?.cancel();
    
    if (value.isEmpty) {
      setState(() {
        _currentQuote = null;
        _toAmountController.clear();
      });
      return;
    }
    
    // Debounce: wait 500ms before calculating
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _calculateQuote();
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      if (_mainTabController.index != page) {
        _mainTabController.animateTo(page);
      }
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _pageController.dispose();
    _debounceTimer?.cancel();
    _quoteUpdateTimer?.cancel();
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Main Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _mainTabController,
                isScrollable: false,
                labelColor: Color.fromARGB(255, 122, 79, 223),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color.fromARGB(255, 122, 79, 223),
                indicatorWeight: 3,
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'Convert'),
                  Tab(text: 'History'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildConvertTab(),
                  _buildHistoryTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvertTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Connection Status
            if (_walletService?.isConnected == true)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MetaMask Connected',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${_walletService!.walletAddress!.substring(0, 6)}...${_walletService!.walletAddress!.substring(_walletService!.walletAddress!.length - 4)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, size: 20),
                      onPressed: _updateBalances,
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: const Color.fromARGB(255, 122, 79, 223), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Connect MetaMask to swap tokens',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final address = await _walletService!.connectWallet(context);
                        if (address != null) {
                          await _updateBalances();
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 122, 79, 223),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: Text('Connect', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            
            SizedBox(height: 16),
            
            // Swap Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Swap',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: _showSlippageSettings,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.settings_outlined,
                              color: Color.fromARGB(255, 122, 79, 223),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // From Section
                    _buildTokenInputCard(
                      label: 'From',
                      coin: _selectedFromCoin,
                      balance: _coins[_selectedFromCoin]!['balance'],
                      controller: _fromAmountController,
                      onCoinChange: (value) {
                        setState(() {
                          _selectedFromCoin = value!;
                          _onAmountChanged(_fromAmountController.text);
                        });
                      },
                      onAmountChange: _onAmountChanged,
                      readOnly: false,
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Swap Icon Button
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            String temp = _selectedFromCoin;
                            _selectedFromCoin = _selectedToCoin;
                            _selectedToCoin = temp;
                            _onAmountChanged(_fromAmountController.text);
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: Color.fromARGB(255, 122, 79, 223),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // To Section
                    _buildTokenInputCard(
                      label: 'To',
                      coin: _selectedToCoin,
                      balance: _coins[_selectedToCoin]!['balance'],
                      controller: _toAmountController,
                      onCoinChange: (value) {
                        setState(() {
                          _selectedToCoin = value!;
                          _onAmountChanged(_fromAmountController.text);
                        });
                      },
                      onAmountChange: null,
                      readOnly: true,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Price Info
                    if (_currentQuote != null)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Rate',
                              '1 $_selectedFromCoin ≈ ${_currentQuote!['rate']} $_selectedToCoin',
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Price Impact',
                              '${(_currentQuote!['price_impact']).toStringAsFixed(2)}%',
                              valueColor: _currentQuote!['price_impact'] < 1 
                                  ? Colors.green 
                                  : const Color.fromARGB(255, 122, 79, 223),
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Minimum Received',
                              '${_currentQuote!['min_amount_out']} $_selectedToCoin',
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Trading Fee (0.3%)',
                              '${_currentQuote!['fee']} $_selectedToCoin',
                            ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    
                    // Swap Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _walletService?.isConnected != true || 
                                  _fromAmountController.text.isEmpty || 
                                  _isExecutingSwap
                            ? null
                            : _showSwapConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 122, 79, 223),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isExecutingSwap
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _walletService?.isConnected != true
                                    ? 'Connect Wallet'
                                    : _fromAmountController.text.isEmpty
                                        ? 'Enter an amount'
                                        : 'Swap',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_walletService?.isConnected != true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Connect wallet to view history',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return TransactionHistoryScreen(walletService: _walletService!);
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildSettingCard(
            'Slippage Tolerance',
            '${_slippage.toStringAsFixed(2)}%',
            Icons.tune,
            () => _showSlippageSettings(),
          ),
          _buildSettingCard(
            'Network',
            'Sepolia Testnet',
            Icons.network_check,
            null,
          ),
          if (_walletService?.isConnected == true)
            _buildSettingCard(
              'Disconnect Wallet',
              '',
              Icons.logout,
              () async {
                await _walletService!.disconnect();
                setState(() {});
              },
              isDestructive: true,
            ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(
    String title,
    String value,
    IconData icon,
    VoidCallback? onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : Color.fromARGB(255, 122, 79, 223)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: value.isNotEmpty ? Text(value) : null,
        trailing: onTap != null ? Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildTokenInputCard({
    required String label,
    required String coin,
    required double balance,
    required TextEditingController controller,
    required ValueChanged<String?>? onCoinChange,
    required ValueChanged<String>? onAmountChange,
    required bool readOnly,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Balance: ${balance.toStringAsFixed(4)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          Row(
            children: [
              GestureDetector(
                onTap: () => _showTokenSelector(onCoinChange),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _coins[coin]!['icon'],
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(width: 8),
                      Text(
                        coin,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  readOnly: readOnly,
                  onChanged: onAmountChange,
                ),
              ),
            ],
          ),
          
          if (!readOnly)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  controller.text = balance.toString();
                  if (onAmountChange != null) {
                    onAmountChange(balance.toString());
                  }
                },
                child: Text(
                  'MAX',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showTokenSelector(ValueChanged<String?>? onCoinChange) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select a token',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _coins.length,
                itemBuilder: (context, index) {
                  String coin = _coins.keys.elementAt(index);
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(_coins[coin]!['icon'], style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    title: Text(coin, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(_coins[coin]!['name']),
                    trailing: Text(
                      _coins[coin]!['balance'].toStringAsFixed(4),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      if (onCoinChange != null) {
                        onCoinChange(coin);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSlippageSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Slippage Tolerance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  _buildSlippageButton('0.1', setModalState),
                  SizedBox(width: 8),
                  _buildSlippageButton('0.5', setModalState),
                  SizedBox(width: 8),
                  _buildSlippageButton('1.0', setModalState),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlippageButton(String value, StateSetter setModalState) {
    double slippageValue = double.parse(value);
    bool isSelected = _slippage == slippageValue;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setModalState(() {
            setState(() {
              _slippage = slippageValue;
              _onAmountChanged(_fromAmountController.text);
            });
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Color.fromARGB(255, 122, 79, 223).withOpacity(0.1) : Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            '$value%',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showSwapConfirmation() {
    if (_currentQuote == null) return;
    
    double fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Confirm Swap', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From'),
                      Text('$fromAmount $_selectedFromCoin', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Icon(Icons.arrow_downward, color: Color.fromARGB(255, 122, 79, 223)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('To (estimated)'),
                      Text('${_currentQuote!['amount_out']} $_selectedToCoin', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price Impact'),
                      Text('${_currentQuote!['price_impact'].toStringAsFixed(2)}%', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Minimum Received'),
                      Text('${_currentQuote!['min_amount_out']} $_selectedToCoin'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trading Fee'),
                      Text('${_currentQuote!['fee']} $_selectedToCoin'),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Color.fromARGB(255, 122, 79, 223)),
                    ),
                    child: Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 122, 79, 223))),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _executeSwap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 122, 79, 223),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Confirm Swap', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _executeSwap() async {
    if (_currentQuote == null || _walletService?.isConnected != true) return;
    
    setState(() {
      _isExecutingSwap = true;
    });
    
    try {
      final fromAmount = _fromAmountController.text;
      final toAddress = _walletService!.walletAddress!;
      
      // In a real implementation, you would:
      // 1. Approve token spending (if not ETH)
      // 2. Call the DEX router contract to execute swap
      // 3. Wait for transaction confirmation
      
      // For now, we'll simulate the swap by opening MetaMask
      // This creates a transaction that user can approve in MetaMask
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Processing Swap'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please approve the transaction in MetaMask'),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'MetaMask will open. Approve the transaction to complete the swap.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      
      // Simulate opening MetaMask with transaction
      // In production, you'd use a DEX router contract
      await Future.delayed(Duration(seconds: 2));
      
      // For demonstration, we'll create a transaction
      // In reality, this would be a contract interaction
      final txHash = await _walletService!.sendTransaction(
        toAddress: toAddress, // In real swap, this would be the DEX router
        amount: '0.001', // Gas fee amount
      );
      
      Navigator.pop(context); // Close processing dialog
      
      if (txHash != null) {
        setState(() {
          _isExecutingSwap = false;
        });
        
        // Show success
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Swap Submitted!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your swap has been submitted to the network.'),
                SizedBox(height: 12),
                Text('Transaction Hash:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    txHash,
                    style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'It may take a few moments for the transaction to be confirmed on the blockchain.',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Refresh balances
                  _updateBalances();
                  _walletService!.refreshData();
                },
                child: Text('View in History'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Clear form
                  _fromAmountController.clear();
                  _toAmountController.clear();
                  setState(() {
                    _currentQuote = null;
                  });
                  // Refresh balances
                  _updateBalances();
                  _walletService!.refreshData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 122, 79, 223),
                ),
                child: Text('Done'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Transaction failed');
      }
      
    } catch (e) {
      Navigator.pop(context); // Close processing dialog
      
      setState(() {
        _isExecutingSwap = false;
      });
      
      print('Error executing swap: $e');
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Swap Failed'),
            ],
          ),
          content: Text('The swap transaction failed. Please try again.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}*/

import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_buy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_p2p_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spot_screen.dart';
import 'package:bockchain/services/blockchain_service.dart'; // ← Using BlockchainService
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class MobileTradeScreen extends StatefulWidget {
  @override
  _MobileTradeScreenState createState() => _MobileTradeScreenState();
}

class _MobileTradeScreenState extends State<MobileTradeScreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late PageController _pageController;
  
  // Current selections
  int _currentPage = 0;
  
  // Form controllers
  TextEditingController _fromAmountController = TextEditingController();
  TextEditingController _toAmountController = TextEditingController();
  
  // Selected cryptocurrencies
  String _selectedFromCoin = 'BARD';
  String _selectedToCoin = 'USDT';
  
  // Slippage settings
  double _slippage = 0.5;
  
  // Loading states
  bool _isLoadingQuote = false;
  bool _isExecutingSwap = false;
  
  // Real-time features
  bool _isRealTimeEnabled = true;
  int? _lastUpdateTimestamp;
  
  // Quote data from blockchain
  Map<String, dynamic>? _currentQuote;
  
  // Contract addresses (BSC Mainnet)
  final Map<String, String> _tokenAddresses = {
    'BARD': '0x1234567890123456789012345678901234567890', // Replace with actual
    'USDT': '0x55d398326f99059fF775485246999027B3197955', // Real USDT on BSC
    'BTC': '0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c',
    'ETH': '0x2170Ed0880ac9A755fd29B2688956BD959F933F8',
    'BNB': '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c',
    'ADA': '0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47',
    'SOL': '0x570A5D26f7765Ecb712C0924E4De545B89fD43dF',
    'DOT': '0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402',
    'MATIC': '0xCC42724C6683B7E57334c4E856f4c9965ED682bD',
    'LINK': '0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD',
  };
  
  // Available coins with balances
  final Map<String, Map<String, dynamic>> _coins = {
    'BARD': {'name': 'Bard', 'icon': '🟢', 'balance': 1500.50, 'decimals': 18},
    'USDT': {'name': 'Tether', 'icon': '🔵', 'balance': 2500.00, 'decimals': 18},
    'BTC': {'name': 'Bitcoin', 'icon': '🟠', 'balance': 0.05, 'decimals': 8},
    'ETH': {'name': 'Ethereum', 'icon': '🔷', 'balance': 1.25, 'decimals': 18},
    'BNB': {'name': 'BOCK De-Fi Coin', 'icon': '🟡', 'balance': 5.50, 'decimals': 18},
    'ADA': {'name': 'Cardano', 'icon': '🔵', 'balance': 1000.0, 'decimals': 18},
    'SOL': {'name': 'Solana', 'icon': '🟣', 'balance': 10.0, 'decimals': 9},
    'DOT': {'name': 'Polkadot', 'icon': '🔴', 'balance': 50.0, 'decimals': 10},
    'MATIC': {'name': 'Polygon', 'icon': '🟣', 'balance': 500.0, 'decimals': 18},
    'LINK': {'name': 'Chainlink', 'icon': '🔵', 'balance': 100.0, 'decimals': 18},
  };
  
  // Timer for debouncing
  Timer? _debounceTimer;
  
  // User wallet address
  String? _walletAddress;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 5, vsync: this);
    _pageController = PageController(initialPage: 0);
    
    _mainTabController.addListener(() {
      if (!_mainTabController.indexIsChanging) {
        _pageController.animateToPage(
          _mainTabController.index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    _initializeWallet();
  }
  
  void _initializeWallet() {
    setState(() {
      _walletAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';
    });
  }
  
  // ============================================
  // REAL-TIME: Start automatic price updates
  // ============================================
  void _startRealTimeQuotes() {
    if (_fromAmountController.text.isEmpty || 
        _selectedFromCoin.isEmpty || 
        _selectedToCoin.isEmpty ||
        !_isRealTimeEnabled) {
      return;
    }
    
    // Stop any existing updates
    BlockchainService.stopRealTimeUpdates();
    
    try {
      // Convert amount to Wei
      double amount = double.parse(_fromAmountController.text);
      int decimals = _coins[_selectedFromCoin]!['decimals'];
      BigInt amountWei = BigInt.from((amount * pow(10, decimals)).toInt());
      
      setState(() {
        _isLoadingQuote = true;
      });
      
      // Start real-time updates
      BlockchainService.startRealTimeUpdates(
        tokenIn: _tokenAddresses[_selectedFromCoin]!,
        tokenOut: _tokenAddresses[_selectedToCoin]!,
        amountIn: amountWei.toString(),
        interval: Duration(seconds: 5), // Update every 5 seconds
        slippage: _slippage,
        onUpdate: (quote) {
          if (!mounted) return;
          
          setState(() {
            _currentQuote = quote;
            _lastUpdateTimestamp = quote['timestamp'];
            _isLoadingQuote = false;
            
            // Update output amount
            double amountOut = double.parse(quote['amount_out']) / 
                pow(10, _coins[_selectedToCoin]!['decimals']);
            _toAmountController.text = amountOut.toStringAsFixed(6);
          });
        },
      );
    } catch (e) {
      print('Error starting real-time updates: $e');
      setState(() {
        _isLoadingQuote = false;
      });
    }
  }
  
  // ============================================
  // Handle amount input changes
  // ============================================
  void _onAmountChanged(String value) {
    _debounceTimer?.cancel();
    
    if (value.isEmpty) {
      BlockchainService.stopRealTimeUpdates();
      setState(() {
        _currentQuote = null;
        _toAmountController.clear();
        _lastUpdateTimestamp = null;
      });
      return;
    }
    
    // Debounce: wait 500ms before starting real-time updates
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _startRealTimeQuotes();
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      if (_mainTabController.index != page) {
        _mainTabController.animateTo(page);
      }
    });
  }

  @override
  void dispose() {
    // IMPORTANT: Stop real-time updates and clean up
    BlockchainService.stopRealTimeUpdates();
    BlockchainService.dispose();
    
    _mainTabController.dispose();
    _pageController.dispose();
    _debounceTimer?.cancel();
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Main Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _mainTabController,
                isScrollable: true,
                labelColor: Color.fromARGB(255, 122, 79, 223),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color.fromARGB(255, 122, 79, 223),
                indicatorWeight: 3,
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                tabs: [
                  Tab(text: 'Convert'),
                  Tab(text: 'Spot'),
                  Tab(text: 'Margin'),
                  Tab(text: 'Buy/Sell'),
                  Tab(text: 'P2P'),
                ],
              ),
            ),
            
            // Content with PageView for smooth swiping
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildConvertTab(),
                  MobileSpotScreen(),
                  MobileSpotScreen(),
                  MobileBuyScreen(),
                  MobileP2pScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvertTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Connection Status
            if (_walletAddress != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, 
                         color: Color.fromARGB(255, 122, 79, 223), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${_walletAddress!.substring(0, 6)}...${_walletAddress!.substring(_walletAddress!.length - 4)}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 122, 79, 223),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('Connected', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            
            SizedBox(height: 16),
            
            // Swap Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Settings and Real-time indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Swap',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            // Real-time indicator
                            if (_lastUpdateTimestamp != null)
                              _buildUpdateIndicator(),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.history,
                                color: Color.fromARGB(255, 122, 79, 223),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: _showSlippageSettings,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.settings_outlined,
                                  color: Color.fromARGB(255, 122, 79, 223),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20),
                    
                    // From Section
                    _buildTokenInputCard(
                      label: 'From',
                      coin: _selectedFromCoin,
                      balance: _coins[_selectedFromCoin]!['balance'],
                      controller: _fromAmountController,
                      onCoinChange: (value) {
                        setState(() {
                          _selectedFromCoin = value!;
                          _onAmountChanged(_fromAmountController.text);
                        });
                      },
                      onAmountChange: _onAmountChanged,
                      readOnly: false,
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Swap Icon Button
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            String temp = _selectedFromCoin;
                            _selectedFromCoin = _selectedToCoin;
                            _selectedToCoin = temp;
                            _onAmountChanged(_fromAmountController.text);
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: _isLoadingQuote
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 122, 79, 223),
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Color.fromARGB(255, 122, 79, 223),
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // To Section
                    _buildTokenInputCard(
                      label: 'To',
                      coin: _selectedToCoin,
                      balance: _coins[_selectedToCoin]!['balance'],
                      controller: _toAmountController,
                      onCoinChange: (value) {
                        setState(() {
                          _selectedToCoin = value!;
                          _onAmountChanged(_fromAmountController.text);
                        });
                      },
                      onAmountChange: null,
                      readOnly: true,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Price Info from Blockchain
                    if (_currentQuote != null)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Price Impact',
                              '< ${(_currentQuote!['price_impact'] * 100).toStringAsFixed(2)}%',
                              null,
                              valueColor: _currentQuote!['price_impact'] < 0.01 
                                  ? Colors.green 
                                  : const Color.fromRGBO(255, 152, 0, 1),
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Minimum Received',
                              '${(double.parse(_currentQuote!['min_amount_out']) / pow(10, _coins[_selectedToCoin]!['decimals'])).toStringAsFixed(6)} $_selectedToCoin',
                              Icons.info_outline,
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Trading Fee (0.2%)',
                              '${(double.parse(_currentQuote!['fee']) / pow(10, _coins[_selectedFromCoin]!['decimals'])).toStringAsFixed(6)} $_selectedFromCoin',
                              null,
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Slippage Tolerance',
                              '${_slippage.toStringAsFixed(2)}%',
                              Icons.info_outline,
                            ),
                            SizedBox(height: 12),
                            _buildInfoRow(
                              'Response Time',
                              '${_currentQuote!['response_time_ms']} ms',
                              null,
                            ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    
                    // Real-time Toggle
                    _buildRealTimeToggle(),
                    
                    SizedBox(height: 20),
                    
                    // Swap Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _fromAmountController.text.isEmpty || _isExecutingSwap
                            ? null
                            : () {
                                _showSwapConfirmation();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 122, 79, 223),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isExecutingSwap
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _walletAddress == null
                                    ? 'Connect Wallet'
                                    : _fromAmountController.text.isEmpty
                                        ? 'Enter an amount'
                                        : 'Swap',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Route Information
            if (_currentQuote != null && _currentQuote!['route'] != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Route',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _currentQuote!['source'] == 'blockchain'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _currentQuote!['source'] == 'blockchain' 
                                ? '🟢 Live'
                                : '🟠 Mock',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _currentQuote!['source'] == 'blockchain'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedFromCoin,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedToCoin,
                            style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildTokenInputCard({
    required String label,
    required String coin,
    required double balance,
    required TextEditingController controller,
    required ValueChanged<String?>? onCoinChange,
    required ValueChanged<String>? onAmountChange,
    required bool readOnly,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label and Balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Balance: ${balance.toStringAsFixed(4)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Token and Amount Input
          Row(
            children: [
              // Token Selector
              GestureDetector(
                onTap: () => _showTokenSelector(onCoinChange),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _coins[coin]!['icon'],
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(width: 8),
                      Text(
                        coin,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Amount Input
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  readOnly: readOnly,
                  onChanged: onAmountChange,
                ),
              ),
            ],
          ),
          
          // Max Button (only for 'From' field)
          if (!readOnly)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  controller.text = balance.toString();
                  if (onAmountChange != null) {
                    onAmountChange(balance.toString());
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size(0, 0),
                ),
                child: Text(
                  'MAX',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData? icon, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 4),
              Icon(icon, size: 16, color: Colors.grey.shade600),
            ],
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================
  // Real-time Toggle
  // ============================================
  Widget _buildRealTimeToggle() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: _isRealTimeEnabled ? Color.fromARGB(255, 122, 79, 223) : Colors.grey,
                size: 20,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real-time Updates',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _isRealTimeEnabled ? 'Updates every 5s' : 'Disabled',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: _isRealTimeEnabled,
            onChanged: (value) {
              setState(() {
                _isRealTimeEnabled = value;
              });
              if (value && _fromAmountController.text.isNotEmpty) {
                _startRealTimeQuotes();
              } else {
                BlockchainService.stopRealTimeUpdates();
              }
            },
            activeColor: Color.fromARGB(255, 122, 79, 223),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Update Indicator
  // ============================================
  Widget _buildUpdateIndicator() {
    if (_lastUpdateTimestamp == null) return SizedBox.shrink();
    
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(_lastUpdateTimestamp!);
    final timeDiff = DateTime.now().difference(lastUpdate);
    final isRecent = timeDiff.inSeconds < 10;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isRecent ? Colors.green.withOpacity(0.1) : const Color.fromRGBO(255, 152, 0, 1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isRecent ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            '${timeDiff.inSeconds}s',
            style: TextStyle(
              fontSize: 10,
              color: isRecent ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showTokenSelector(ValueChanged<String?>? onCoinChange) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select a token',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Search
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search name or paste address',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Token List
            Expanded(
              child: ListView.builder(
                itemCount: _coins.length,
                itemBuilder: (context, index) {
                  String coin = _coins.keys.elementAt(index);
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _coins[coin]!['icon'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    title: Text(
                      coin,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      _coins[coin]!['name'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      _coins[coin]!['balance'].toStringAsFixed(4),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      if (onCoinChange != null) {
                        onCoinChange(coin);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSlippageSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              Text(
                'Slippage Tolerance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  _buildSlippageButton('0.1', setModalState),
                  SizedBox(width: 8),
                  _buildSlippageButton('0.5', setModalState),
                  SizedBox(width: 8),
                  _buildSlippageButton('1.0', setModalState),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${_slippage}%',
                        ),
                        onSubmitted: (value) {
                          setModalState(() {
                            setState(() {
                              _slippage = double.tryParse(value) ?? _slippage;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlippageButton(String value, StateSetter setModalState) {
    double slippageValue = double.parse(value);
    bool isSelected = _slippage == slippageValue;
    
    return GestureDetector(
      onTap: () {
        setModalState(() {
          setState(() {
            _slippage = slippageValue;
          });
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 122, 79, 223).withOpacity(0.1) : Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          '$value%',
          style: TextStyle(
            color: isSelected ? Color.fromARGB(255, 122, 79, 223) : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showSwapConfirmation() {
    if (_currentQuote == null || _walletAddress == null) return;
    
    double fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    double toAmount = double.tryParse(_toAmountController.text) ?? 0;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Swap',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 20),
            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From'),
                      Row(
                        children: [
                          Text(
                            '$fromAmount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _selectedFromCoin,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Icon(Icons.arrow_downward, color: Color.fromARGB(255, 122, 79, 223)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('To (estimated)'),
                      Row(
                        children: [
                          Text(
                            '${toAmount.toStringAsFixed(6)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _selectedToCoin,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price Impact'),
                      Text(
                        '< ${(_currentQuote!['price_impact'] * 100).toStringAsFixed(2)}%',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Minimum Received'),
                      Text(
                        '${(double.parse(_currentQuote!['min_amount_out']) / pow(10, _coins[_selectedToCoin]!['decimals'])).toStringAsFixed(6)} $_selectedToCoin',
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trading Fee'),
                      Text('${(double.parse(_currentQuote!['fee']) / pow(10, _coins[_selectedFromCoin]!['decimals'])).toStringAsFixed(6)} $_selectedFromCoin'),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Color.fromARGB(255, 122, 79, 223)),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color.fromARGB(255, 122, 79, 223)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _executeSwap();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 122, 79, 223),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Confirm Swap',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _executeSwap() async {
    if (_currentQuote == null || _walletAddress == null) return;
    
    setState(() {
      _isExecutingSwap = true;
    });
    
    try {
      // Calculate deadline (20 minutes from now)
      int deadline = DateTime.now().add(Duration(minutes: 20)).millisecondsSinceEpoch ~/ 1000;
      
      // Execute swap through BlockchainService
      final result = await BlockchainService.executeSwap(
        tokenIn: _tokenAddresses[_selectedFromCoin]!,
        tokenOut: _tokenAddresses[_selectedToCoin]!,
        amountIn: _currentQuote!['amount_in'],
        minAmountOut: _currentQuote!['min_amount_out'],
        recipient: _walletAddress!,
        deadline: deadline,
      );
      
      setState(() {
        _isExecutingSwap = false;
      });
      
      // Show success message with transaction hash
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result['status'] == 'success' 
                    ? 'Swap successful!' 
                    : 'Transaction submitted!'),
                SizedBox(height: 4),
                Text(
                  'TX: ${result['transaction_hash'].substring(0, 10)}...',
                  style: TextStyle(fontSize: 12),
                ),
                if (result['note'] != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      result['note'],
                      style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Open block explorer
              },
            ),
          ),
        );
      }
      
      // Clear inputs
      _fromAmountController.clear();
      _toAmountController.clear();
      setState(() {
        _currentQuote = null;
      });
      
    } catch (e) {
      setState(() {
        _isExecutingSwap = false;
      });
      
      print('Error executing swap: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Swap failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}