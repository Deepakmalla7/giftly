import 'package:giftly/core/models/gift_item.dart';
import 'package:giftly/core/models/review.dart';
import 'package:giftly/core/services/remote/remote_gift_service.dart';

class GiftRepository {
  final RemoteGiftService _remoteGiftService;

  GiftRepository(this._remoteGiftService);

  Future<List<GiftItem>> getRecommendations({
    required String event,
    required String ageGroup,
    required String gender,
    int page = 1,
    int limit = 12,
  }) async {
    return _remoteGiftService.getRecommendations(
      event: event,
      ageGroup: ageGroup,
      gender: gender,
      page: page,
      limit: limit,
    );
  }

  Future<List<GiftItem>> getGifts({
    String? event,
    String? gender,
    double? minPrice,
    double? maxPrice,
  }) async {
    return _remoteGiftService.getGifts(
      event: event,
      gender: gender,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }

  Future<GiftItem> getGiftById(String giftId) async {
    return _remoteGiftService.getGiftById(giftId);
  }

  Future<List<Review>> getGiftReviews(String giftId) async {
    return _remoteGiftService.getGiftReviews(giftId);
  }

  Future<Review> submitReview({
    required String giftId,
    required int rating,
    required String comment,
  }) async {
    return _remoteGiftService.submitReview(
      giftId: giftId,
      rating: rating,
      comment: comment,
    );
  }
}
