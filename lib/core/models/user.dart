// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:giftly/core/api/api_endpoints.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String? profilePicture;

  @HiveField(5)
  String? firstName;

  @HiveField(6)
  String? lastName;

  @HiveField(7)
  String? username;

  @HiveField(8)
  String? role;

  @HiveField(9)
  String? accountStatus;

  @HiveField(10)
  DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.username,
    this.role,
    this.accountStatus,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Backend returns firstName/lastName separately; combine into name for Hive
    final derivedName =
        json['name'] ??
        '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim();
    final createdAtRaw = json['createdAt'];
    DateTime? parsedCreatedAt;
    if (createdAtRaw is String && createdAtRaw.isNotEmpty) {
      parsedCreatedAt = DateTime.tryParse(createdAtRaw);
    } else if (createdAtRaw is int) {
      parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(createdAtRaw);
    }
    return User(
      id: json['_id'] ?? json['id'],
      name: derivedName,
      email: json['email'],
      password: json['password'] ?? '',
      profilePicture: json['profilePicture'] ?? json['profilePhoto'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      role: json['role'],
      accountStatus: json['accountStatus'],
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'email': email,
      'password': password,
      if (profilePicture != null) 'profilePicture': profilePicture,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (username != null) 'username': username,
      if (role != null) 'role': role,
      if (accountStatus != null) 'accountStatus': accountStatus,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  String get displayName {
    final first = (firstName ?? '').trim();
    final last = (lastName ?? '').trim();
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    if (name.trim().isNotEmpty) return name.trim();
    if ((username ?? '').trim().isNotEmpty) return username!.trim();
    return email;
  }

  /// Constructs the full URL for the profile photo.
  /// Handles both relative paths (new uploads) and full URLs (legacy data).
  String? get profilePictureUrl {
    if (profilePicture == null || profilePicture!.isEmpty) return null;
    if (profilePicture!.startsWith('http')) {
      return profilePicture; // Already a full URL
    }
    return '${ApiEndpoints.serverRoot}$profilePicture'; // Relative path, prepend base URL
  }
}
