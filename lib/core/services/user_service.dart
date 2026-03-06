import 'package:dio/dio.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/models/user_model.dart';

class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  /// Get user profile by ID
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _apiClient.get('/auth/profile/$userId');

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      throw Exception(
        response.data['message'] ?? 'Failed to fetch user profile',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Update user profile
  Future<UserModel> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? photoPath,
  }) async {
    try {
      FormData formData = FormData();

      if (firstName != null)
        formData.fields.add(MapEntry('firstName', firstName));
      if (lastName != null) formData.fields.add(MapEntry('lastName', lastName));
      if (username != null) formData.fields.add(MapEntry('username', username));
      if (email != null) formData.fields.add(MapEntry('email', email));

      if (photoPath != null) {
        formData.files.add(
          MapEntry(
            'photo',
            await MultipartFile.fromFile(photoPath, filename: 'profile.jpg'),
          ),
        );
      }

      final response = await _apiClient.put('/auth/$userId', data: formData);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to update profile');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Upload user photo
  Future<String> uploadPhoto(String photoPath) async {
    try {
      FormData formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoPath,
          filename: 'profile.jpg',
        ),
      });

      final response = await _apiClient.post(
        '/auth/upload-photo',
        data: formData,
      );

      if (response.data['success'] == true) {
        return response.data['data']['photoUrl'] ?? '';
      }

      throw Exception(response.data['message'] ?? 'Failed to upload photo');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Delete user photo
  Future<void> deletePhoto() async {
    try {
      final response = await _apiClient.delete('/auth/delete-photo');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to delete photo');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Delete user account
  Future<void> deleteAccount(String userId) async {
    try {
      final response = await _apiClient.delete('/auth/$userId');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to delete account');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to send reset email',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Verify OTP
  Future<void> verifyOTP({required String email, required String otp}) async {
    try {
      final response = await _apiClient.post(
        '/auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Invalid OTP');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Reset password with OTP
  Future<void> resetPasswordWithOTP({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/reset-password-otp',
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }
}
