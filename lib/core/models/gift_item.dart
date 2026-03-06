import 'package:giftly/core/api/api_endpoints.dart';

class GiftItem {
  const GiftItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.occasion,
    this.recipientType,
    this.rating = 0.0,
    this.imageUrl,
    this.isAvailable = true,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final List<String> occasion;
  final String? recipientType;
  final double rating;
  final String? imageUrl;
  final bool isAvailable;

  String get tagLabel {
    if (occasion.isNotEmpty) {
      return occasion.first;
    }
    return category;
  }

  String? get resolvedImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return null;
    if (imageUrl!.startsWith('http')) return imageUrl;
    if (imageUrl!.startsWith('/uploads')) {
      return '${ApiEndpoints.serverRoot}$imageUrl';
    }
    return null;
  }

  factory GiftItem.fromJson(Map<String, dynamic> json) {
    final rawOccasion = json['occasion'];
    return GiftItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      occasion: rawOccasion is List
          ? rawOccasion.map((e) => e.toString()).toList()
          : const [],
      recipientType: json['recipientType']?.toString(),
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      imageUrl: json['imageUrl']?.toString(),
      isAvailable: json['isAvailable'] == true,
    );
  }
}
