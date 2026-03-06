import 'package:dio/dio.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/models/gift_model.dart';

class GiftService {
  final ApiClient _apiClient;

  GiftService(this._apiClient);

  /// Get all gifts
  Future<List<GiftModel>> getAllGifts({int? page, int? limit}) async {
    try {
      final response = await _apiClient.get(
        '/gifts',
        queryParameters: {
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
        },
      );

      if (response.data['success'] == true) {
        final List giftsJson = response.data['data'] ?? [];
        return giftsJson.map((json) => GiftModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch gifts');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Get gift by ID
  Future<GiftModel> getGiftById(String id) async {
    try {
      final response = await _apiClient.get('/gifts/$id');

      if (response.data['success'] == true) {
        return GiftModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch gift');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Filter gifts
  Future<List<GiftModel>> filterGifts({
    String? category,
    String? ageRange,
    String? event,
    String? gender,
    String? priceRange,
  }) async {
    try {
      final response = await _apiClient.get(
        '/gifts/filter',
        queryParameters: {
          if (category != null) 'category': category,
          if (ageRange != null) 'ageRange': ageRange,
          if (event != null) 'event': event,
          if (gender != null) 'gender': gender,
          if (priceRange != null) 'price': priceRange,
        },
      );

      if (response.data['success'] == true) {
        final List giftsJson = response.data['data'] ?? [];
        return giftsJson.map((json) => GiftModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to filter gifts');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Get gift recommendations
  Future<List<GiftModel>> getRecommendations({
    required int age,
    required String event,
    required String gender,
  }) async {
    try {
      final response = await _apiClient.get(
        '/gifts/recommendations',
        queryParameters: {'age': age, 'event': event, 'gender': gender},
      );

      if (response.data['success'] == true) {
        final List giftsJson = response.data['data'] ?? [];
        return giftsJson.map((json) => GiftModel.fromJson(json)).toList();
      }

      throw Exception(
        response.data['message'] ?? 'Failed to get recommendations',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Update user preferences
  Future<void> updatePreferences({
    required int age,
    required String event,
    required String gender,
  }) async {
    try {
      final response = await _apiClient.post(
        '/gifts/preferences',
        data: {'age': age, 'event': event, 'gender': gender},
      );

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to update preferences',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }
}
