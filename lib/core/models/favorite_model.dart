import 'package:giftly/core/models/gift_model.dart';

class FavoriteItemModel {
  final String id;
  final GiftModel gift;
  final DateTime? addedAt;

  FavoriteItemModel({required this.id, required this.gift, this.addedAt});

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    final giftData = json['gift'];
    GiftModel gift;

    if (giftData is Map<String, dynamic>) {
      gift = GiftModel.fromJson(giftData);
    } else if (giftData is String) {
      gift = GiftModel(
        id: giftData,
        name: '',
        description: '',
        category: '',
        ageRange: '',
        price: '',
      );
    } else {
      // Backend returns flat items with title/image/rating instead of nested gift
      gift = GiftModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: json['title']?.toString() ?? '',
        description: '',
        category: '',
        ageRange: '',
        price: '',
        image: json['image']?.toString(),
        rating: (json['rating'] as num?)?.toDouble(),
      );
    }

    return FavoriteItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      gift: gift,
      addedAt: json['addedAt'] != null ? DateTime.parse(json['addedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'gift': gift.toJson(),
      'addedAt': addedAt?.toIso8601String(),
    };
  }
}

class FavoriteModel {
  final String id;
  final String userId;
  final List<FavoriteItemModel> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user'] ?? json['userId'] ?? '',
      items:
          (json['items'] as List?)
              ?.map((item) => FavoriteItemModel.fromJson(item))
              .toList() ??
          [],
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool isFavorite(String giftId) {
    return items.any((item) => item.gift.id == giftId);
  }

  FavoriteModel copyWith({
    String? id,
    String? userId,
    List<FavoriteItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
