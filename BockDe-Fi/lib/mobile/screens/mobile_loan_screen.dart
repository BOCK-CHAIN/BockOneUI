import 'package:bockchain/mobile/screens/mobile_dualinvest_screen.dart';
import 'package:bockchain/mobile/screens/mobile_ethstaking_screen.dart';
import 'package:bockchain/mobile/screens/mobile_simpleearn_screen.dart';
import 'package:flutter/material.dart';

// Import your existing screens
// import 'mobile_simpleearn_screen.dart';
// import 'mobile_ethstaking_screen.dart';
// import 'mobile_dualinvest_screen.dart';

class MobileLoanScreen extends StatefulWidget {
  @override
  _MobileLoanScreenState createState() => _MobileLoanScreenState();
}

class _MobileLoanScreenState extends State<MobileLoanScreen> {
  bool _showBorrowingScreen = false;
  String _selectedCollateral = 'BNB';
  String _selectedBorrowAsset = 'USDT';
  bool _agreementAccepted = false;

  void _navigateToBorrowingScreen() {
    setState(() {
      _showBorrowingScreen = true;
    });
  }

  void _navigateBack() {
    setState(() {
      _showBorrowingScreen = false;
    });
  }

  void _navigateToScreen(String screenType) {
    switch (screenType) {
      case 'simple_earn':
         Navigator.push(context, MaterialPageRoute(builder: (context) => MobileSimpleEarnScreen()));
        break;
      case 'eth_staking':
         Navigator.push(context, MaterialPageRoute(builder: (context) => MobileEthStakingScreen()));
        break;
      case 'dual_investment':
         Navigator.push(context, MaterialPageRoute(builder: (context) => MobileDualInvestScreen()));
        break;
    }
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
          onPressed: _showBorrowingScreen ? _navigateBack : () => Navigator.pop(context),
        ),
        title: Text(
          _showBorrowingScreen ? 'Flexible Rate Loan' : 'BOCK De-Fi Loans',
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
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _showBorrowingScreen ? _buildBorrowingScreen() : _buildMainScreen(),
    );
  }

  Widget _buildMainScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flexible Rate Loan Section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color.fromARGB(255, 194, 147, 255)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flexible Rate Loan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Repay at any time & no transaction fee',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateToBorrowingScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Start Borrowing',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loan Types Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildLoanTypeCard(
                    'Fixed Rate Loans',
                    'Borrow with customized interest rate',
                    Icons.lock_outline,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildLoanTypeCard(
                    'VIP Loan',
                    'Institutional-Level Loan Services for VIP Users',
                    Icons.account_balance,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Popular Assets Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular Assets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Assets Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Coin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Spacer(),
                Text(
                  'Annualized Rate',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Popular Assets List
          _buildAssetItem('BTC', 'Bitcoin', Colors.orange, '0.47%'),
          _buildAssetItem('ETH', 'Ethereum', Colors.blue, '2.54%'),
          _buildAssetItem('USDT', 'Tether', Colors.green, '7.1%'),

          SizedBox(height: 32),

          // Earn more section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Earn more with borrowed assets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Earning Options
          _buildEarningOption(
            'Simple Earn',
            'The simple way to Deposit & Earn',
            Icons.account_balance_wallet,
            'simple_earn',
          ),
          _buildEarningOption(
            'ETH Staking',
            'Earn ETH staking rewards while helping to secure the Ethereum network',
            Icons.currency_bitcoin,
            'eth_staking',
          ),
          _buildEarningOption(
            'Dual Investment',
            'Enjoy high rewards - Buy Low, Sell High',
            Icons.swap_horiz,
            'dual_investment',
          ),

          SizedBox(height: 32),

          // FAQ Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Got a question? Check FAQ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildBorrowingScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collateral Amount Section
          Row(
            children: [
              Text(
                'Collateral Amount',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),

          SizedBox(height: 12),

          // Collateral Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
                Spacer(),
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
                SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 122, 79, 223),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'BNB',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Warning Message
          Container(
            padding: EdgeInsets.all(12),
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
                    'Collateralized BNB assets will not be eligible for Launchpool rewards.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // I want to borrow section
          Text(
            'I want to borrow',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 12),

          // Borrow Asset Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
                Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'T',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'USDT',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Loan Details
          _buildLoanDetailRow('Current LTV', '--'),
          _buildLoanDetailRow('Initial LTV', '78%'),
          _buildLoanDetailRow('Margin Call LTV', '85%'),
          _buildLoanDetailRow('Liquidation LTV', '91%'),
          _buildLoanDetailRow('Annualized Interest Rate', '7.10%'),
          _buildLoanDetailRow('Net Annualized Interest Rate', '0.00%'),
          _buildLoanDetailRow('Estimated Hourly Interest', '--'),
          _buildLoanDetailRow('Liquidation Price (BNB/USDT)', '0', trailing: Icon(Icons.sync_alt, size: 16)),

          SizedBox(height: 32),

          // Agreement Checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreementAccepted,
                onChanged: (value) {
                  setState(() {
                    _agreementAccepted = value ?? false;
                  });
                },
                activeColor: const Color.fromARGB(255, 122, 79, 223),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    children: [
                      TextSpan(text: 'By continuing, you have read and agree to '),
                      TextSpan(
                        text: 'BOCK De-Fi Loan Service Agreement',
                        style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223)),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'BOCK De-Fi Simple Earn Service Agreement',
                        style: TextStyle(color: const Color.fromARGB(255, 122, 79, 223)),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _agreementAccepted ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _agreementAccepted ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey.shade300,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: _agreementAccepted ? Colors.black : Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLoanTypeCard(String title, String description, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Colors.grey.shade600),
              SizedBox(width: 8),
              Icon(Icons.link, size: 16, color: const Color.fromARGB(255, 122, 79, 223)),
            ],
          ),
          SizedBox(height: 12),
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
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetItem(String symbol, String name, Color color, String rate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                symbol[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            symbol,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Text(
            rate,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildEarningOption(String title, String description, IconData icon, String screenType) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToScreen(screenType),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.grey.shade700,
                ),
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
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value, {Widget? trailing}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
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
}