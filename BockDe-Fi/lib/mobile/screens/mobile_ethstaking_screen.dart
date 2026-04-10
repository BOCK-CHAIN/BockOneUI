import 'package:flutter/material.dart';

class MobileEthStakingScreen extends StatefulWidget {
  @override
  _MobileEthStakingScreenState createState() => _MobileEthStakingScreenState();
}

class _MobileEthStakingScreenState extends State<MobileEthStakingScreen> {
  bool _showStakeScreen = false;
  final TextEditingController _stakeAmountController = TextEditingController();
  double _availableETH = 0.0;

  void _navigateToStakeScreen() {
    setState(() {
      _showStakeScreen = true;
    });
  }

  void _navigateBack() {
    setState(() {
      _showStakeScreen = false;
    });
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
          onPressed: _showStakeScreen ? _navigateBack : () => Navigator.pop(context),
        ),
        title: Text(
          'ETH Staking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.link, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _showStakeScreen ? _buildStakeScreen() : _buildMainScreen(),
    );
  }

  Widget _buildMainScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Earn daily yield & Utilize your staking',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'What is WBETH',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 122, 79, 223),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.currency_bitcoin,
                  color: Colors.blue.shade700,
                  size: 30,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Stats Container
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Reference APR',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.trending_up, size: 16, color: Colors.grey.shade600),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2.36%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Conversion Ratio',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '1 WBETH ≈ 1.07970116 ETH',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.sync_alt, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'Redeem',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _navigateToStakeScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Subscribe',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 32),
          
          // Steps Section
          Text(
            'Start earning in 3 steps',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          SizedBox(height: 20),
          
          _buildStep(
            '1',
            'Stake ETH',
            'Stake ETH, receive WBETH based on the daily conversion ratio.',
          ),
          
          _buildStep(
            '2',
            'Earn Daily Rewards',
            'Earn yield by holding WBETH or use your WBETH for a variety of use cases. As ETH staking rewards accumulate, 1 WBETH gradually exceeds 1 ETH in value - currently at:\n\n1 WBETH ≈ 1.07970116 ETH',
          ),
          
          _buildStep(
            '3',
            'Flexibility to Redeem ETH',
            'Redeem WBETH for ETH.',
            isLast: true,
          ),
          
          SizedBox(height: 32),
          
          // BOCK De-Fi Section
          Text(
            'BOCK De-Fi covers it all',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          SizedBox(height: 16),
          
          _buildFeature(Icons.trending_up, 'Easy to get started'),
          _buildFeature(Icons.security, 'Secure and transparent'),
          _buildFeature(Icons.account_balance_wallet, 'Utilize staked ETH'),
        ],
      ),
    );
  }

  Widget _buildStakeScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with ETH icon
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.currency_bitcoin,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Stake ETH',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Stake Amount Section
          Text(
            'Stake Amount',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          SizedBox(height: 12),
          
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Minimum 0.0001',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'ETH',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'MAX',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Available Amount
          Row(
            children: [
              Text(
                'Avail (2 sources) 0 ETH',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 12, color: const Color.fromARGB(255, 122, 79, 223)),
                    SizedBox(width: 2),
                    Text(
                      'Top up',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 32),
          
          // Conversion Details
          _buildDetailRow(
            'Receive',
            '0 WBETH',
            icon: Icons.currency_bitcoin,
            iconColor: const Color.fromARGB(255, 122, 79, 223),
          ),
          
          _buildDetailRow(
            'Conversion Ratio',
            '1 ETH ≈ 0.92618219 WBETH',
            trailing: Icon(Icons.sync_alt, size: 16),
          ),
          
          _buildDetailRow(
            'Reference APR',
            '2.36%',
            trailing: Icon(Icons.trending_up, size: 16, color: Colors.green),
            trailingColor: Colors.green,
          ),
          
          _buildDetailRow(
            'Monthly Est. Rewards',
            '0 ETH',
            trailing: Icon(Icons.keyboard_arrow_down, size: 16),
          ),
          
          SizedBox(height: 24),
          
          // Info Box
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.yellow.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color.fromARGB(255, 122, 79, 223),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'When staking 1 ETH, you receive less than 1 WBETH because WBETH has higher value. WBETH\'s value increases over time as staking rewards accrue after launch. Upon redemption, you will get back your initial ETH and earned rewards.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 32),
          
          // Tab Section
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: const Color.fromARGB(255, 122, 79, 223), width: 2),
                  ),
                ),
                child: Text(
                  'Process',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 32),
              Text(
                'Product Rules',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Timeline
          _buildTimelineItem(
            'Stake Date',
            '2025-09-26 12:39',
            isFirst: true,
          ),
          
          _buildTimelineItem(
            'Rewards Start Accruing',
            '2025-09-27 05:30',
            isLast: true,
          ),
          
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String title, String description, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.black,
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon, Color? iconColor, Widget? trailing, Color? trailingColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          if (icon != null) ...[
            Icon(icon, size: 16, color: iconColor ?? Colors.grey.shade600),
            SizedBox(width: 4),
          ],
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: trailingColor ?? Colors.black,
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: 4),
            trailing,
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String label, String value, {bool isFirst = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isFirst ? Colors.black : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: Colors.grey.shade300,
                margin: EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _stakeAmountController.dispose();
    super.dispose();
  }
}