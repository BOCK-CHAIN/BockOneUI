import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'screens/datbase_service.dart'
    if (dart.library.html) 'screens/datbase_service_stub.dart';
import 'screens/mobile_login_screen.dart';
import 'screens/wallet_connect_service.dart';

/// Entry function for mobile app
Future<void> runMobileApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🔄 Connecting to Neon database...');
    await DatabaseService.initializeTables();
    debugPrint('✅ Database connected successfully!');
  } catch (e) {
    debugPrint('❌ Database connection failed: $e');
  }

  runApp(const MobileApp());
}

class MobileApp extends StatefulWidget {
  const MobileApp({Key? key}) : super(key: key);

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  late final WalletService _walletService;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _walletService = WalletService();
    // _walletService.initWeb3Client();
  }

  @override
  void dispose() {
    _walletService.dispose();
    super.dispose();
  }

  Future<bool> _handleSystemBack() async {
    final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 0;
    final isMobileView = !kIsWeb && screenWidth < 768;
    if (!isMobileView) {
      return true;
    }

    final navigator = _navigatorKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleSystemBack,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'BockChain',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: MobileLoginScreen(walletService: _walletService),
      ),
    );
  }
}
