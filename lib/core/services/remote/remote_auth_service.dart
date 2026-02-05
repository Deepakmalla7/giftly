import 'package:dio/dio.dart';
import '../../api/api_client.dart';
import '../network/network_info.dart';

class RemoteAuthService {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  RemoteAuthService(this._apiClient, this._networkInfo);
  //
  //

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Check internet connection first
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        // Store token
        if (data['token'] != null) {
          await _apiClient.setToken(data['token']);
        }
        return data;
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Registration failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    // Check internet connection first
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Store token
        if (data['token'] != null) {
          await _apiClient.setToken(data['token']);
        }
        return data;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Login failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> getProfile({String? userId}) async {
    // Check internet connection first
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      // If userId provided, use it; otherwise just fail gracefully
      if (userId != null && userId.isNotEmpty) {
        final response = await _apiClient.get('/auth/profile/$userId');
        if (response.statusCode == 200) {
          return response.data;
        }
      }

      // Fallback: Try the profile endpoint without ID
      final response = await _apiClient.get('/auth/profile');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 404) {
        // Profile endpoint needs user ID or doesn't exist
        throw Exception('Profile not found. Please provide a valid user ID.');
      }
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to get profile');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String username,
    String? imagePath,
  }) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        if (imagePath != null && imagePath.trim().isNotEmpty)
          'photo': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split(RegExp(r'[\\/]+')).last,
          ),
      });

      final response = await _apiClient.put(
        '/auth/$userId',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to update profile',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (_) {
      // Server may not have a logout endpoint — that's fine
    } finally {
      await _apiClient.removeToken();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null;
  }

  /// Request password reset OTP
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to send reset code',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to send reset code',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  /// Verify the OTP code
  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.post(
        '/auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'OTP verification failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'OTP verification failed',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  /// Reset password using OTP
  Future<Map<String, dynamic>> resetPasswordWithOTP({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.post(
        '/auth/reset-password-otp',
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to reset password',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
