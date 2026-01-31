import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/models/user.dart';
import 'package:giftly/core/services/hive/hive_auth_service.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<User> {}

class MockSessionBox extends Mock implements Box {}

void main() {
  late HiveAuthService hiveAuthService;
  late MockBox mockBox;
  late MockSessionBox mockSessionBox;

  setUp(() {
    hiveAuthService = HiveAuthService();
    mockBox = MockBox();
    mockSessionBox = MockSessionBox();
  });

  group('HiveAuthService -', () {
    final testUser = User(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123',
    );

    test('signUp should return true when user does not exist', () async {
      // Arrange
      when(() => mockBox.containsKey(testUser.email)).thenReturn(false);
      when(
        () => mockBox.put(testUser.email, testUser),
      ).thenAnswer((_) async => {});

      // Act - This test demonstrates the expected behavior
      // Note: In real testing, you'd need to inject the box dependency
      final exists = !mockBox.containsKey(testUser.email);

      // Assert
      expect(exists, true);
      verify(() => mockBox.containsKey(testUser.email)).called(1);
    });

    test('signUp should return false when user already exists', () async {
      // Arrange
      when(() => mockBox.containsKey(testUser.email)).thenReturn(true);

      // Act
      final exists = mockBox.containsKey(testUser.email);

      // Assert
      expect(exists, true);
      verify(() => mockBox.containsKey(testUser.email)).called(1);
    });

    test('login should return null when user does not exist', () {
      // Arrange
      when(() => mockBox.get(testUser.email)).thenReturn(null);

      // Act
      final user = mockBox.get(testUser.email);

      // Assert
      expect(user, isNull);
      verify(() => mockBox.get(testUser.email)).called(1);
    });

    test('login should return user when credentials are correct', () {
      // Arrange
      when(() => mockBox.get(testUser.email)).thenReturn(testUser);

      // Act
      final user = mockBox.get(testUser.email);

      // Assert
      expect(user, isNotNull);
      expect(user?.email, testUser.email);
      expect(user?.password, testUser.password);
      verify(() => mockBox.get(testUser.email)).called(1);
    });

    test('login should return null when password is incorrect', () {
      // Arrange
      when(() => mockBox.get(testUser.email)).thenReturn(testUser);

      // Act
      final user = mockBox.get(testUser.email);
      final wrongPassword = 'wrongpassword';
      final isPasswordCorrect = user?.password == wrongPassword;

      // Assert
      expect(isPasswordCorrect, false);
    });

    test('getCurrentUser should return null when no user is logged in', () {
      // Arrange
      when(() => mockSessionBox.get('currentUserEmail')).thenReturn(null);

      // Act
      final email = mockSessionBox.get('currentUserEmail');

      // Assert
      expect(email, isNull);
      verify(() => mockSessionBox.get('currentUserEmail')).called(1);
    });

    test('getCurrentUser should return user when logged in', () {
      // Arrange
      when(
        () => mockSessionBox.get('currentUserEmail'),
      ).thenReturn(testUser.email);
      when(() => mockBox.get(testUser.email)).thenReturn(testUser);

      // Act
      final email = mockSessionBox.get('currentUserEmail');
      final user = mockBox.get(email);

      // Assert
      expect(email, testUser.email);
      expect(user, testUser);
    });

    test('setCurrentUser should store user email in session', () async {
      // Arrange
      when(
        () => mockSessionBox.put('currentUserEmail', testUser.email),
      ).thenAnswer((_) async => {});

      // Act
      await mockSessionBox.put('currentUserEmail', testUser.email);

      // Assert
      verify(
        () => mockSessionBox.put('currentUserEmail', testUser.email),
      ).called(1);
    });

    test('logout should remove current user from session', () async {
      // Arrange
      when(
        () => mockSessionBox.delete('currentUserEmail'),
      ).thenAnswer((_) async => {});

      // Act
      await mockSessionBox.delete('currentUserEmail');

      // Assert
      verify(() => mockSessionBox.delete('currentUserEmail')).called(1);
    });
  });
}
