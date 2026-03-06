import 'package:dio/dio.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/api/api_endpoints.dart';
import 'package:giftly/core/models/gift_item.dart';
import 'package:giftly/core/models/review.dart';
import 'package:giftly/core/services/network/network_info.dart';

class RemoteGiftService {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  RemoteGiftService(this._apiClient, this._networkInfo);

  Future<List<GiftItem>> getRecommendations({
    required String event,
    required String ageGroup,
    required String gender,
    int page = 1,
    int limit = 12,
  }) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    final queryParameters = <String, dynamic>{
      'event': event.trim().toLowerCase(),
      'ageGroup': ageGroup.trim().toLowerCase(),
      'gender': gender.trim().toLowerCase(),
      'page': page,
      'limit': limit,
    };

    try {
      final response = await _apiClient.get(
        ApiEndpoints.giftRecommendations,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final list = data is Map<String, dynamic> ? data['data'] : null;
        if (list is List) {
          return list
              .map((item) => GiftItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch recommendations',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to fetch recommendations',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<GiftItem>> getGifts({
    String? event,
    String? gender,
    double? minPrice,
    double? maxPrice,
  }) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    final queryParameters = <String, dynamic>{};
    if (event != null && event.trim().isNotEmpty) {
      queryParameters['event'] = event.trim().toLowerCase();
    }
    if (gender != null && gender.trim().isNotEmpty) {
      queryParameters['gender'] = gender.trim().toLowerCase();
    }
    if (minPrice != null) {
      queryParameters['minPrice'] = minPrice;
    }
    if (maxPrice != null) {
      queryParameters['maxPrice'] = maxPrice;
    }

    try {
      final response = await _apiClient.get(
        ApiEndpoints.gifts,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final list = data is Map<String, dynamic> ? data['data'] : null;
        if (list is List) {
          return list
              .map((item) => GiftItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch gifts');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to fetch gifts');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<GiftItem> getGiftById(String giftId) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.get('${ApiEndpoints.gifts}/$giftId');

      if (response.statusCode == 200) {
        final data = response.data;
        final giftData = data is Map<String, dynamic> ? data['data'] : null;
        if (giftData is Map<String, dynamic>) {
          return GiftItem.fromJson(giftData);
        }
        throw Exception('Invalid gift data');
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch gift details',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to fetch gift details',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Review>> getGiftReviews(String giftId) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.reviews}/gift/$giftId',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final list = data is Map<String, dynamic> ? data['data'] : null;
        if (list is List) {
          return list
              .map((item) => Review.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch reviews');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to fetch reviews',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Review> submitReview({
    required String giftId,
    required int rating,
    required String comment,
  }) async {
    final hasInternet = await _networkInfo.isConnected;
    if (!hasInternet) {
      throw Exception(
        'No internet connection. Please check your connection and try again.',
      );
    }

    if (rating < 1 || rating > 5) {
      throw Exception('Rating must be between 1 and 5');
    }

    if (comment.trim().isEmpty || comment.length < 3) {
      throw Exception('Comment must be at least 3 characters long');
    }

    if (comment.length > 1000) {
      throw Exception('Comment cannot exceed 1000 characters');
    }

    try {
      final response = await _apiClient.post(
        ApiEndpoints.reviews,
        data: {'giftId': giftId, 'rating': rating, 'comment': comment.trim()},
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final reviewData = data is Map<String, dynamic> ? data['data'] : null;
        if (reviewData is Map<String, dynamic>) {
          return Review.fromJson(reviewData);
        }
        throw Exception('Invalid review data');
      } else {
        throw Exception(response.data['message'] ?? 'Failed to submit review');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response!.data['message'] ?? 'Failed to submit review',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
