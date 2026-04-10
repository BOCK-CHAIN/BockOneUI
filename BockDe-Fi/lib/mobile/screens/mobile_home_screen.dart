/*import 'package:flutter/material.dart';
import 'package:bockchain/mobile/screens/mobile_assets_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futures_screen.dart';
import 'package:bockchain/mobile/screens/mobile_market_screen.dart';
import 'package:bockchain/mobile/screens/mobile_trade_screen.dart';

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({Key? key}) : super(key: key);

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return MobileMarketScreen();
      case 2:
        return MobileTradeScreen();
      case 3:
        return MobileFuturesScreen();
      case 4:
        return MobileAssetsScreen();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentIndex == 0 ? Colors.grey[50] : null,
      appBar: _currentIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Exchange',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Wallet',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.headset_mic, color: Colors.black),
          SizedBox(width: 8),
          Icon(Icons.phone, color: Colors.black),
          SizedBox(width: 16),
        ],
      ) : null,
      body: _getCurrentScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
            top: BorderSide(color: Colors.grey[800]!, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          selectedItemColor: Color.fromARGB(255, 122, 79, 223),
          unselectedItemColor: const Color.fromARGB(255, 20, 20, 20),
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.candlestick_chart_outlined),
              activeIcon: Icon(Icons.candlestick_chart),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: _currentIndex == 2 ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
              label: 'Trade',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up),
              label: 'Futures',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Assets',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // APR Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: const Color.fromARGB(255, 122, 79, 223)),
                const SizedBox(width: 8),
                const Text(
                  'BFUSD 6.92% APR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),

          // Onboarding Task
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Onboarding Task',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Deposit Your First Crypto',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Add Funds',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Feature Icons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureIcon(Icons.card_giftcard, 'Rewards Hub'),
                _buildFeatureIcon(Icons.security, 'Sharia Earn'),
                _buildFeatureIcon(Icons.person_add, 'Referral'),
                _buildFeatureIcon(Icons.account_balance_wallet, 'Earn'),
                _buildFeatureIcon(Icons.more_horiz, 'More'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Personalized Home Experience Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Discover personalized home experiences!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Crypto Price Cards
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCryptoCard('BNB', '997.50', '0.35%', true, Colors.orange),
                _buildCryptoCard('SOL', '237.41', '2.09%', false, const Color.fromRGBO(156, 39, 176, 1)),
                _buildCryptoCard('BTC', '64,250.00', '1.24%', true, Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Latest Crypto News Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latest Crypto News',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildNewsItem(
                  'Bitcoin Reaches New All-Time High',
                  'BTC surges past \$65,000 amid institutional adoption',
                  '2h ago',
                  Icons.trending_up,
                ),
                _buildNewsItem(
                  'Ethereum 2.0 Staking Rewards Increase',
                  'ETH staking now offers up to 5.2% APY for validators',
                  '4h ago',
                  Icons.account_balance,
                ),
                _buildNewsItem(
                  'New DeFi Protocol Launches',
                  'Revolutionary lending platform offers competitive rates',
                  '6h ago',
                  Icons.rocket_launch,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // FAQ Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFAQItem(
                  'How do I deposit cryptocurrency?',
                  'Tap on "Add Funds" and select your preferred deposit method. You can deposit via bank transfer or crypto wallet.',
                ),
                _buildFAQItem(
                  'What are the trading fees?',
                  'Our trading fees start from 0.1% and decrease based on your monthly trading volume and BNB holdings.',
                ),
                _buildFAQItem(
                  'Is my crypto safe on this platform?',
                  'Yes, we use industry-leading security measures including cold storage, 2FA, and insurance coverage for digital assets.',
                ),
                _buildFAQItem(
                  'How does the referral program work?',
                  'Invite friends and earn up to 40% commission on their trading fees. Both you and your friend get bonus rewards.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Extra space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color.fromARGB(255, 122, 79, 223), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCryptoCard(String symbol, String price, String change, bool isPositive, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.currency_bitcoin, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mini chart placeholder
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title, String subtitle, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue[600], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}*/

