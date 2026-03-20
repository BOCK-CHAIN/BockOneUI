import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/api_config.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BockFoodsApp());
}

class BockFoodsApp extends StatelessWidget {
  const BockFoodsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BockFoods',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const _BockFoodsBootstrap(),
    );
  }
}

class _BockFoodsBootstrap extends StatefulWidget {
  const _BockFoodsBootstrap();

  @override
  State<_BockFoodsBootstrap> createState() => _BockFoodsBootstrapState();
}

class _BockFoodsBootstrapState extends State<_BockFoodsBootstrap> {
  late final Future<void> _initFuture = _init();

  Future<void> _init() async {
    try {
      await dotenv.load();
    } catch (_) {
      // Best-effort (still works with mock data).
    }
    await ApiConfig.loadSavedBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFFEBDFF4),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const _AuthWrapper();
      },
    );
  }
}

class _AuthWrapper extends StatefulWidget {
  const _AuthWrapper();

  @override
  State<_AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<_AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await BockFoodsAuthService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isAuthenticated = isLoggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFEBDFF4),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isAuthenticated) {
      return const BockFoodsHomePage();
    } else {
      return const BockFoodsLoginPage();
    }
  }
}

