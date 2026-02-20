import 'package:giftly/core/models/user_model.dart';
import 'package:giftly/core/models/gift_model.dart';

class ReviewModel {
  final String id;
  final String giftId;
  final GiftModel? gift;
  final String userId;
  final UserModel? user;
  final int rating;
  final String comment;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.id,
    required this.giftId,
    this.gift,
    required this.userId,
    this.user,
    required this.rating,
    required this.comment,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? json['id'] ?? '',
      giftId: json['gift'] is String
          ? json['gift']
          : (json['gift']?['_id'] ?? ''),
      gift: json['gift'] is Map ? GiftModel.fromJson(json['gift']) : null,
      userId: json['user'] is String
          ? json['user']
          : (json['user']?['_id'] ?? ''),
      user: json['user'] is Map ? UserModel.fromJson(json['user']) : null,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
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
      'gift': giftId,
      'user': userId,
      'rating': rating,
      'comment': comment,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    String? id,
    String? giftId,
    GiftModel? gift,
    String? userId,
    UserModel? user,
    int? rating,
    String? comment,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      giftId: giftId ?? this.giftId,
      gift: gift ?? this.gift,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
