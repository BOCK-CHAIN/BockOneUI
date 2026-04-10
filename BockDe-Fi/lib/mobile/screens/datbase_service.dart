import 'package:postgres/postgres.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:bockchain/mobile/screens/neon_config.dart';

class DatabaseService {
  static Connection? _connection;

// Fixed getConnection method for database_service.dart

static Future<Connection> getConnection() async {
  // Return existing connection if it's still open
  if (_connection != null && _connection!.isOpen) {
    return _connection!;
  }

  final config = NeonConfig.getConnectionConfig();

  final String host = (config['host'] as String?) ?? '';
  final List<dynamic>? hostsDyn = config['hosts'] as List<dynamic>?;
  final List<String> hosts = [
    if (host.isNotEmpty) host,
    ...?hostsDyn?.whereType<String>(),
  ].toSet().toList();
  final int port = (config['port'] as int?) ?? 5432;
  final String database = (config['database'] as String?) ?? '';
  final String username = (config['username'] as String?) ?? '';
  final String password = (config['password'] as String?) ?? '';

  Future<Connection> openWithHostPort(String h, int p) {
    return Connection.open(
      Endpoint(
        host: h,
        port: p,
        database: database,
        username: username,
        password: password,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
        connectTimeout: Duration(seconds: 30),
        queryTimeout: Duration(seconds: 30),
      ),
    );
  }

  // Try a small set of host/port combos. Some networks block/resolve pooler differently.
  final candidatePorts = <int>[port, 5432, 6543].toSet().toList();
  final candidateHosts = hosts.isNotEmpty ? hosts : [host];

  Object? lastError;
  for (final h in candidateHosts) {
    if (h.trim().isEmpty) continue;
    for (final p in candidatePorts) {
      try {
        _connection = await openWithHostPort(h, p);
        return _connection!;
      } catch (err) {
        lastError = err;
        _connection = null;
      }
    }
  }

  throw Exception('Failed to connect to Neon Postgres. Last error: $lastError');
}

  // Close database connection
  static Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }

  // Initialize database tables
  static Future<void> initializeTables() async {
    final conn = await getConnection();

    // Create users table
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    print('✅ Database tables initialized successfully');
  }

  // Hash password using SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Register new user
  static Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final conn = await getConnection();
      final passwordHash = hashPassword(password);

      await conn.execute(
        Sql.named('''
        INSERT INTO users (username, email, password_hash)
        VALUES (@username, @email, @passwordHash)
        '''),
        parameters: {
          'username': username,
          'email': email,
          'passwordHash': passwordHash,
        },
      );

      print('✅ User registered successfully: $username');
      return true;
    } catch (e) {
      print('❌ Registration error: $e');
      return false;
    }
  }

  // Login user with username or email
  static Future<Map<String, dynamic>?> loginUser({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final conn = await getConnection();
      final passwordHash = hashPassword(password);

      final results = await conn.execute(
        Sql.named('''
        SELECT id, username, email, created_at
        FROM users
        WHERE (username = @usernameOrEmail OR email = @usernameOrEmail)
        AND password_hash = @passwordHash
        LIMIT 1
        '''),
        parameters: {
          'usernameOrEmail': usernameOrEmail,
          'passwordHash': passwordHash,
        },
      );

      if (results.isEmpty) {
        print('❌ Invalid credentials for: $usernameOrEmail');
        return null;
      }

      final row = results.first;
      print('✅ Login successful: ${row[1]}');
      return {
        'id': row[0],
        'username': row[1],
        'email': row[2],
        'created_at': row[3],
      };
    } catch (e) {
      print('❌ Login error: $e');
      return null;
    }
  }

  // Check if username exists
  static Future<bool> usernameExists(String username) async {
    try {
      final conn = await getConnection();
      final results = await conn.execute(
        Sql.named('SELECT id FROM users WHERE username = @username LIMIT 1'),
        parameters: {'username': username},
      );
      return results.isNotEmpty;
    } catch (e) {
      print('❌ Error checking username: $e');
      return false;
    }
  }

  // Check if email exists
  static Future<bool> emailExists(String email) async {
    try {
      final conn = await getConnection();
      final results = await conn.execute(
        Sql.named('SELECT id FROM users WHERE email = @email LIMIT 1'),
        parameters: {'email': email},
      );
      return results.isNotEmpty;
    } catch (e) {
      print('❌ Error checking email: $e');
      return false;
    }
  }

  // Get user by ID
  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      final conn = await getConnection();
      final results = await conn.execute(
        Sql.named('''
        SELECT id, username, email, created_at
        FROM users
        WHERE id = @userId
        LIMIT 1
        '''),
        parameters: {'userId': userId},
      );

      if (results.isEmpty) {
        return null;
      }

      final row = results.first;
      return {
        'id': row[0],
        'username': row[1],
        'email': row[2],
        'created_at': row[3],
      };
    } catch (e) {
      print('❌ Error getting user: $e');
      return null;
    }
  }

  // Update password
  static Future<bool> updatePassword({
    required int userId,
    required String newPassword,
  }) async {
    try {
      final conn = await getConnection();
      final passwordHash = hashPassword(newPassword);

      await conn.execute(
        Sql.named('''
        UPDATE users
        SET password_hash = @passwordHash, updated_at = CURRENT_TIMESTAMP
        WHERE id = @userId
        '''),
        parameters: {
          'userId': userId,
          'passwordHash': passwordHash,
        },
      );

      print('✅ Password updated successfully for user ID: $userId');
      return true;
    } catch (e) {
      print('❌ Error updating password: $e');
      return false;
    }
  }

  // Delete user (optional - use with caution)
  static Future<bool> deleteUser(int userId) async {
    try {
      final conn = await getConnection();
      await conn.execute(
        Sql.named('DELETE FROM users WHERE id = @userId'),
        parameters: {'userId': userId},
      );
      print('✅ User deleted successfully: $userId');
      return true;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }

  // Get all users (for admin purposes)
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final conn = await getConnection();
      final results = await conn.execute(
        'SELECT id, username, email, created_at FROM users ORDER BY created_at DESC',
      );

      return results.map((row) {
        return {
          'id': row[0],
          'username': row[1],
          'email': row[2],
          'created_at': row[3],
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting all users: $e');
      return [];
    }
  }
}
