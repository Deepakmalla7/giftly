class ApiEndpoints {
  // 🔁 MANUAL SWITCH
  // true  = Emulator
  // false = Physical device
  static const bool useEmulator = false;

  // 🌐 Base URL
  static String get baseUrl {
    if (useEmulator) {
      // Android Emulator
      return 'http://10.0.2.2:5000/api';
    } else {
      // Physical device (Android)
      return 'http://192.168.1.149:5000/api'; // 🔴 Your PC IP
    }
  }

  static String get serverRoot {
    return baseUrl.replaceAll('/api', '');
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOTP = '/auth/verify-otp';
  static const String resetPasswordOTP = '/auth/reset-password-otp';

  // User endpoints
  static const String userProfile = '/auth/profile';
  static const String uploadPhoto = '/auth/upload-photo';
  static const String deletePhoto = '/auth/delete-photo';

  // Gift endpoints
  static const String gifts = '/gifts';
  static const String giftFilter = '/gifts/filter';
  static const String giftRecommendations = '/gifts/recommendations';
  static const String giftPreferences = '/gifts/preferences';

  // Cart endpoints
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static const String cartPromo = '/cart/promo';
  static const String cartClear = '/cart/clear';

  // Favorites endpoints
  static const String favorites = '/favorites';
  static const String favoritesClear = '/favorites/clear';

  // Review endpoints
  static const String reviews = '/reviews';
  static const String myReviews = '/reviews/my';
}
