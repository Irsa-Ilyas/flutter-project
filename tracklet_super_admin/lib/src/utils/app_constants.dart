class AppConstants {
  // API Base URL - Update this to match your backend server
  static const String apiBaseUrl = 'http://192.168.0.106:5000';
  
  // API Endpoints
  static const String loginEndpoint = '/api/admin/login';
  static const String generateEmailEndpoint = '/api/admin/generate-email';
  static const String usersEndpoint = '/api/admin/users';
  static const String statsEndpoint = '/api/admin/stats';
  
  // Super Admin Credentials (default)
  static const String defaultAdminEmail = 'agha@tracklet.com';
  static const String defaultAdminPassword = '12345678';
  
  // App Info
  static const String appName = 'TrackLet Super Admin';
  static const String appVersion = '1.0.0';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

