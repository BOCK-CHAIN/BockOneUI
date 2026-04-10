import 'package:flutter/material.dart';

class MobileGrowScreen extends StatelessWidget {
  const MobileGrowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Bar
            /*Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildTab('Favorites', false),
                  _buildTab('Market', false),
                  _buildTab('Alpha', false),
                  _buildTab('Grow', true),
                  _buildTab('Square', false),
                  _buildTab('Data', false),
                ],
              ),
            ),*/
            
            SizedBox(height: 20),
            
            // ETH Earning Banner
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: 'Earn ', style: TextStyle(color: Colors.black)),
                            TextSpan(text: '2.4% APR', style: TextStyle(color: Colors.teal)),
                            TextSpan(text: ' on ETH', style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'View More',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF627EEA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.diamond, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Start Earning Today Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Earning Today',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Earning Cards
            Container(
              height: 120,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text('\$', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('USDC', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Spacer(),
                          Text(
                            '7.49%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Max APR',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8, right: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Color(0xFF627EEA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.diamond, color: Colors.white, size: 12),
                              ),
                              SizedBox(width: 8),
                              Text('ETH', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Spacer(),
                          Text(
                            '124.2%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Max APR',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // SOL Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.blue, Colors.green],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('SOL', style: TextStyle(fontWeight: FontWeight.w600)),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '119.78%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Max APR',
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
            
            SizedBox(height: 30),
            
            // Top Traders Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Traders to Copy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Traders List
            _buildTraderItem('SniperOne', 'Spot', '+54.13%', '7D ROI', Colors.red[100]!),
            _buildTraderItem('Moon_Hunter', 'Spot', '+7.57%', '7D ROI', Colors.brown[100]!),
            _buildTraderItem('Satoshi Sensei', 'Spot', '+7.35%', '7D ROI', Colors.brown[200]!),
            
            SizedBox(height: 100), // Bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      margin: EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? Colors.black : Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          if (isActive)
            Container(
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTraderItem(String name, String type, String roi, String period, Color avatarColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: name == 'SniperOne' 
                ? Icon(Icons.gps_fixed, color: Colors.red[800], size: 20)
                : name == 'Moon_Hunter'
                    ? Icon(Icons.nights_stay, color: Colors.brown[800], size: 20)
                    : Icon(Icons.person, color: Colors.brown[800], size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                roi,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                period,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}