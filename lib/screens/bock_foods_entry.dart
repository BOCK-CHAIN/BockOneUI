import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bock_foods/providers/cart_provider.dart' as foods;
import 'package:bock_foods/providers/instamart_cart_provider.dart' as foods;
import 'package:bock_foods/providers/auth_provider.dart' as foods;
import 'package:bock_foods/config/api_config.dart' as foods;
import 'package:bock_foods/screens/home_screen.dart' as foods;
import 'package:bock_foods/screens/restaurants_screen.dart' as foods;
import 'package:bock_foods/screens/cart_screen.dart' as foods;
import 'package:bock_foods/screens/checkout_screen.dart' as foods;
import 'package:bock_foods/screens/instamart_screen.dart' as foods;
import 'package:bock_foods/screens/restaurant_detail_final.dart' as foods;
import 'package:bock_foods/screens/login_signup_screen.dart' as foods;
import 'package:bock_foods/screens/account_screen.dart' as foods;

class BockFoodsEntry extends StatefulWidget {
  const BockFoodsEntry({super.key});

  @override
  State<BockFoodsEntry> createState() => _BockFoodsEntryState();
}

class _BockFoodsEntryState extends State<BockFoodsEntry> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  Future<void> _initialize() async {
    try {
      await dotenv.load();
    } catch (_) {
      // Best-effort load
    }
    await foods.ApiConfig.loadSavedBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F9FB),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => foods.FoodCartProvider()),
            ChangeNotifierProvider(create: (_) => foods.InstamartCartProvider()),
            ChangeNotifierProvider(create: (_) => foods.AuthProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bock Foods',
            theme: ThemeData(
              primaryColor: const Color(0xFF27A600),
              colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xFF27A600)),
              scaffoldBackgroundColor: const Color(0xFFF7F9FB),
              useMaterial3: true,
            ),
            home: const _AppWrapper(),
            routes: {
              foods.RestaurantsScreen.routeName: (_) => const foods.RestaurantsScreen(),
              foods.RestaurantDetailFinalScreen.routeName: (_) => const foods.RestaurantDetailFinalScreen(),
              foods.CartScreen.routeName: (_) => const foods.CartScreen(),
              foods.CheckoutScreen.routeName: (_) => const foods.CheckoutScreen(),
              foods.InstamartScreen.routeName: (_) => const foods.InstamartScreen(),
              foods.AccountScreen.routeName: (_) => const foods.AccountScreen(),
              '/home': (_) => const foods.HomeScreen(),
            },
          ),
        );
      },
    );
  }
}

class _AppWrapper extends StatelessWidget {
  const _AppWrapper();

  @override
  Widget build(BuildContext context) {
    return Consumer<foods.AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isLoggedIn) {
          return const foods.LoginSignupScreen();
        }
        return const foods.HomeScreen();
      },
    );
  }
}
