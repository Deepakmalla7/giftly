import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/services/gift_service.dart';
import 'package:giftly/core/services/cart_service.dart';
import 'package:giftly/core/services/favorite_service.dart';
import 'package:giftly/core/services/review_service.dart';
import 'package:giftly/core/services/user_service.dart';
import 'package:giftly/core/models/gift_model.dart';
import 'package:giftly/core/models/cart_model.dart';
import 'package:giftly/core/models/favorite_model.dart';
import 'package:giftly/core/models/review_model.dart';
import 'package:giftly/core/models/user_model.dart';

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Service Providers
final giftServiceProvider = Provider<GiftService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GiftService(apiClient);
});

final cartServiceProvider = Provider<CartService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CartService(apiClient);
});

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FavoriteService(apiClient);
});

final reviewServiceProvider = Provider<ReviewService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReviewService(apiClient);
});

final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserService(apiClient);
});

// Gifts State Providers
final giftsProvider = FutureProvider<List<GiftModel>>((ref) async {
  final giftService = ref.watch(giftServiceProvider);
  return await giftService.getAllGifts();
});

final giftByIdProvider = FutureProvider.family<GiftModel, String>((
  ref,
  id,
) async {
  final giftService = ref.watch(giftServiceProvider);
  return await giftService.getGiftById(id);
});

final recommendedGiftsProvider =
    FutureProvider.family<List<GiftModel>, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final giftService = ref.watch(giftServiceProvider);
      return await giftService.getRecommendations(
        age: params['age'] as int,
        event: params['event'] as String,
        gender: params['gender'] as String,
      );
    });

// Cart State Providers
final cartProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<CartModel?>>((ref) {
      final cartService = ref.watch(cartServiceProvider);
      return CartNotifier(cartService);
    });

class CartNotifier extends StateNotifier<AsyncValue<CartModel?>> {
  final CartService _cartService;

  CartNotifier(this._cartService) : super(const AsyncValue.loading()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = const AsyncValue.loading();
    try {
      final cart = await _cartService.getCart();
      state = AsyncValue.data(cart);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addItem(String giftId, {int quantity = 1}) async {
    try {
      final cart = await _cartService.addItem(
        giftId: giftId,
        quantity: quantity,
      );
      state = AsyncValue.data(cart);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateItem(String itemId, int quantity) async {
    try {
      final cart = await _cartService.updateItem(
        itemId: itemId,
        quantity: quantity,
      );
      state = AsyncValue.data(cart);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      final cart = await _cartService.removeItem(itemId);
      state = AsyncValue.data(cart);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> applyPromo(String promoCode) async {
    try {
      final cart = await _cartService.applyPromo(promoCode);
      state = AsyncValue.data(cart);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

// Favorites State Providers
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<FavoriteModel?>>((ref) {
      final favoriteService = ref.watch(favoriteServiceProvider);
      return FavoritesNotifier(favoriteService);
    });

class FavoritesNotifier extends StateNotifier<AsyncValue<FavoriteModel?>> {
  final FavoriteService _favoriteService;

  FavoritesNotifier(this._favoriteService) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = const AsyncValue.loading();
    try {
      final favorites = await _favoriteService.getFavorites();
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addFavorite(String giftId) async {
    try {
      final favorites = await _favoriteService.addFavorite(giftId);
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> removeFavorite(String itemId) async {
    try {
      final favorites = await _favoriteService.removeFavorite(itemId);
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  bool isFavorite(String giftId) {
    return state.value?.isFavorite(giftId) ?? false;
  }
}

// Reviews State Providers
final myReviewsProvider = FutureProvider<List<ReviewModel>>((ref) async {
  final reviewService = ref.watch(reviewServiceProvider);
  return await reviewService.getMyReviews();
});

final giftReviewsProvider = FutureProvider.family<List<ReviewModel>, String>((
  ref,
  giftId,
) async {
  final reviewService = ref.watch(reviewServiceProvider);
  return await reviewService.getGiftReviews(giftId);
});

// User Profile Provider
final userProfileProvider = FutureProvider.family<UserModel, String>((
  ref,
  userId,
) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getUserProfile(userId);
});
