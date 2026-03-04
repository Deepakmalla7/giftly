import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/models/gift_item.dart';
import 'package:giftly/core/models/review.dart';
import 'package:giftly/core/providers/service_providers.dart';
import 'package:giftly/core/repositories/gift_repository.dart';

class GiftDetailViewModel extends ChangeNotifier {
  GiftDetailViewModel(this._giftRepository);

  final GiftRepository _giftRepository;

  // Gift state
  GiftItem? _gift;
  GiftItem? get gift => _gift;

  // Reviews state
  final List<Review> _reviews = [];
  List<Review> get reviews => List.unmodifiable(_reviews);

  // Loading states
  bool isLoadingGift = false;
  bool isLoadingReviews = false;
  bool isSubmittingReview = false;

  // Error states
  String? giftError;
  String? reviewsError;
  String? submitError;

  /// Load gift details by ID
  Future<void> loadGiftDetails(String giftId) async {
    isLoadingGift = true;
    giftError = null;
    _gift = null;
    notifyListeners();

    try {
      _gift = await _giftRepository.getGiftById(giftId);
    } catch (e) {
      giftError = e.toString();
    } finally {
      isLoadingGift = false;
      notifyListeners();
    }
  }

  /// Load reviews for the gift
  Future<void> loadReviews(String giftId) async {
    isLoadingReviews = true;
    reviewsError = null;
    _reviews.clear();
    notifyListeners();

    try {
      final fetchedReviews = await _giftRepository.getGiftReviews(giftId);
      _reviews.addAll(fetchedReviews);
    } catch (e) {
      reviewsError = e.toString();
    } finally {
      isLoadingReviews = false;
      notifyListeners();
    }
  }

  /// Submit a new review
  Future<bool> submitReview({
    required String giftId,
    required int rating,
    required String comment,
  }) async {
    isSubmittingReview = true;
    submitError = null;
    notifyListeners();

    try {
      final newReview = await _giftRepository.submitReview(
        giftId: giftId,
        rating: rating,
        comment: comment,
      );
      // Add the new review to the list if it's approved
      if (newReview.status == 'approved') {
        _reviews.insert(0, newReview);
      }
      isSubmittingReview = false;
      notifyListeners();
      return true;
    } catch (e) {
      submitError = e.toString();
      isSubmittingReview = false;
      notifyListeners();
      return false;
    }
  }

  /// Load both gift details and reviews
  Future<void> loadAll(String giftId) async {
    await Future.wait([loadGiftDetails(giftId), loadReviews(giftId)]);
  }

  /// Refresh all data
  Future<void> refresh(String giftId) async {
    await loadAll(giftId);
  }
}

final giftDetailViewModelProvider =
    ChangeNotifierProvider.family<GiftDetailViewModel, String>((ref, giftId) {
      final repo = ref.watch(giftRepositoryProvider);
      final viewModel = GiftDetailViewModel(repo);
      // Load data immediately
      viewModel.loadAll(giftId);
      return viewModel;
    });
