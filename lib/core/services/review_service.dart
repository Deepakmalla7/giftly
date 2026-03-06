import 'package:dio/dio.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/models/review_model.dart';

class ReviewService {
  final ApiClient _apiClient;

  ReviewService(this._apiClient);

  /// Create a review
  Future<ReviewModel> createReview({
    required String giftId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _apiClient.post(
        '/reviews',
        data: {'giftId': giftId, 'rating': rating, 'comment': comment},
      );

      if (response.data['success'] == true) {
        return ReviewModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to create review');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Get user's reviews
  Future<List<ReviewModel>> getMyReviews() async {
    try {
      final response = await _apiClient.get('/reviews/my');

      if (response.data['success'] == true) {
        final List reviewsJson = response.data['data'] ?? [];
        return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch reviews');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Get reviews for a specific gift
  Future<List<ReviewModel>> getGiftReviews(String giftId) async {
    try {
      final response = await _apiClient.get('/reviews/gift/$giftId');

      if (response.data['success'] == true) {
        final List reviewsJson = response.data['data'] ?? [];
        return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
      }

      throw Exception(
        response.data['message'] ?? 'Failed to fetch gift reviews',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Update review
  Future<ReviewModel> updateReview({
    required String reviewId,
    int? rating,
    String? comment,
  }) async {
    try {
      final response = await _apiClient.put(
        '/reviews/$reviewId',
        data: {
          if (rating != null) 'rating': rating,
          if (comment != null) 'comment': comment,
        },
      );

      if (response.data['success'] == true) {
        return ReviewModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to update review');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      final response = await _apiClient.delete('/reviews/$reviewId');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to delete review');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }
}
