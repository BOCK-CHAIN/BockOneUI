import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true; // Dark mode as default

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF9333EA),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF9333EA), // Purple primary
      secondary: const Color(0xFF6B46C1), // Deep purple secondary
      tertiary: const Color(0xFFA855F7), // Light purple accent
      surface: const Color(0xFFFFF5FF), // Very light purple tint
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF1F2937),
      error: const Color(0xFFDC2626),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF5FF), // Light purple background
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFF5FF), // Light purple background
      foregroundColor: Color(0xFF9333EA), // Purple text/icons
      elevation: 1,
      iconTheme: IconThemeData(color: Color(0xFF9333EA)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFF9333EA).withOpacity(0.2), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9333EA),
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF9333EA),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1F2937)),
      bodyMedium: TextStyle(color: Color(0xFF6B7280)),
      headlineLarge: TextStyle(color: Color(0xFF9333EA), fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color(0xFF9333EA), fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9333EA)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9333EA), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFF9333EA).withOpacity(0.5)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: const Color(0xFF9333EA).withOpacity(0.2),
      thickness: 1,
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF9333EA),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF9333EA),
      secondary: const Color(0xFF6B46C1),
      surface: const Color(0xFF1E1E1E),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey),
    ),
  );
}