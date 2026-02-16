class GiftModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String ageRange;
  final String price;
  final String? image;
  final String? event;
  final String? gender;
  final String? occasion;
  final double? rating;
  final int? reviewCount;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GiftModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.ageRange,
    required this.price,
    this.image,
    this.event,
    this.gender,
    this.occasion,
    this.rating,
    this.reviewCount,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      ageRange:
          json['ageRange']?.toString() ?? json['ageGroup']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      image: json['imageUrl']?.toString() ?? json['image']?.toString(),
      event: json['event']?.toString(),
      gender: json['gender']?.toString(),
      occasion: json['occasion'] is List
          ? (json['occasion'] as List).join(', ')
          : json['occasion']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] ?? false,
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
      'name': name,
      'description': description,
      'category': category,
      'ageRange': ageRange,
      'price': price,
      'image': image,
      'event': event,
      'gender': gender,
      'occasion': occasion,
      'rating': rating,
      'reviewCount': reviewCount,
      'isDeleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  GiftModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? ageRange,
    String? price,
    String? image,
    String? event,
    String? gender,
    String? occasion,
    double? rating,
    int? reviewCount,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GiftModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      ageRange: ageRange ?? this.ageRange,
      price: price ?? this.price,
      image: image ?? this.image,
      event: event ?? this.event,
      gender: gender ?? this.gender,
      occasion: occasion ?? this.occasion,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