/*import 'package:bockchain/mobile/screens/mobile_service_screen.dart';
import 'package:bockchain/mobile/screens/wallet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:bockchain/mobile/screens/mobile_assets_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futures_screen.dart';
import 'package:bockchain/mobile/screens/mobile_market_screen.dart';
import 'package:bockchain/mobile/screens/mobile_trade_screen.dart';
import 'package:bockchain/mobile/screens/mobile_rewards_screen.dart';
import 'package:bockchain/mobile/screens/mobile_sharia_screen.dart';
import 'package:bockchain/mobile/screens/mobile_referral_screen.dart';
import 'package:bockchain/mobile/screens/mobile_earn_screen.dart';
//import 'package:bockchain/mobile/screens/mobile_wallet_screen.dart';

class MobileHomeScreen extends StatefulWidget {
  final String username;
  final String email;

  const MobileHomeScreen({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);
  

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return MobileMarketScreen();
      case 2:
        return MobileTradeScreen();
      case 3:
        return MobileFuturesScreen();
      case 4:
        return MobileAssetsScreen();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentIndex == 0 ? Colors.grey[50] : null,
      appBar: _currentIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Already on Exchange/Home screen, do nothing or refresh
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Exchange',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletHomeScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  'Wallet',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.headset_mic, color: Colors.black),
          SizedBox(width: 8),
          Icon(Icons.phone, color: Colors.black),
          SizedBox(width: 16),
        ],
      ) : null,
      body: _getCurrentScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
            top: BorderSide(color: Colors.grey[800]!, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          selectedItemColor: Color.fromARGB(255, 122, 79, 223),
          unselectedItemColor: const Color.fromARGB(255, 20, 20, 20),
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.candlestick_chart_outlined),
              activeIcon: Icon(Icons.candlestick_chart),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: _currentIndex == 2 ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
              label: 'Trade',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up),
              label: 'Futures',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Assets',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // APR Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: const Color.fromARGB(255, 122, 79, 223)),
                const SizedBox(width: 8),
                const Text(
                  'BFUSD 6.92% APR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),

          // Onboarding Task
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Onboarding Task',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Deposit Your First Crypto',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Add Funds',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Feature Icons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureIcon(Icons.card_giftcard, 'Rewards Hub', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileRewardsScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.security, 'Sharia Earn', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileShariaScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.person_add, 'Referral', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileReferralScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.account_balance_wallet, 'Earn', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileEarnScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.more_horiz, 'More', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileServiceScreen()),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Personalized Home Experience Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Discover personalized home experiences!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Crypto Price Cards
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCryptoCard('BNB', '997.50', '0.35%', true, Colors.orange),
                _buildCryptoCard('SOL', '237.41', '2.09%', false, const Color.fromRGBO(156, 39, 176, 1)),
                _buildCryptoCard('BTC', '64,250.00', '1.24%', true, Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Latest Crypto News Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latest Crypto News',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildNewsItem(
                  'Bitcoin Reaches New All-Time High',
                  'BTC surges past \$65,000 amid institutional adoption',
                  '2h ago',
                  Icons.trending_up,
                ),
                _buildNewsItem(
                  'Ethereum 2.0 Staking Rewards Increase',
                  'ETH staking now offers up to 5.2% APY for validators',
                  '4h ago',
                  Icons.account_balance,
                ),
                _buildNewsItem(
                  'New DeFi Protocol Launches',
                  'Revolutionary lending platform offers competitive rates',
                  '6h ago',
                  Icons.rocket_launch,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // FAQ Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFAQItem(
                  'How do I deposit cryptocurrency?',
                  'Tap on "Add Funds" and select your preferred deposit method. You can deposit via bank transfer or crypto wallet.',
                ),
                _buildFAQItem(
                  'What are the trading fees?',
                  'Our trading fees start from 0.1% and decrease based on your monthly trading volume and BNB holdings.',
                ),
                _buildFAQItem(
                  'Is my crypto safe on this platform?',
                  'Yes, we use industry-leading security measures including cold storage, 2FA, and insurance coverage for digital assets.',
                ),
                _buildFAQItem(
                  'How does the referral program work?',
                  'Invite friends and earn up to 40% commission on their trading fees. Both you and your friend get bonus rewards.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Extra space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color.fromARGB(255, 122, 79, 223), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(String symbol, String price, String change, bool isPositive, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.currency_bitcoin, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mini chart placeholder
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title, String subtitle, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue[600], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:bockchain/mobile/screens/mobile_profile_screen.dart';
import 'package:bockchain/mobile/screens/mobile_service_screen.dart' as more;
import 'package:bockchain/mobile/screens/mobile_transaction_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:bockchain/mobile/screens/wallet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:bockchain/mobile/screens/mobile_assets_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futures_screen.dart';
import 'package:bockchain/mobile/screens/mobile_market_screen.dart';
import 'package:bockchain/mobile/screens/mobile_trade_screen.dart';
import 'package:bockchain/mobile/screens/mobile_rewards_screen.dart';
import 'package:bockchain/mobile/screens/mobile_sharia_screen.dart';
import 'package:bockchain/mobile/screens/mobile_referral_screen.dart' as referral;
import 'package:bockchain/mobile/screens/mobile_earn_screen.dart' as earn;

class MobileHomeScreen extends StatefulWidget {
  final WalletService walletService;
  final String username;
  final String email;
  final String walletAddress;
  final String privateKey;

  const MobileHomeScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.walletService,
    required this.walletAddress,
    required this.privateKey,
  }) : super(key: key);
  

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}



class _MobileHomeScreenState extends State<MobileHomeScreen> {
  final WalletService _walletService = WalletService();
  @override
  void initState() {
    super.initState();
    //_walletService.initWeb3Client();
  }
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return MobileMarketScreen(walletService: widget.walletService,);
      case 2:
        return MobileTradeScreen();
      case 3:
        return MobileFuturesScreen(walletService: widget.walletService,);
      case 4:
        return MobileAssetsScreen(walletAddress: widget.walletAddress,
  privateKey: widget.privateKey, walletService: widget.walletService,);
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentIndex == 0 ? Colors.grey[50] : null,
      appBar: _currentIndex == 0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MobileProfileScreen(
                  username: widget.username,
                  email: widget.email,
                ),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Already on Exchange/Home screen, do nothing or refresh
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Exchange',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WalletHomeScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  'Wallet',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.headset_mic, color: Colors.black),
          SizedBox(width: 8),
          Icon(Icons.phone, color: Colors.black),
          SizedBox(width: 16),
        ],
      ) : null,
      body: _getCurrentScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
            top: BorderSide(color: Colors.grey[800]!, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          selectedItemColor: Color.fromARGB(255, 122, 79, 223),
          unselectedItemColor: const Color.fromARGB(255, 20, 20, 20),
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.candlestick_chart_outlined),
              activeIcon: Icon(Icons.candlestick_chart),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _currentIndex == 2 ? Color.fromARGB(255, 122, 79, 223) : Colors.grey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: _currentIndex == 2 ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
              label: 'Trade',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_outlined),
              activeIcon: Icon(Icons.trending_up),
              label: 'Futures',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Assets',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    // Onboarding Task
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Onboarding Task',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Deposit Your First Crypto',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 122, 79, 223),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Add Funds',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Feature Icons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureIcon(Icons.card_giftcard, 'Rewards Hub', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileRewardsScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.security, 'Sharia Earn', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MobileShariaScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.person_add, 'Referral', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => referral.MobileReferralScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.account_balance_wallet, 'Earn', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => earn.MobileEarnScreen()),
                  );
                }),
                _buildFeatureIcon(Icons.more_horiz, 'More', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => more.MobileServiceScreen()),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Personalized Home Experience Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 79, 223),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Discover personalized home experiences!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Crypto Price Cards
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCryptoCard('BNB', '997.50', '0.35%', true, Colors.orange),
                _buildCryptoCard('SOL', '237.41', '2.09%', false, const Color.fromRGBO(156, 39, 176, 1)),
                _buildCryptoCard('BTC', '64,250.00', '1.24%', true, Colors.orange),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Latest Crypto News Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latest Crypto News',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildNewsItem(
                  'Bitcoin Reaches New All-Time High',
                  'BTC surges past \$65,000 amid institutional adoption',
                  '2h ago',
                  Icons.trending_up,
                ),
                _buildNewsItem(
                  'Ethereum 2.0 Staking Rewards Increase',
                  'ETH staking now offers up to 5.2% APY for validators',
                  '4h ago',
                  Icons.account_balance,
                ),
                _buildNewsItem(
                  'New DeFi Protocol Launches',
                  'Revolutionary lending platform offers competitive rates',
                  '6h ago',
                  Icons.rocket_launch,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // FAQ Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFAQItem(
                  'How do I deposit cryptocurrency?',
                  'Tap on "Add Funds" and select your preferred deposit method. You can deposit via bank transfer or crypto wallet.',
                ),
                _buildFAQItem(
                  'What are the trading fees?',
                  'Our trading fees start from 0.1% and decrease based on your monthly trading volume and BNB holdings.',
                ),
                _buildFAQItem(
                  'Is my crypto safe on this platform?',
                  'Yes, we use industry-leading security measures including cold storage, 2FA, and insurance coverage for digital assets.',
                ),
                _buildFAQItem(
                  'How does the referral program work?',
                  'Invite friends and earn up to 40% commission on their trading fees. Both you and your friend get bonus rewards.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Extra space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color.fromARGB(255, 122, 79, 223), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(String symbol, String price, String change, bool isPositive, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.currency_bitcoin, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mini chart placeholder
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(String title, String subtitle, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue[600], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}