import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/models/user.dart';
import 'package:giftly/core/repositories/auth_repository.dart';
import 'package:giftly/core/services/hive/hive_auth_service.dart';
import 'package:giftly/core/services/remote/remote_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveAuthService extends Mock implements HiveAuthService {}

class MockRemoteAuthService extends Mock implements RemoteAuthService {}

void main() {
  late AuthRepository authRepository;
  late MockHiveAuthService mockHiveAuthService;
  late MockRemoteAuthService mockRemoteAuthService;

  setUpAll(() {
    registerFallbackValue(User(name: '', email: '', password: ''));
  });

  setUp(() {
    mockHiveAuthService = MockHiveAuthService();
    mockRemoteAuthService = MockRemoteAuthService();
    authRepository = AuthRepository(mockHiveAuthService, mockRemoteAuthService);
  });

  group('AuthRepository -', () {
    const testName = 'Test User';
    const testEmail = 'test@example.com';
    const testPassword = 'password123';

    final testUser = User(
      id: '1',
      name: testName,
      email: testEmail,
      password: testPassword,
    );

    test('register should call remote service and save user locally', () async {
      // Arrange
      final responseData = {
        'token': 'test_token',
        'user': {'_id': '1', 'name': testName, 'email': testEmail},
      };

      when(
        () => mockRemoteAuthService.register(testName, testEmail, testPassword),
      ).thenAnswer((_) async => responseData);
      when(
        () => mockHiveAuthService.signUp(any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockHiveAuthService.setCurrentUser(any()),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepository.register(
        testName,
        testEmail,
        testPassword,
      );

      // Assert
      expect(result['token'], 'test_token');
      expect(result['user']['name'], testName);
      verify(
        () => mockRemoteAuthService.register(testName, testEmail, testPassword),
      ).called(1);
      verify(() => mockHiveAuthService.signUp(any())).called(1);
      verify(() => mockHiveAuthService.setCurrentUser(any())).called(1);
    });

    test(
      'login should authenticate remotely and save locally if new user',
      () async {
        // Arrange
        final responseData = {
          'token': 'test_token',
          'user': {'_id': '1', 'name': testName, 'email': testEmail},
        };

        when(
          () => mockRemoteAuthService.login(testEmail, testPassword),
        ).thenAnswer((_) async => responseData);
        when(
          () => mockHiveAuthService.login(testEmail, testPassword),
        ).thenReturn(null);
        when(
          () => mockHiveAuthService.signUp(any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockHiveAuthService.setCurrentUser(any()),
        ).thenAnswer((_) async => {});

        // Act
        final result = await authRepository.login(testEmail, testPassword);

        // Assert
        expect(result['token'], 'test_token');
        verify(
          () => mockRemoteAuthService.login(testEmail, testPassword),
        ).called(1);
        verify(
          () => mockHiveAuthService.login(testEmail, testPassword),
        ).called(1);
        verify(() => mockHiveAuthService.signUp(any())).called(1);
        verify(() => mockHiveAuthService.setCurrentUser(any())).called(1);
      },
    );

    test('login should not save user locally if already exists', () async {
      // Arrange
      final responseData = {
        'token': 'test_token',
        'user': {'_id': '1', 'name': testName, 'email': testEmail},
      };

      when(
        () => mockRemoteAuthService.login(testEmail, testPassword),
      ).thenAnswer((_) async => responseData);
      when(
        () => mockHiveAuthService.login(testEmail, testPassword),
      ).thenReturn(testUser);
      when(
        () => mockHiveAuthService.setCurrentUser(any()),
      ).thenAnswer((_) async => {});

      // Act
      final result = await authRepository.login(testEmail, testPassword);

      // Assert
      expect(result['token'], 'test_token');
      verify(
        () => mockRemoteAuthService.login(testEmail, testPassword),
      ).called(1);
      verify(
        () => mockHiveAuthService.login(testEmail, testPassword),
      ).called(1);
      verifyNever(() => mockHiveAuthService.signUp(any()));
      verify(() => mockHiveAuthService.setCurrentUser(any())).called(1);
    });

    test('register should throw exception when remote service fails', () async {
      // Arrange
      when(
        () => mockRemoteAuthService.register(testName, testEmail, testPassword),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => authRepository.register(testName, testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
      verify(
        () => mockRemoteAuthService.register(testName, testEmail, testPassword),
      ).called(1);
      verifyNever(() => mockHiveAuthService.signUp(any()));
    });

    test('login should throw exception when remote service fails', () async {
      // Arrange
      when(
        () => mockRemoteAuthService.login(testEmail, testPassword),
      ).thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () => authRepository.login(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
      verify(
        () => mockRemoteAuthService.login(testEmail, testPassword),
      ).called(1);
      verifyNever(() => mockHiveAuthService.login(any(), any()));
    });
  });
}
