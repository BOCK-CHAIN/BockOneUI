/*import 'package:bockchain/widgets/main_layout.dart';
import 'package:flutter/material.dart';
//import 'main_layout.dart'; // Import your MainLayout
import 'screens/home_screen.dart';
import 'screens/buy_crypto_screen.dart';
import 'screens/market_screen.dart';
import 'screens/trade_screen.dart';
import 'screens/earn_screen.dart';
import 'screens/square_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;
  String selectedLanguage = 'en';

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bock Chain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      // Home route
      home: MainLayout(
        child: const HomeScreen(), // Your default/home screen
        isDarkMode: isDarkMode,
        onThemeToggle: toggleTheme,
        selectedLanguage: selectedLanguage,
        onLanguageChange: changeLanguage,
      ),
      // All your screen routes wrapped in MainLayout
      routes: {
        '/buy-crypto': (context) => MainLayout(
              child: BuyCryptoScreen(), // ✅ Wrapped in MainLayout
              isDarkMode: isDarkMode,
              onThemeToggle: toggleTheme,
              selectedLanguage: selectedLanguage,
              onLanguageChange: changeLanguage,
            ),
        '/market': (context) => MainLayout(
              child: MarketScreen(), // ✅ Wrapped in MainLayout
              isDarkMode: isDarkMode,
              onThemeToggle: toggleTheme,
              selectedLanguage: selectedLanguage,
              onLanguageChange: changeLanguage,
            ),
        '/trade': (context) => MainLayout(
              child: TradeScreen(), // ✅ Wrapped in MainLayout
              isDarkMode: isDarkMode,
              onThemeToggle: toggleTheme,
              selectedLanguage: selectedLanguage,
              onLanguageChange: changeLanguage,
            ),
        '/earn': (context) => MainLayout(
              child: EarnScreen(), // ✅ Wrapped in MainLayout
              isDarkMode: isDarkMode,
              onThemeToggle: toggleTheme,
              selectedLanguage: selectedLanguage,
              onLanguageChange: changeLanguage,
            ),
        '/square': (context) => MainLayout(
              child: SquareScreen(), // ✅ Wrapped in MainLayout
              isDarkMode: isDarkMode,
              onThemeToggle: toggleTheme,
              selectedLanguage: selectedLanguage,
              onLanguageChange: changeLanguage,
            ),
      },
    );
  }
}*/
import 'mobile/mobile_app.dart';

void main() {
  runMobileApp();
}

/*import 'package:flutter/material.dart';  THE MAIN MAIN
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
//import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Bock Chain - Crypto Exchange',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}*/
/*
import 'package:bockchain/screens/deposit_screen.dart';
import 'package:bockchain/screens/recurring_buy_screen.dart';
import 'package:bockchain/screens/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'screens/buy_sell_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Trading App',
      theme: AppTheme.darkTheme,
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _tabController,
            onTap: (index) => setState(() => _selectedIndex = index),
            indicator: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Buy & Sell'),
              Tab(text: 'Recurring Buy'),
              Tab(text: 'Deposit'),
              Tab(text: 'Withdraw'),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt_long, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: AppTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BuySellScreen(),
          RecurringBuyScreen(),
          DepositScreen(),
          WithdrawScreen(),
        ],
      ),
    );
  }
}*/