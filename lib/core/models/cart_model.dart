import 'package:giftly/core/models/gift_model.dart';

class CartItemModel {
  final String id;
  final GiftModel gift;
  final int quantity;
  final double price;

  CartItemModel({
    required this.id,
    required this.gift,
    required this.quantity,
    required this.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      gift: json['gift'] is Map
          ? GiftModel.fromJson(json['gift'])
          : GiftModel.fromJson({
              '_id': json['gift'],
              'name': '',
              'description': '',
              'category': '',
              'ageRange': '',
              'price': '',
            }),
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'gift': gift.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }

  double get totalPrice => price * quantity;

  CartItemModel copyWith({
    String? id,
    GiftModel? gift,
    int? quantity,
    double? price,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      gift: gift ?? this.gift,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}

class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final double? discount;
  final String? promoCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.discount,
    this.promoCode,
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user'] ?? json['userId'] ?? '',
      items:
          (json['items'] as List?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      discount: json['discount']?.toDouble(),
      promoCode: json['promoCode'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'discount': discount,
      'promoCode': promoCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get finalAmount => totalAmount - (discount ?? 0);

  CartModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    double? totalAmount,
    double? discount,
    String? promoCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      discount: discount ?? this.discount,
      promoCode: promoCode ?? this.promoCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
