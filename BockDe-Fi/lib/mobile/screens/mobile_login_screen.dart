/*// mobile_login_screen.dart
import 'package:flutter/material.dart';
import 'package:bockchain/mobile/screens/auth_service.dart';
import 'package:bockchain/mobile/screens/mobile_home_screen.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0B90B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'YOUR APP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Main content
              const Text(
                '292,728,891',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF0B90B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'USERS TRUST US',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events, color: Color(0xFFF0B90B), size: 32),
                        const SizedBox(height: 8),
                        const Text(
                          'No.1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Customer Assets',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events, color: Color(0xFFF0B90B), size: 32),
                        const SizedBox(height: 8),
                        const Text(
                          'No.1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Trading Volume',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Bonus banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard, color: Color(0xFFF0B90B)),
                    const SizedBox(width: 12),
                    Text(
                      'Up to \$100 Bonus Only Today',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0B90B),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Bottom links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign up as an entity',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'or',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Color(0xFFF0B90B),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== SIGN UP SCREEN ====================
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_emailController.text.isEmpty || 
        _usernameController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms of Service'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (result['success'] && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Account created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to home screen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MobileHomeScreen(
              username: result['username'] ?? _usernameController.text,
              email: result['email'] ?? _emailController.text,
            ),
          ),
          (route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2329),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2329),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0B90B),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'YOUR APP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF0B90B),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              // Email field
              Text(
                'Email',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF2B3139),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Username field
              Text(
                'Username',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Choose a username',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF2B3139),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Password field
              Text(
                'Password',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Create a password (min. 6 characters)',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF2B3139),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Terms checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (val) => setState(() => _agreedToTerms = val!),
                      activeColor: const Color(0xFFF0B90B),
                      checkColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                        children: const [
                          TextSpan(text: 'By creating an account, I agree to YourApp\'s '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Notice',
                            style: TextStyle(decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0B90B),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade800,
                    disabledForegroundColor: Colors.grey.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Already have account link
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account? Log in',
                    style: TextStyle(
                      color: Color(0xFFF0B90B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== LOGIN SCREEN ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_usernameOrEmailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username/email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.loginWithDetails(
        _usernameOrEmailController.text.trim(),
        _passwordController.text,
      );

      if (result['success'] && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${result['username']}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to home screen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MobileHomeScreen(
              username: result['username'] ?? _usernameOrEmailController.text,
              email: result['email'] ?? '',
            ),
          ),
          (route) => false,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Invalid credentials'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2329),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2329),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0B90B),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'YOUR APP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF0B90B),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              // Username/Email field
              Text(
                'Email/Username',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameOrEmailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your email or username',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF2B3139),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Password field
              Text(
                'Password',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF2B3139),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFF0B90B), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFFF0B90B)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0B90B),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Log In',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Create account link
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create a YourApp Account',
                    style: TextStyle(
                      color: Color(0xFFF0B90B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*import 'package:bockchain/mobile/screens/mobile_home_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';


class MobileLoginScreen extends StatefulWidget {
  final WalletConnectService walletService;
  
  const MobileLoginScreen({Key? key, required this.walletService}) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  bool isLogin = true;
  bool isPasswordVisible = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginIdentifierController = TextEditingController();

  // Neon Database Configuration
  Connection? conn;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    try {
      print('Attempting to connect to database...');
      conn = await Connection.open(
        Endpoint(
          host: 'ep-fancy-truth-a1h9tfj0-pooler.ap-southeast-1.aws.neon.tech',
          database: 'neondb',
          username: 'neondb_owner',
          password: 'npg_JTC25lYjPyBt',             // Your actual password
          port: 5432,
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.require,
          connectTimeout: Duration(seconds: 30),
        ),
      );
      print('Database connected successfully!');
    } catch (e) {
      print('Database connection error: $e');
      conn = null;
    }
  }

  Future<Connection?> getConnection() async {
    try {
      // Always try to create a fresh connection for each operation
      final connection = await Connection.open(
        Endpoint(
          host: 'ep-fancy-truth-a1h9tfj0-pooler.ap-southeast-1.aws.neon.tech',
          database: 'neondb',
          username: 'neondb_owner',
          password: 'npg_JTC25lYjPyBt',
          port: 5432,
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.require,
          connectTimeout: Duration(seconds: 30),
        ),
      );
      return connection;
    } catch (e) {
      print('Connection error: $e');
      return null;
    }
  }

  Future<void> handleSignUp() async {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    Connection? connection;
    try {
      connection = await getConnection();
      
      if (connection == null) {
        showSnackBar('Unable to connect to database. Check your internet connection.');
        setState(() => isLoading = false);
        return;
      }
      
      print('Checking for existing user...');
      // Check if user already exists
      final existingUser = await connection.execute(
        Sql.named(
          'SELECT * FROM users WHERE email = @email OR username = @username',
        ),
        parameters: {
          'email': emailController.text,
          'username': usernameController.text,
        },
      );

      if (existingUser.isNotEmpty) {
        showSnackBar('Email or username already exists');
        setState(() => isLoading = false);
        await connection.close();
        return;
      }

      print('Inserting new user...');
      // Insert new user
      await connection.execute(
        Sql.named(
          'INSERT INTO users (email, username, password) VALUES (@email, @username, @password)',
        ),
        parameters: {
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text, // Hash this in production!
        },
      );

      await connection.close();
      showSnackBar('Account created successfully!');
      setState(() => isLoading = false);
      
      // Navigate to home screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MobileHomeScreen(username: '', email: '',walletService: widget.walletService)),
        );
      }
    } catch (e) {
      print('SignUp Error: $e');
      showSnackBar('Error: ${e.toString().substring(0, 100)}');
      setState(() => isLoading = false);
      if (connection != null) {
        await connection.close();
      }
    }
  }

  Future<void> handleLogin() async {
    if (loginIdentifierController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    Connection? connection;
    try {
      connection = await getConnection();
      
      if (connection == null) {
        showSnackBar('Unable to connect to database. Check your internet connection.');
        setState(() => isLoading = false);
        return;
      }
      
      print('Attempting login...');
      final result = await connection.execute(
        Sql.named(
          'SELECT * FROM users WHERE (email = @identifier OR username = @identifier) AND password = @password',
        ),
        parameters: {
          'identifier': loginIdentifierController.text,
          'password': passwordController.text,
        },
      );

      await connection.close();

      if (result.isNotEmpty) {
        showSnackBar('Login successful!');
        setState(() => isLoading = false);
        
        // Navigate to home screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MobileHomeScreen(username: '', email: '', walletService: widget.walletService)),
          );
        }
      } else {
        showSnackBar('Invalid credentials');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Login Error: $e');
      showSnackBar('Error: ${e.toString().substring(0, 100)}');
      setState(() => isLoading = false);
      if (connection != null) {
        await connection.close();
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void clearFields() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    loginIdentifierController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.currency_bitcoin,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Toggle Buttons
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = true;
                              clearFields();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isLogin
                                  ? const Color.fromARGB(255, 122, 79, 223)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isLogin
                                    ? Colors.white
                                    : const Color(0xFF6B7280),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = false;
                              clearFields();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !isLogin
                                  ? const Color.fromARGB(255, 122, 79, 223)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isLogin
                                    ? Colors.white
                                    : const Color(0xFF6B7280),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Form Fields
                if (isLogin) ...[
                  _buildTextField(
                    controller: loginIdentifierController,
                    hint: 'Email or Username',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 122, 79, 223),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  _buildTextField(
                    controller: emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: usernameController,
                    hint: 'Username',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                ],
                const SizedBox(height: 32),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (isLogin) {
                              handleLogin();
                            } else {
                              handleSignUp();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            isLogin ? 'Log In' : 'Sign Up',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                    /*const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                    ),*/
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                  ],
                ),
                /*const SizedBox(height: 24),
                // Social Login Buttons
                _buildSocialButton(
                  icon: Icons.apple,
                  text: 'Continue with Apple',
                ),
                const SizedBox(height: 12),
                _buildSocialButton(
                  icon: Icons.g_mobiledata,
                  text: 'Continue with Google',
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(color: Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF6B7280),
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF111827)),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    loginIdentifierController.dispose();
    if (conn != null) {
      conn!.close();
    }
    super.dispose();
  }
}*/

