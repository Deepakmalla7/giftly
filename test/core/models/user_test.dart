import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/models/user.dart';

void main() {
  group('User Model -', () {
    const testId = '123';
    const testName = 'Test User';
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testProfilePhoto = 'https://example.com/photo.jpg';

    test('should create User with all fields', () {
      // Arrange & Act
      final user = User(
        id: testId,
        name: testName,
        email: testEmail,
        password: testPassword,
        profilePhoto: testProfilePhoto,
      );

      // Assert
      expect(user.id, testId);
      expect(user.name, testName);
      expect(user.email, testEmail);
      expect(user.password, testPassword);
      expect(user.profilePhoto, testProfilePhoto);
    });

    test('should create User without optional fields', () {
      // Arrange & Act
      final user = User(
        name: testName,
        email: testEmail,
        password: testPassword,
      );

      // Assert
      expect(user.id, isNull);
      expect(user.name, testName);
      expect(user.email, testEmail);
      expect(user.password, testPassword);
      expect(user.profilePhoto, isNull);
    });

    test('fromJson should create User from JSON with _id', () {
      // Arrange
      final json = {
        '_id': testId,
        'name': testName,
        'email': testEmail,
        'password': testPassword,
        'profilePhoto': testProfilePhoto,
      };
      //
      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, testId);
      expect(user.name, testName);
      expect(user.email, testEmail);
      expect(user.password, testPassword);
      expect(user.profilePhoto, testProfilePhoto);
    });

    test('fromJson should create User from JSON with id', () {
      // Arrange
      final json = {
        'id': testId,
        'name': testName,
        'email': testEmail,
        'password': testPassword,
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, testId);
      expect(user.name, testName);
      expect(user.email, testEmail);
    });

    test('fromJson should handle missing password', () {
      // Arrange
      final json = {'_id': testId, 'name': testName, 'email': testEmail};

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, testId);
      expect(user.name, testName);
      expect(user.email, testEmail);
      expect(user.password, '');
      expect(user.profilePhoto, isNull);
    });

    test('toJson should create JSON with all fields', () {
      // Arrange
      final user = User(
        id: testId,
        name: testName,
        email: testEmail,
        password: testPassword,
        profilePhoto: testProfilePhoto,
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['_id'], testId);
      expect(json['name'], testName);
      expect(json['email'], testEmail);
      expect(json['password'], testPassword);
      expect(json['profilePhoto'], testProfilePhoto);
    });

    test('toJson should omit null id and profilePhoto', () {
      // Arrange
      final user = User(
        name: testName,
        email: testEmail,
        password: testPassword,
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json.containsKey('_id'), false);
      expect(json['name'], testName);
      expect(json['email'], testEmail);
      expect(json['password'], testPassword);
      expect(json.containsKey('profilePhoto'), false);
    });

    test('should be able to update user properties', () {
      // Arrange
      final user = User(
        name: testName,
        email: testEmail,
        password: testPassword,
      );

      // Act
      user.id = testId;
      user.profilePhoto = testProfilePhoto;

      // Assert
      expect(user.id, testId);
      expect(user.profilePhoto, testProfilePhoto);
    });

    test('fromJson and toJson should be reversible', () {
      // Arrange
      final originalUser = User(
        id: testId,
        name: testName,
        email: testEmail,
        password: testPassword,
        profilePhoto: testProfilePhoto,
      );

      // Act
      final json = originalUser.toJson();
      final reconstructedUser = User.fromJson(json);

      // Assert
      expect(reconstructedUser.id, originalUser.id);
      expect(reconstructedUser.name, originalUser.name);
      expect(reconstructedUser.email, originalUser.email);
      expect(reconstructedUser.password, originalUser.password);
      expect(reconstructedUser.profilePhoto, originalUser.profilePhoto);
    });
  });
}
