/*import 'package:flutter/material.dart';

class MobileBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MobileBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF1E2329),
      selectedItemColor: Color(0xFFF0B90B),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Trade',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Markets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: 'Wallet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}*/

/*import 'package:flutter/material.dart';

class MobileBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MobileBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0D0D1A),
        border: Border(
          top: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0D0D1A),
        selectedItemColor: Color(0xFFF3BA2F),
        unselectedItemColor: Colors.grey[400],
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentIndex == 2 ? Color(0xFFF3BA2F) : Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.swap_horiz,
                color: currentIndex == 2 ? Colors.black : Colors.white,
                size: 20,
              ),
            ),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Futures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Assets',
          ),
        ],
      ),
    );
  }
}*/

/*import 'package:bockchain/mobile/screens/mobile_assets_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futures_screen.dart';
import 'package:bockchain/mobile/screens/mobile_home_screen.dart';
import 'package:bockchain/mobile/screens/mobile_market_screen.dart';
import 'package:bockchain/mobile/screens/mobile_trade_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';

class MobileBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MobileBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MobileBottomNav> createState() => _MobileBottomNavState();
}

class _MobileBottomNavState extends State<MobileBottomNav> {
  final WalletService _walletService = WalletService();

  @override
  void initState() {
    super.initState();
   // _walletService.initWeb3Client();
  }

  /// SCREENS BASED ON INDEX
  List<Widget> getScreens(String username, String email) {
    return [
      MobileHomeScreen(username: username, email: email, walletService: _walletService, walletAddress: walletAddress , privateKey:_privateKey ,),
      MobileMarketScreen(walletService: _walletService,),
      MobileTradeScreen(),
      MobileFuturesScreen(walletService: _walletService),
      MobileAssetsScreen(walletAddress: widget.walletAddress,
  privateKey: widget.privateKey, walletService:_walletService,),
    ];
  }

  // Navigation helpers (optional)
  static void navigateToMarkets(Function(int) onTap) => onTap(1);
  static void navigateToTrade(Function(int) onTap) => onTap(2);
  static void navigateToFutures(Function(int) onTap) => onTap(3);
  static void navigateToAssets(Function(int) onTap) => onTap(4);
  static void navigateToHome(Function(int) onTap) => onTap(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0D0D1A),
        border: Border(
          top: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0D0D1A),
        selectedItemColor: Color(0xFFF3BA2F),
        unselectedItemColor: Colors.grey[400],
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
                color: widget.currentIndex == 2
                    ? Color(0xFFF3BA2F)
                    : Colors.grey[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.swap_horiz,
                color:
                    widget.currentIndex == 2 ? Colors.black : Colors.white,
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
    );
  }
}*/
