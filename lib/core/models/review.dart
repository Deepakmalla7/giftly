class Review {
  const Review({
    required this.id,
    required this.userId,
    required this.giftId,
    required this.rating,
    required this.comment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
  });

  final String id;
  final String userId;
  final String giftId;
  final int rating;
  final String comment;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userName;

  factory Review.fromJson(Map<String, dynamic> json) {
    String? displayName;

    // Try to extract user name from userId (MongoDB populated field)
    if (json['userId'] is Map<String, dynamic>) {
      final user = json['userId'] as Map<String, dynamic>;
      displayName =
          user['name']?.toString() ??
          user['firstName']?.toString() ??
          user['lastName']?.toString();
      if (displayName == null &&
          user['firstName'] != null &&
          user['lastName'] != null) {
        displayName = '${user['firstName']} ${user['lastName']}';
      }
    }

    // Fallback to user field (alternative structure)
    if (displayName == null && json['user'] is Map<String, dynamic>) {
      final user = json['user'] as Map<String, dynamic>;
      displayName =
          user['name']?.toString() ??
          user['firstName']?.toString() ??
          user['lastName']?.toString();
      if (displayName == null &&
          user['firstName'] != null &&
          user['lastName'] != null) {
        displayName = '${user['firstName']} ${user['lastName']}';
      }
    }

    // Fallback to direct userName field
    displayName ??= json['userName']?.toString();

    return Review(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      giftId: json['giftId']?.toString() ?? '',
      rating: json['rating']?.toInt() ?? 0,
      comment: json['comment']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      userName: displayName ?? 'Anonymous',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'giftId': giftId,
      'rating': rating,
      'comment': comment,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
