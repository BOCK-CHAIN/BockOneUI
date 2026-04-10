/// Route names for the application
class RouteNames {
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String voterRegistration = '/voter-registration';
  
  // Dashboard routes
  static const String home = '/';
  static const String dashboard = '/dashboard';
  
  // Admin routes
  static const String adminDashboard = '/admin';
  static const String adminElections = '/admin/elections';
  static const String createElection = '/admin/elections/create';
  static const String editElection = '/admin/elections/edit';
  static const String adminUsers = '/admin/users';
  static const String adminResults = '/admin/results';
  
  // Voting routes
  static const String voting = '/voting';
  static const String voteConfirmation = '/vote-confirmation';
  
  // Results routes
  static const String results = '/results';
  static const String resultDetail = '/results/detail';
  
  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  
  // Keys routes
  static const String generateKeys = '/keys/generate';
  static const String keyManagement = '/keys/management';
  
  // Common routes
  static const String error = '/error';
  static const String notFound = '/404';
}