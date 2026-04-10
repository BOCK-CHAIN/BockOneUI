import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'pages/login_screen.dart';
import 'pages/desktop_drive_platform.dart';
import 'pages/mobile_drive.dart';
import 'services/auth_service.dart';
import 'widgets/drive_exit_scope.dart';

void main() {
  runApp(const BockDriveApp());
}

class BockDriveApp extends StatelessWidget {
  const BockDriveApp({super.key, this.onExit});

  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    return DriveExitScope(
      onExit: onExit,
      child: MaterialApp(
        title: 'BockDrive',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6A1B9A), // Purple theme to match login screen
            brightness: Brightness.dark,
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const AuthWrapper(), // Check auth status and show appropriate screen
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Widget that checks authentication status and navigates accordingly
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (mounted) {
        setState(() {
          _isAuthenticated = isLoggedIn;
          _isLoading = false;
        });
      }
    } catch (e) {
      // If there's an error checking auth, show login screen
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF6A1B9A),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading BockDrive...',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isAuthenticated) {
      return const ResponsiveDriveHome();
    } else {
      return const LoginScreen();
    }
  }
}

// This will be used AFTER login to show the appropriate drive screen
class ResponsiveDriveHome extends StatelessWidget {
  const ResponsiveDriveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use desktop version for desktop/tablet (width > 768) or when running on web
        if (constraints.maxWidth > 768 || kIsWeb) {
          return const DesktopDrive();
        } else {
          // Use mobile version for mobile devices
          return const MobileDrive();
        }
      },
    );
  }
}
