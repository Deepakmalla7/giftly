import 'package:dio/dio.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/api/api_endpoints.dart';
import 'package:giftly/core/services/network/network_info.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  AuthRemoteDataSource({
    required ApiClient apiClient,
    required NetworkInfo networkInfo,
  }) : _apiClient = apiClient,
       _networkInfo = networkInfo;

  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw Exception('No internet connection');
    }

    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error during registration');
    }
  }

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw Exception('No internet connection');
    }

    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error during login');
    }
  }

  Future<dynamic> getProfile(String token) async {
    if (!await _networkInfo.isConnected) {
      throw Exception('No internet connection');
    }

    try {
      final response = await _apiClient.get(
        ApiEndpoints.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch profile');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error fetching profile');
    }
  }

  Future<void> logout(String token) async {
    if (!await _networkInfo.isConnected) {
      throw Exception('No internet connection');
    }

    try {
      await _apiClient.post(
        ApiEndpoints.logout,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error during logout');
    }
  }
}
