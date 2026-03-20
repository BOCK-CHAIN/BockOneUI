import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/api_config.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class BockFoodsSettingsPage extends StatefulWidget {
  const BockFoodsSettingsPage({super.key});

  @override
  State<BockFoodsSettingsPage> createState() => _BockFoodsSettingsPageState();
}

class _BockFoodsSettingsPageState extends State<BockFoodsSettingsPage> {
  final _ctrl = TextEditingController();
  bool _saving = false;
  String? _envBaseUrl;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load from .env file
    _envBaseUrl = dotenv.env['BOCK_FOODS_API_BASE_URL'];
    
    // Load saved value or use env default
    final savedUrl = ApiConfig.baseUrl;
    _ctrl.text = savedUrl ?? _envBaseUrl ?? '';
    
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ApiConfig.saveBaseUrl(_ctrl.text);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  Future<void> _logout() async {
    await BockFoodsAuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BockFoodsLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        title: const Text('Foods Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Configuration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BOCK_FOODS_API_BASE_URL',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (_envBaseUrl != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'From .env: $_envBaseUrl',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      labelText: 'API Base URL',
                      hintText: 'http://localhost:3000 (leave empty to use BockOne login)',
                      helperText: 'Leave empty to use BockOne backend login',
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF6A1B9A), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _saving ? null : _save,
                      child: Text(_saving ? 'Saving...' : 'Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _logout,
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