/*import 'package:bockchain/mobile/screens/mobile_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({Key? key}) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  bool isLogin = true;
  bool isPasswordVisible = false;
  bool isLoading = false;
  List<CryptoData> cryptoList = [];
  Timer? updateTimer;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginIdentifierController = TextEditingController();

  Connection? conn;

  @override
  void initState() {
    super.initState();
    initDatabase();
    fetchCryptoData();
    updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchCryptoData();
    });
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    loginIdentifierController.dispose();
    if (conn != null) {
      conn!.close();
    }
    super.dispose();
  }

  Future<void> fetchCryptoData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false&price_change_percentage=24h',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            cryptoList = data.map((json) => CryptoData.fromJson(json)).toList();
          });
        }
      }
    } catch (e) {
      print('Error fetching crypto data: $e');
    }
  }

  Future<void> initDatabase() async {
    try {
      print('Attempting to connect to database...');
      conn = await Connection.open(
        Endpoint(
          host: 'ep-fancy-truth-a1h9tfj0-pooler.ap-southeast-1.aws.neon.tech',
          database: 'neondb',
          username: 'neondb_owner',
          password: 'npg_JTC25lYjPyBt',
          port: 5432,
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.require,
          connectTimeout: Duration(seconds: 30),
        ),
      );
      print('Database connected successfully!');
    } catch (e) {
      print('Database connection error: $e');
      conn = null;
    }
  }

  Future<Connection?> getConnection() async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: 'ep-fancy-truth-a1h9tfj0-pooler.ap-southeast-1.aws.neon.tech',
          database: 'neondb',
          username: 'neondb_owner',
          password: 'npg_JTC25lYjPyBt',
          port: 5432,
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.require,
          connectTimeout: Duration(seconds: 30),
        ),
      );
      return connection;
    } catch (e) {
      print('Connection error: $e');
      return null;
    }
  }

  Future<void> handleSignUp() async {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    Connection? connection;
    try {
      connection = await getConnection();

      if (connection == null) {
        showSnackBar('Unable to connect to database. Check your internet connection.');
        setState(() => isLoading = false);
        return;
      }

      print('Checking for existing user...');
      final existingUser = await connection.execute(
        Sql.named(
          'SELECT * FROM users WHERE email = @email OR username = @username',
        ),
        parameters: {
          'email': emailController.text,
          'username': usernameController.text,
        },
      );

      if (existingUser.isNotEmpty) {
        showSnackBar('Email or username already exists');
        setState(() => isLoading = false);
        await connection.close();
        return;
      }

      print('Inserting new user...');
      await connection.execute(
        Sql.named(
          'INSERT INTO users (email, username, password) VALUES (@email, @username, @password)',
        ),
        parameters: {
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      await connection.close();
      showSnackBar('Account created successfully!');
      setState(() => isLoading = false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MobileHomeScreen(username: '', email: '',)),
        );
      }
    } catch (e) {
      print('SignUp Error: $e');
      showSnackBar('Error: ${e.toString().substring(0, 100)}');
      setState(() => isLoading = false);
      if (connection != null) {
        await connection.close();
      }
    }
  }

  Future<void> handleLogin() async {
    if (loginIdentifierController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    Connection? connection;
    try {
      connection = await getConnection();

      if (connection == null) {
        showSnackBar('Unable to connect to database. Check your internet connection.');
        setState(() => isLoading = false);
        return;
      }

      print('Attempting login...');
      final result = await connection.execute(
        Sql.named(
          'SELECT * FROM users WHERE (email = @identifier OR username = @identifier) AND password = @password',
        ),
        parameters: {
          'identifier': loginIdentifierController.text,
          'password': passwordController.text,
        },
      );

      await connection.close();

      if (result.isNotEmpty) {
        showSnackBar('Login successful!');
        setState(() => isLoading = false);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MobileHomeScreen(username: '', email: '',)),
          );
        }
      } else {
        showSnackBar('Invalid credentials');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Login Error: $e');
      showSnackBar('Error: ${e.toString().substring(0, 100)}');
      setState(() => isLoading = false);
      if (connection != null) {
        await connection.close();
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void clearFields() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    loginIdentifierController.clear();
  }

  void showAuthDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isLogin ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isLogin ? Colors.white : Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isLogin ? const Color.fromARGB(255, 122, 79, 223) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Sign Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isLogin ? Colors.white : Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (isLogin) ...[
                    _buildTextField(
                      controller: loginIdentifierController,
                      hint: 'Email or Username',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                  ] else ...[
                    _buildTextField(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: usernameController,
                      hint: 'Username',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (isLogin) {
                                handleLogin();
                              } else {
                                handleSignUp();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              isLogin ? 'Log In' : 'Sign Up',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 79, 223),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.currency_bitcoin,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'BOCK De-Fi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF111827)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Stats Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 122, 79, 223), Color.fromARGB(255, 122, 79, 223)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    '292,728,891',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'USERS TRUST US',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'No.1',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Customer Assets',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'No.1',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Trading Volume',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bonus Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard, color: Color.fromARGB(255, 122, 79, 223)),
                  const SizedBox(width: 12),
                  const Text(
                    'Up to \$100 Bonus Only Today',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Sign Up Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: showAuthDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Popular',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'New Listing',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Crypto List
            Expanded(
              child: cryptoList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 122, 79, 223),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: cryptoList.length,
                      itemBuilder: (context, index) {
                        return _buildCryptoTile(cryptoList[index]);
                      },
                    ),
            ),
            // View All Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'View All 350+ Coins →',
                  style: TextStyle(
                    color: Color.fromARGB(255, 122, 79, 223),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(color: Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF6B7280),
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCryptoTile(CryptoData crypto) {
    final isPositive = crypto.priceChange24h >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                crypto.symbol.toUpperCase().substring(0, 1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 122, 79, 223),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crypto.symbol.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  crypto.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\${crypto.currentPrice.toStringAsFixed(crypto.currentPrice > 100 ? 2 : 4)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${crypto.priceChange24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CryptoData {
  final String id;
  final String symbol;
  final String name;
  final double currentPrice;
  final double priceChange24h;

  CryptoData({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.priceChange24h,
  });

  factory CryptoData.fromJson(Map<String, dynamic> json) {
    return CryptoData(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
    );
  }
}*/

