import 'package:dio/dio.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/models/cart_model.dart';

class CartService {
  final ApiClient _apiClient;

  CartService(this._apiClient);

  /// Get user's cart
  Future<CartModel> getCart() async {
    try {
      final response = await _apiClient.get('/cart');

      if (response.data['success'] == true) {
        return CartModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch cart');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Add item to cart
  Future<CartModel> addItem({required String giftId, int quantity = 1}) async {
    try {
      final response = await _apiClient.post(
        '/cart/items',
        data: {'giftId': giftId, 'quantity': quantity},
      );

      if (response.data['success'] == true) {
        return CartModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to add item to cart');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Update cart item quantity
  Future<CartModel> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.put(
        '/cart/items/$itemId',
        data: {'quantity': quantity},
      );

      if (response.data['success'] == true) {
        return CartModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to update cart item');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Remove item from cart
  Future<CartModel> removeItem(String itemId) async {
    try {
      final response = await _apiClient.delete('/cart/items/$itemId');

      if (response.data['success'] == true) {
        return CartModel.fromJson(response.data['data']);
      }

      throw Exception(
        response.data['message'] ?? 'Failed to remove item from cart',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Apply promo code
  Future<CartModel> applyPromo(String promoCode) async {
    try {
      final response = await _apiClient.post(
        '/cart/promo',
        data: {'promoCode': promoCode},
      );

      if (response.data['success'] == true) {
        return CartModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Invalid promo code');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    try {
      final response = await _apiClient.post('/cart/clear');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to clear cart');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error: ${e.message}',
      );
    }
  }
}
