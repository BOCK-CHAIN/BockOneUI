import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const _prefsKey = 'bockFoodsApiBaseUrl';

  static String? _cached;

  static String? get baseUrl => _cached;

  static Future<void> loadSavedBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    _cached = prefs.getString(_prefsKey) ?? dotenv.env['BOCK_FOODS_API_BASE_URL'];
  }

  static Future<void> saveBaseUrl(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null || value.trim().isEmpty) {
      await prefs.remove(_prefsKey);
      _cached = dotenv.env['BOCK_FOODS_API_BASE_URL'];
      return;
    }
    await prefs.setString(_prefsKey, value.trim());
    _cached = value.trim();
  }
}

