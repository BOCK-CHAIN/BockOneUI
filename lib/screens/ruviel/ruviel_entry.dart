import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile.dart';
import 'screens/register_screen.dart';
import 'screens/settings_screen.dart';
import 'themes/purple_theme.dart';
import 'widgets/auth_wrapper.dart';

class RuvielEntry extends StatefulWidget {
  const RuvielEntry({super.key});

  @override
  State<RuvielEntry> createState() => _RuvielEntryState();
}

class _RuvielEntryState extends State<RuvielEntry> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _ensureInitialized();
  }

  Future<void> _ensureInitialized() async {
    try {
      Supabase.instance.client;
      return;
    } catch (_) {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        }

        return ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const _RuvielApp(),
        );
      },
    );
  }
}

class _RuvielApp extends StatelessWidget {
  const _RuvielApp();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Ruviel',
      debugShowCheckedModeBanner: false,
      theme: PurpleTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(PurpleTheme.lightTheme.textTheme),
      ),
      darkTheme: PurpleTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(PurpleTheme.darkTheme.textTheme),
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AuthWrapper(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/profile': (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as String?;
          return ProfileScreen(userId: userId);
        },
      },
    );
  }
}