import 'package:bockchain/mobile/screens/mobile_home_screen.dart';
import 'package:bockchain/mobile/screens/wallet_connect_service.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class MobileLoginScreen extends StatefulWidget {
  final WalletService walletService;
  
  const MobileLoginScreen({Key? key, required this.walletService}) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  bool isLogin = true;
  bool isPasswordVisible = false;
  bool isLoading = false;
  List<String> debugLogs = [];
  bool showDebugPanel = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginIdentifierController = TextEditingController();

  final WalletService _walletService = WalletService();

  void addDebugLog(String message) {
    setState(() {
      debugLogs.add('${DateTime.now().toString().substring(11, 19)} - $message');
      if (debugLogs.length > 50) {
        debugLogs.removeAt(0);
      }
    });
    print(message);
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Connection?> getConnection() async {
    try {
      addDebugLog('🔄 Connecting to database...');
      final connection = await Connection.open(
        Endpoint(
          host: 'ep-fancy-truth-a1h9tfj0-pooler.ap-southeast-1.aws.neon.tech',
          database: 'neondb',
          username: 'neondb_owner',
          password: 'npg_JTC25lYjPyBt',
          port: 5432,
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.require,
          connectTimeout: Duration(seconds: 30),
        ),
      );
      addDebugLog('✅ Database connected!');
      return connection;
    } catch (e) {
      addDebugLog('❌ Connection failed: $e');
      return null;
    }
  }

  Future<void> testDatabaseConnection() async {
    setState(() => debugLogs.clear());
    addDebugLog('=== DATABASE TEST START ===');
    
    final connection = await getConnection();
    
    if (connection == null) {
      addDebugLog('❌ Cannot connect');
      showSnackBar('Connection failed - check debug logs');
      return;
    }

    try {
      addDebugLog('Testing query...');
      final result = await connection.execute('SELECT NOW()');
      addDebugLog('✅ Query works! Time: ${result.first[0]}');
      
      addDebugLog('Checking users table...');
      final tableCheck = await connection.execute(
        "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users')"
      );
      final exists = tableCheck.first[0];
      addDebugLog('Users table exists: $exists');
      
      if (exists == true) {
        final structure = await connection.execute(
          "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users'"
        );
        addDebugLog('Table columns:');
        for (var row in structure) {
          addDebugLog('  - ${row[0]}: ${row[1]}');
        }
        
        final count = await connection.execute('SELECT COUNT(*) FROM users');
        addDebugLog('Total users: ${count.first[0]}');
      }
      
      await connection.close();
      addDebugLog('=== TEST COMPLETE ===');
      showSnackBar('Test complete! Check debug panel');
    } catch (e) {
      addDebugLog('❌ Query error: $e');
      await connection.close();
      showSnackBar('Query failed - check debug logs');
    }
  }

  Future<void> handleSignUp() async {
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    addDebugLog('=== SIGNUP START ===');
    addDebugLog('Email: $email');
    addDebugLog('Username: $username');
    addDebugLog('Password length: ${password.length}');

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    Connection? connection;
    try {
      // Generate wallet
      addDebugLog('🔑 Generating wallet...');
      final walletData = await _walletService.generateWallet();
      addDebugLog('✅ Wallet generated: ${walletData['address']}');
      
      connection = await getConnection();
      
      if (connection == null) {
        addDebugLog('❌ No connection');
        showSnackBar('Cannot connect to database');
        setState(() => isLoading = false);
        return;
      }
      
      addDebugLog('Checking existing user...');
      final existingUser = await connection.execute(
        Sql.named(
          'SELECT * FROM users WHERE email = @email OR username = @username',
        ),
        parameters: {
          'email': email,
          'username': username,
        },
      );

      addDebugLog('Found ${existingUser.length} existing users');

      if (existingUser.isNotEmpty) {
        showSnackBar('Email or username already exists');
        addDebugLog('❌ User already exists');
        setState(() => isLoading = false);
        await connection.close();
        return;
      }

      addDebugLog('Inserting user...');
      final hashedPassword = hashPassword(password);
      addDebugLog('Password hashed: ${hashedPassword.substring(0, 10)}...');
      
      // Insert user with wallet info
      final insertResult = await connection.execute(
        Sql.named(
          'INSERT INTO users (email, username, password, wallet_address, private_key, mnemonic) VALUES (@email, @username, @password, @wallet_address, @private_key, @mnemonic)',
        ),
        parameters: {
          'email': email,
          'username': username,
          'password': hashedPassword,
          'wallet_address': walletData['address'],
          'private_key': walletData['privateKey'],
          'mnemonic': walletData['mnemonic'],
        },
      );

      addDebugLog('✅ Insert OK! Rows: ${insertResult.affectedRows}');
      await connection.close();
      
      showSnackBar('Account created with wallet!');
      setState(() => isLoading = false);
      addDebugLog('=== SIGNUP COMPLETE ===');
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MobileHomeScreen(
              username: username,
              email: email,
              walletService: widget.walletService,
              walletAddress: walletData['address']!,
              privateKey: walletData['privateKey']!,
            )
          ),
        );
      }
    } catch (e) {
      addDebugLog('❌ Signup error: $e');
      showSnackBar('Signup failed - check debug');
      setState(() => isLoading = false);
      if (connection != null) {
        await connection.close();
      }
    }
  }

  Future<void> handleLogin() async {
    final identifier = loginIdentifierController.text.trim();
    final password = passwordController.text.trim();

    addDebugLog('=== LOGIN START ===');
    addDebugLog('Identifier: $identifier');
    addDebugLog('Password length: ${password.length}');

    if (identifier.isEmpty || password.isEmpty) {
      showSnackBar('Please fill all fields');
      return;
    }

    setState(() => isLoading = true);

    Connection? connection;
    try {
      connection = await getConnection();
      
      if (connection == null) {
        addDebugLog('❌ No connection');
        showSnackBar('Cannot connect to database');
        setState(() => isLoading = false);
        return;
      }
      
      addDebugLog('Querying user...');
      final hashedPassword = hashPassword(password);
      addDebugLog('Password hashed: ${hashedPassword.substring(0, 10)}...');
      
      final result = await connection.execute(
        Sql.named(
          'SELECT email, username, wallet_address, private_key FROM users WHERE (email = @identifier OR username = @identifier) AND password = @password',
        ),
        parameters: {
          'identifier': identifier,
          'password': hashedPassword,
        },
      );

      addDebugLog('Found ${result.length} matching users');

      await connection.close();

      if (result.isNotEmpty) {
        final row = result.first;
        final email = row[0] as String;
        final username = row[1] as String;
        final walletAddress = row[2] as String;
        final privateKey = row[3] as String;
        
        addDebugLog('✅ Login success!');
        addDebugLog('Email: $email');
        addDebugLog('Username: $username');
        addDebugLog('Wallet: ${walletAddress.substring(0, 10)}...');
        
        showSnackBar('Login successful!');
        setState(() => isLoading = false);
        addDebugLog('=== LOGIN COMPLETE ===');
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MobileHomeScreen(
                username: username,
                email: email,
                walletService: widget.walletService,
                walletAddress: walletAddress,
                privateKey: privateKey,
              )
            ),
          );
        }
      } else {
        addDebugLog('❌ No matching user found');
        showSnackBar('Invalid credentials');
        setState(() => isLoading = false);
      }
    } catch (e) {
      addDebugLog('❌ Login error: $e');
      showSnackBar('Login failed - check debug');
      setState(() => isLoading = false);
      if (connection != null) {
        await connection.close();
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 122, 79, 223),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void clearFields() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    loginIdentifierController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.currency_bitcoin,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*TextButton.icon(
                          onPressed: testDatabaseConnection,
                          icon: const Icon(Icons.wifi_find, size: 16),
                          label: const Text('Test DB'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),*/
                        const SizedBox(width: 8),
                        /*TextButton.icon(
                          onPressed: () {
                            setState(() => showDebugPanel = !showDebugPanel);
                          },
                          icon: Icon(
                            showDebugPanel ? Icons.visibility_off : Icons.visibility,
                            size: 16,
                          ),
                          label: Text(showDebugPanel ? 'Hide Logs' : 'Show Logs'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),*/
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLogin = true;
                                  clearFields();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: isLogin
                                      ? const Color.fromARGB(255, 122, 79, 223)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Log In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isLogin
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLogin = false;
                                  clearFields();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: !isLogin
                                      ? const Color.fromARGB(255, 122, 79, 223)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: !isLogin
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (isLogin) ...[
                      _buildTextField(
                        controller: loginIdentifierController,
                        hint: 'Email or Username',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 122, 79, 223),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      _buildTextField(
                        controller: emailController,
                        hint: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: usernameController,
                        hint: 'Username',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (isLogin) {
                                  handleLogin();
                                } else {
                                  handleSignUp();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 122, 79, 223),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : Text(
                                isLogin ? 'Log In' : 'Sign Up',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showDebugPanel)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.95),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 122, 79, 223),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Debug Logs',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                                  onPressed: () => setState(() => debugLogs.clear()),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () => setState(() => showDebugPanel = false),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: debugLogs.isEmpty
                            ? const Center(
                                child: Text(
                                  'No logs yet. Click "Test DB" to start.',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: debugLogs.length,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  final log = debugLogs[debugLogs.length - 1 - index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      log,
                                      style: TextStyle(
                                        color: log.contains('❌')
                                            ? Colors.red
                                            : log.contains('✅')
                                                ? Colors.green
                                                : log.contains('🔄')
                                                    ? Colors.orange
                                                    : Colors.white,
                                        fontSize: 11,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        style: const TextStyle(color: Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF6B7280),
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    loginIdentifierController.dispose();
    _walletService.dispose();
    super.dispose();
  }
}