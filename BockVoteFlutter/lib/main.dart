import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/service_locator.dart';

// Providers
import 'data/providers/auth_provider.dart';
import 'data/providers/election_provider.dart' as data_election;
import 'data/providers/results_provider.dart';
import 'features/results/providers/results_provider.dart' as feature_results;
import 'features/admin/providers/admin_provider.dart';
import 'features/voting/providers/election_provider.dart';
import 'features/keys/providers/blockchain_key_provider.dart';

// Navigation
import 'presentation/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  await serviceLocator.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: serviceLocator.get<AuthProvider>(),
          ),
          ChangeNotifierProvider.value(
            value: serviceLocator.get<data_election.ElectionProvider>(),
          ),
          ChangeNotifierProvider.value(
            value: serviceLocator.get<ResultsProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => feature_results.ResultsProvider(),
          ),
          ChangeNotifierProvider.value(
            value: serviceLocator.get<AdminProvider>(),
          ),
          ChangeNotifierProvider(create: (_) => ElectionProvider()),
          ChangeNotifierProvider(create: (_) => BlockchainKeyProvider()),
        ],
        child: MaterialApp.router(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.createRouter(navigatorKey: _navigatorKey),
        ),
      ),
    );
  }
}
