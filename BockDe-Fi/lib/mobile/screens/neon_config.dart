class NeonConfig {
  // Replace these with your actual Neon database credentials
  static const String host = 'ep-fancy-truth-a1h9tfj0-pooler.ap-southeast-1.aws.neon.tech';
  static const String directHost = 'ep-fancy-truth-a1h9tfj0.ap-southeast-1.aws.neon.tech';
  static const int port = 5432;
  static const String database = 'neondb';
  static const String username = 'neondb_owner';
  static const String password = 'npg_JTC25lYjPyBt';
  
  static Map<String, dynamic> getConnectionConfig() {
    return {
      'host': host,
      'hosts': [host, directHost],
      'port': port,
      'database': database,
      'username': username,
      'password': password,
      'requireSsl': true, // Neon requires SSL
    };
  }
}