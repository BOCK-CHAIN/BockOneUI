import 'package:flutter/material.dart';

class MobileOtcScreen extends StatefulWidget {
  @override
  _MobileOtcScreenState createState() => _MobileOtcScreenState();
}

class _MobileOtcScreenState extends State<MobileOtcScreen>
    with TickerProviderStateMixin {
  int _selectedBottomIndex = 0;
  late TabController _tradeTabController;

  @override
  void initState() {
    super.initState();
    _tradeTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tradeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'OTC',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedBottomIndex) {
      case 0:
        return _buildTradeTab();
      case 1:
        return _buildOrdersTab();
      case 2:
        return _buildChatTab();
      default:
        return _buildTradeTab();
    }
  }

  Widget _buildTradeTab() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tradeTabController,
            indicatorColor: const Color.fromARGB(255, 122, 79, 223),
            indicatorWeight: 3,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Spot'),
              Tab(text: 'Algo Orders'),
              Tab(text: 'Options'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tradeTabController,
            children: [
              _buildSpotContent(),
              _buildAlgoOrdersContent(),
              _buildOptionsContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpotContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exchange rate
            Text(
              '1 USDT = 0.00000894 BTC',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            
            // From section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From', style: TextStyle(color: Colors.grey)),
                Text(
                  'Available: 0.00 USDT',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.attach_money, color: Colors.white, size: 20),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'USDT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '>200,000',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text('MAX', style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223))),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Swap icon
            Center(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.swap_vert, size: 24),
              ),
            ),
            
            SizedBox(height: 20),
            
            // To section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('To', style: TextStyle(color: Colors.grey)),
                Text(
                  'Available: 0.00 BTC',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                    child: Text('₿', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'BTC',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                  Spacer(),
                  Text(
                    '>2',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40),
            
            // Request Quote button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Request for Quote',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlgoOrdersContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'BTCUSDT',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '111,946.28',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '-0.55%',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
                Icon(Icons.bar_chart, size: 24),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Buy/Sell buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Buy BTC',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sell BTC',
                      style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Amount section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount (BTC)', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '0.00',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        'BTC',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text('≈ 0.00 USDT', style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 8),
                      Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // TWAP/POV toggle
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'TWAP',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'POV',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Spacer(),
                Icon(Icons.info_outline, color: Colors.grey),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Duration section
            Row(
              children: [
                Text('Suggested Duration:', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 8),
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
              ],
            ),
            SizedBox(height: 12),
            
            Row(
              children: [
                _buildDurationChip('30mins', false),
                SizedBox(width: 8),
                _buildDurationChip('1hour', false),
                SizedBox(width: 8),
                _buildDurationChip('6hour', false),
                SizedBox(width: 8),
                _buildDurationChip('12hour', false),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Custom duration
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '1-168',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text('Hours'),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '1-59',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text('Mins'),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.grey),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Optional parameters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Optional parameters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            
            SizedBox(height: 40),
            
            // Place Order button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Place Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Chart section
            Text(
              'Chart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Chart Placeholder',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Symbol section
            Text(
              'Symbol',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'BTCUSDT',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Strategies section
            Row(
              children: [
                Text(
                  'Strategies',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
              ],
            ),
            SizedBox(height: 16),
            
            // Strategy grid
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildStrategyCard('Single Call', Colors.green, true),
                _buildStrategyCard('Single Put', Colors.red, false),
                _buildStrategyCard('Call Spread', Colors.green, false),
                _buildStrategyCard('Put Spread', Colors.red, false),
                _buildStrategyCard('Calendar Spread', Colors.blue, false),
                _buildStrategyCard('Diagonal Spread', Colors.green, false),
                _buildStrategyCard('Straddle', Colors.purple, false),
                _buildStrategyCard('Strangle', Colors.purple, false),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Price display
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                    child: Text('₿', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'BTCUSDT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '111,899.78',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Icon(Icons.arrow_downward, color: Colors.red, size: 16),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Type section
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text('Type', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Call', style: TextStyle(fontSize: 16)),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Expiry section
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text('Expiry', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('2025-09-26', style: TextStyle(fontSize: 16)),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Strike section
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text('Strike', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('104000', style: TextStyle(fontSize: 16)),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Sample orders
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'BTC/USDT',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: index % 2 == 0 ? Colors.green : const Color.fromARGB(255, 122, 79, 223),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                index % 2 == 0 ? 'Completed' : 'Pending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Type: ${index % 2 == 0 ? 'Buy' : 'Sell'}'),
                            Text('Amount: ${(index + 1) * 0.1} BTC'),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Price: \$${111000 + (index * 100)}'),
                            Text('Date: 2025-09-${25 - index}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: 10, // Sample messages
            itemBuilder: (context, index) {
              bool isMe = index % 2 == 0;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Text(
                    isMe 
                      ? 'Hello, I want to place a BTC order'
                      : 'Sure! What type of order would you like to place?',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStrategyCard(String title, Color color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomIndex,
      onTap: (index) {
        setState(() {
          _selectedBottomIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Trade',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
      ],
    );
  }
}