import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/models/gift_item.dart';
import 'package:giftly/core/providers/service_providers.dart';
import 'package:giftly/core/repositories/gift_repository.dart';

class GiftRecommendationViewModel extends ChangeNotifier {
  GiftRecommendationViewModel(this._giftRepository);

  final GiftRepository _giftRepository;

  final List<GiftItem> _gifts = [];
  List<GiftItem> get gifts => List.unmodifiable(_gifts);

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? errorMessage;

  String event = 'Birthday';
  String ageGroup = 'Adult';
  String gender = 'Unisex';

  int _page = 1;
  final int _limit = 12;

  Future<void> loadInitial() async {
    _page = 1;
    hasMore = true;
    errorMessage = null;
    isLoading = true;
    _gifts.clear();
    notifyListeners();

    await _fetchPage();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoading || isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    notifyListeners();

    await _fetchPage();

    isLoadingMore = false;
    notifyListeners();
  }

  void setFilters({
    required String event,
    required String ageGroup,
    required String gender,
  }) {
    this.event = event;
    this.ageGroup = ageGroup;
    this.gender = gender;
    notifyListeners();
  }

  void updateFilters({
    required String event,
    required String ageGroup,
    required String gender,
  }) {
    this.event = event;
    this.ageGroup = ageGroup;
    this.gender = gender;
    loadInitial();
  }

  Future<void> _fetchPage() async {
    try {
      final results = await _giftRepository.getRecommendations(
        event: event,
        ageGroup: ageGroup,
        gender: gender,
        page: _page,
        limit: _limit,
      );

      _gifts.addAll(results);
      if (results.length < _limit) {
        hasMore = false;
      } else {
        _page += 1;
      }
    } catch (e) {
      errorMessage = e.toString();
      hasMore = false;
    }
  }
}

final giftRecommendationViewModelProvider =
    ChangeNotifierProvider<GiftRecommendationViewModel>((ref) {
      final repo = ref.watch(giftRepositoryProvider);
      return GiftRecommendationViewModel(repo);
    });
