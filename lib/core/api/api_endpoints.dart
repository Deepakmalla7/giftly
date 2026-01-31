class ApiEndpoints {
  static const String baseUrl = 'http://localhost:3000/api';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';

  // User endpoints
  static const String userProfile = '/user/profile';
}
