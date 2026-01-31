import 'package:dio/dio.dart';
import '../../api/api_client.dart';
import '../network/network_info.dart';

class RemoteAuthService {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  RemoteAuthService(this._apiClient, this._networkInfo);

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
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
        data: {'name': name, 'email': email, 'password': password},
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

  Future<Map<String, dynamic>> getProfile() async {
    // Check internet connection first
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.get('/auth/profile');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get profile');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to get profile');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
      await _apiClient.removeToken();
    } catch (_) {
      // Even if the server request fails, remove the local token
      await _apiClient.removeToken();
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null;
  }
}
