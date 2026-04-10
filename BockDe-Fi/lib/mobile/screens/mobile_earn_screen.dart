import 'package:bockchain/mobile/screens/mobile_dualinvest_screen.dart';
import 'package:bockchain/mobile/screens/mobile_onchain_screen.dart';
import 'package:bockchain/mobile/screens/mobile_simpleearn_screen.dart';
import 'package:bockchain/mobile/screens/smart_arbitrage_screen.dart';
import 'package:flutter/material.dart';

class MobileEarnScreen extends StatefulWidget {
  @override
  _MobileEarnScreenState createState() => _MobileEarnScreenState();
}

class _MobileEarnScreenState extends State<MobileEarnScreen> {
  bool isLowRisk = true;

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
          'Earn',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLowRisk) ...[
                // Recommended section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MobileSimpleEarnScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'More',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Auto-Subscribe card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auto-Subscribe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tap to start earning automatically.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Activate',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Crypto cards row
                Row(
                  children: [
                    _buildCryptoCard('HOLO', '02D: 08H: 36M', '200%', 'APR', Colors.teal),
                    SizedBox(width: 12),
                    _buildCryptoCard('LINEA', '02D: 08H: 36M', '200%', 'APR', Colors.blue),
                    SizedBox(width: 12),
                    _buildCryptoCard('OPEN', '02D: 08H: 36M', '200%', 'APR', Colors.orange),
                  ],
                ),
                SizedBox(height: 20),
              ],

              // Toggle section
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLowRisk = true;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Low Risk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isLowRisk ? Colors.black : Colors.grey[500],
                          ),
                        ),
                        if (isLowRisk)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            height: 3,
                            width: 60,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 122, 79, 223),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLowRisk = false;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'High Yield',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: !isLowRisk ? Colors.black : Colors.grey[500],
                          ),
                        ),
                        if (!isLowRisk)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            height: 3,
                            width: 80,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 122, 79, 223),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
                ],
              ),
              SizedBox(height: 30),

              if (isLowRisk) ...[
                // Low Risk content
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Product', style: TextStyle(color: Colors.grey[600])),
                        Text('Est. APR', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildProductTile('USDT', '28.48%', 'Special Offer', true, () {
                      _showSubscribeDialog(context);
                    }),
                    SizedBox(height: 12),
                    _buildProductTile('USDC', '7.54%', '', false, () {}),
                    SizedBox(height: 12),
                    _buildProductTile('ETH', '1.39%', '', false, () {}),
                    SizedBox(height: 12),
                    _buildProductTile('USDT', '4.2%', 'RWA', false, () {}),
                    SizedBox(height: 12),
                    _buildProductTile('SOL', '1.8%-5.1%', '', false, () {}),
                  ],
                )
              ] else ...[
                // High Yield content
                _buildHighYieldSection(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoCard(String name, String time, String rate, String type, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
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
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.circle, color: Colors.white, size: 12),
                ),
                SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Text(
              rate,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              type,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(String symbol, String apr, String label, bool hasSpecialOffer, VoidCallback onTap) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCryptoColor(symbol),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                symbol[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            apr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 79, 223),
                borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildHighYieldSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dual Investment
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MobileDualInvestScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dual Investment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Enjoy high rewards - Buy Low, Sell High',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),

        // Dual Investment products
        _buildHighYieldProduct('BTC', '3.65%~11.83%'),
        SizedBox(height: 12),
        _buildHighYieldProduct('ETH', '3.65%~206.73%'),
        SizedBox(height: 12),
        _buildHighYieldProduct('BNB', '3.65%~111.69%'),
        SizedBox(height: 20),

        // Dual Investment RFQ
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.settings, color: Colors.grey[600]),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dual Investment RFQ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Enjoy customizations to suit your needs',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),

        // Smart Arbitrage
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SmartArbitrageScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Arbitrage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Arbitrage Steadily and Increase Your Profits Easily',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),

        // Smart Arbitrage products
        _buildArbitrageProduct('BTC/USDT', '8.66%'),
        SizedBox(height: 12),
        _buildArbitrageProduct('SOL/USDT', '1.18%'),
        SizedBox(height: 12),
        _buildArbitrageProduct('DOGE/USDT', '0.76%'),
        SizedBox(height: 30),

        // On-Chain Yields
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnChainYieldsScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'On-Chain Yields',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Earn on-chain rewards with one-click subscriptions',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),

        // On-Chain products
        _buildOnChainProduct('BTC Staking', '1%~1.6%'),
        SizedBox(height: 12),
        _buildOnChainProduct('WBETH', '0.2%~0.4%'),
        SizedBox(height: 12),
        _buildSoldOutProduct('USDT Staking', '2%'),
      ],
    );
  }

  Widget _buildHighYieldProduct(String symbol, String range) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCryptoColor(symbol),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                symbol[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Subscribe',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArbitrageProduct(String pair, String rate) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              pair,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            rate,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Subscribe',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnChainProduct(String name, String rate) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: name.contains('BTC') ? const Color.fromARGB(255, 122, 79, 223) : Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    name.contains('BTC') ? Icons.currency_bitcoin : Icons.diamond,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star, color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            rate,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Subscribe',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoldOutProduct(String name, String rate) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star, color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            rate,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Sold out',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCryptoColor(String symbol) {
    switch (symbol) {
      case 'USDT':
        return Colors.teal;
      case 'USDC':
        return Colors.blue;
      case 'ETH':
        return Colors.purple;
      case 'BTC':
        return Colors.orange;
      case 'BNB':
        return Colors.amber;
      case 'SOL':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  void _showSubscribeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => USDTSubscribeDialog(),
    );
  }
}

// USDT Subscribe Dialog (Image 2)
class USDTSubscribeDialog extends StatefulWidget {
  @override
  _USDTSubscribeDialogState createState() => _USDTSubscribeDialogState();
}

class _USDTSubscribeDialogState extends State<USDTSubscribeDialog> {
  bool autoSubscribe = false;
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          // Header
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'USDT Subscribe',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.help_outline, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flexible',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '28.48%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Max',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Special Offer',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 122, 79, 223),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Amount section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: autoSubscribe,
                            onChanged: (value) {
                              setState(() {
                                autoSubscribe = value ?? false;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 122, 79, 223),
                          ),
                          Text(
                            'Auto-Subscribe',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Amount input
                  Row(
                    children: [
                      Text(
                        'Minimum 0.1',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'USDT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Max',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Available balance
                  Row(
                    children: [
                      Text(
                        'Avail (2 sources) 0 USDT',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Top up',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 122, 79, 223),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Tabs
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
                          'Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 32),
                      Text(
                        'Product Rules',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Est. Daily Rewards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Est. Daily Rewards',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '-- USDT',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Reward tiers
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '0-200 USDT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'APR 28.48%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '>200 USDT',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Text(
                        'APR 3.48%',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Disclaimer text
                  Text(
                    '* To activate the Special Offer, you need to make a new subscription. The Special APR will be applied to reward accrual starting the next day (D+1) after subscription (D-day). The accrued rewards will be distributed to Spot Wallet the next day (D+2).',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 12),

                  Text(
                    '*APR does not represent actual or predicted returns in fiat currency. Please refer to the Product Rules for reward mechanisms.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),

                  // Terms checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            agreedToTerms = value ?? false;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 122, 79, 223),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I have read and agreed to ',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                              TextSpan(
                                text: 'BOCK De-Fi Simple Earn Service Agreement',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 122, 79, 223),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: agreedToTerms ? () {
                        Navigator.pop(context);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: agreedToTerms ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: agreedToTerms ? Colors.black : Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
    );
  }
}