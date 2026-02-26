import 'package:dio/dio.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/models/favorite_model.dart';

class FavoriteService {
  final ApiClient _apiClient;

  FavoriteService(this._apiClient);

  /// Get user's favorites
  Future<FavoriteModel> getFavorites() async {
    try {
      final response = await _apiClient.get('/favorites');

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          return FavoriteModel.fromJson(data);
        } else if (data is List) {
          return FavoriteModel(
            id: '',
            userId: '',
            items: data
                .whereType<Map<String, dynamic>>()
                .map((item) => FavoriteItemModel.fromJson(item))
                .toList(),
          );
        }
        return FavoriteModel(id: '', userId: '', items: []);
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch favorites');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Add gift to favorites
  Future<FavoriteModel> addFavorite(String giftId) async {
    try {
      final response = await _apiClient.post(
        '/favorites',
        data: {'giftId': giftId},
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          return FavoriteModel.fromJson(data);
        } else if (data is List) {
          return FavoriteModel(
            id: '',
            userId: '',
            items: data
                .whereType<Map<String, dynamic>>()
                .map((item) => FavoriteItemModel.fromJson(item))
                .toList(),
          );
        }
        return FavoriteModel(id: '', userId: '', items: []);
      }

      throw Exception(response.data['message'] ?? 'Failed to add to favorites');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Remove gift from favorites
  Future<FavoriteModel> removeFavorite(String itemId) async {
    try {
      final response = await _apiClient.delete('/favorites/$itemId');

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          return FavoriteModel.fromJson(data);
        } else if (data is List) {
          return FavoriteModel(
            id: '',
            userId: '',
            items: data
                .whereType<Map<String, dynamic>>()
                .map((item) => FavoriteItemModel.fromJson(item))
                .toList(),
          );
        }
        return FavoriteModel(id: '', userId: '', items: []);
      }

      throw Exception(
        response.data['message'] ?? 'Failed to remove from favorites',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Clear all favorites
  Future<void> clearFavorites() async {
    try {
      final response = await _apiClient.post('/favorites/clear');

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to clear favorites',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }
}
