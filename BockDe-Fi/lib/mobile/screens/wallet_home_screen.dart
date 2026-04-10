import 'package:bockchain/mobile/screens/mobile_home_screen.dart';
import 'package:bockchain/mobile/screens/wallet_assets_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:bockchain/mobile/screens/wallet_discover_screen.dart';
import 'package:bockchain/mobile/screens/wallet_market_screen.dart';
import 'package:bockchain/mobile/screens/wallet_trade_screen.dart';
import 'package:flutter/material.dart';

class WalletHomeScreen extends StatefulWidget {
  final WalletService? walletService;

  const WalletHomeScreen({Key? key, this.walletService}) : super(key: key);

  @override
  State<WalletHomeScreen> createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WalletMainContent(),
    const WalletMarketScreen(),
    const WalletTradeScreen(),
    const WalletDiscoverScreen(),
    const WalletAssetsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined),
            activeIcon: Icon(Icons.wallet),
            label: 'Assets',
          ),
        ],
      ),
    );
  }
}

class WalletMainContent extends StatelessWidget {
  const WalletMainContent({Key? key}) : super(key: key);

  void _showMoreBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'More',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildMoreOption(
                context,
                icon: Icons.article_outlined,
                title: 'Inscription',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletInscriptionScreen(),
                    ),
                  );
                },
              ),
              _buildMoreOption(
                context,
                icon: Icons.account_balance_outlined,
                title: 'Solana Account Rent Recovery',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletSolanaRentScreen(),
                    ),
                  );
                },
              ),
              _buildMoreOption(
                context,
                icon: Icons.link_outlined,
                title: 'Connected DApps',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletConnectedDappsScreen(),
                    ),
                  );
                },
              ),
              _buildMoreOption(
                context,
                icon: Icons.history_outlined,
                title: 'History',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WalletHistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildMoreOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.menu, size: 28),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            /*Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MobileHomeScreen(username: '', email: '',walletService: widget.walletService)),
                            );*/
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 16 : 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Exchange',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 13 : 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 24,
                            vertical: 8,
                          ),
                          child: Text(
                            'Wallet',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, size: 28),
                ],
              ),
            ),

            // Wallet Balance Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Color.fromARGB(255, 122, 79, 223), size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'My Wallet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 20),
                  const SizedBox(width: 8),
                  Icon(Icons.copy_outlined, color: Colors.grey[600], size: 18),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '₹0',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 36 : 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 24 : 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Receive',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.qr_code_scanner_outlined,
                    label: 'Scan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WalletScanScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: 'Alpha',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WalletAlphaScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.person_add_outlined,
                    label: 'Referral',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WalletReferralScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    label: 'Earn',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WalletEarnScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAction(
                    context,
                    icon: Icons.more_horiz,
                    label: 'More',
                    onTap: () => _showMoreBottomSheet(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Booster Program
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.rocket_launch, color: Colors.green[700]),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Turtle Booster Program Phase 1',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Join', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      title: 'Meme Rush',
                      value: '763',
                      subtitle: 'new tokens',
                      icons: [
                        _buildTokenIcon(Colors.purple),
                        _buildTokenIcon(Colors.blue),
                        _buildTokenIcon(Colors.brown),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      title: 'Earn',
                      value: '15.33%',
                      subtitle: 'APY',
                      subValue: 'USDT',
                      showChart: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tabs Section
            DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: Colors.black,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Watchlist'),
                        Tab(text: 'Trending'),
                        Tab(text: 'Alpha'),
                        Tab(text: 'Newest'),
                      ],
                    ),
                  ),

                  // Chain Filter
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildChainChip('All', true),
                          _buildChainChip('BSC', false),
                          _buildChainChip('Solana', false),
                          _buildChainChip('Ethereum', false),
                          _buildChainChip('Base', false),
                        ],
                      ),
                    ),
                  ),

                  // Token List
                  _buildTokenItem(
                    name: 'TRUTH',
                    marketCap: '₹427.03K',
                    volume: '₹3.08B',
                    price: '₹1.47769',
                    change: '-2.43%',
                    isNegative: true,
                    color: Colors.purple,
                  ),
                  _buildTokenItem(
                    name: 'STRIKE',
                    marketCap: '₹81.97M',
                    volume: '₹444.47M',
                    price: '₹2.11752',
                    change: '-0.13%',
                    isNegative: true,
                    color: Colors.blue,
                  ),
                  _buildTokenItem(
                    name: 'KOGE',
                    marketCap: '₹3.04B',
                    volume: '₹14.41B',
                    price: '₹4,264.66',
                    change: '+0.02%',
                    isNegative: false,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String subtitle,
    String? subValue,
    List<Widget>? icons,
    bool showChart = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (icons != null) ...icons,
              if (icons == null && subValue != null)
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, size: 16, color: Colors.teal),
                    const SizedBox(width: 4),
                    Text(subValue, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenIcon(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildChainChip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (selected) const Icon(Icons.language, size: 16, color: Colors.white),
          if (selected) const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenItem({
    required String name,
    required String marketCap,
    required String volume,
    required String price,
    required String change,
    required bool isNegative,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0],
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 16, color: Color.fromARGB(255, 122, 79, 223)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      marketCap,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      volume,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: isNegative ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder screens

class WalletScanScreen extends StatelessWidget {
  const WalletScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan')),
      body: const Center(child: Text('Scan Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class WalletAlphaScreen extends StatelessWidget {
  const WalletAlphaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alpha')),
      body: const Center(child: Text('Alpha Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class WalletReferralScreen extends StatelessWidget {
  const WalletReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Referral')),
      body: const Center(child: Text('Referral Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class WalletEarnScreen extends StatelessWidget {
  const WalletEarnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earn')),
      body: const Center(child: Text('Earn Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class WalletInscriptionScreen extends StatelessWidget {
  const WalletInscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: const Center(child: Text('Inscription Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class WalletSolanaRentScreen extends StatelessWidget {
  const WalletSolanaRentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solana Account Rent Recovery')),
      body: const Center(child: Text('Solana Rent Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class WalletConnectedDappsScreen extends StatelessWidget {
  const WalletConnectedDappsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected DApps')),
      body: const Center(child: Text('Connected DApps Screen', style: TextStyle(fontSize: 24))),
    );
  }
}

class WalletHistoryScreen extends StatelessWidget {
  const WalletHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('History Screen', style: TextStyle(fontSize: 24))),
    );
  }
}