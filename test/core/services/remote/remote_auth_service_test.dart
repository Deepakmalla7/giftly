import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/services/network/network_info.dart';
import 'package:giftly/core/services/remote/remote_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late RemoteAuthService remoteAuthService;
  late MockApiClient mockApiClient;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockApiClient = MockApiClient();
    mockNetworkInfo = MockNetworkInfo();
    remoteAuthService = RemoteAuthService(mockApiClient, mockNetworkInfo);
  });

  group('RemoteAuthService -', () {
    const testName = 'Test User';
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testToken = 'test_token_12345';

    test('register should return user data when successful', () async {
      // Arrange
      final responseData = {
        'token': testToken,
        'user': {'_id': '1', 'name': testName, 'email': testEmail},
      };

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockApiClient.post(
          '/auth/register',
          data: {
            'name': testName,
            'email': testEmail,
            'password': testPassword,
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/register'),
          statusCode: 201,
          data: responseData,
        ),
      );
      when(() => mockApiClient.setToken(testToken)).thenAnswer((_) async => {});

      // Act
      final result = await remoteAuthService.register(
        testName,
        testEmail,
        testPassword,
      );

      // Assert
      expect(result['token'], testToken);
      expect(result['user']['name'], testName);
      expect(result['user']['email'], testEmail);
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(
        () => mockApiClient.post('/auth/register', data: any(named: 'data')),
      ).called(1);
      verify(() => mockApiClient.setToken(testToken)).called(1);
    });

    test(
      'register should throw exception when no internet connection',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act & Assert
        expect(
          () => remoteAuthService.register(testName, testEmail, testPassword),
          throwsA(isA<Exception>()),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNever(() => mockApiClient.post(any(), data: any(named: 'data')));
      },
    );

    test(
      'register should throw exception when API returns error status',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockApiClient.post('/auth/register', data: any(named: 'data')),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/auth/register'),
            statusCode: 400,
            data: {'message': 'Email already exists'},
          ),
        );

        // Act & Assert
        expect(
          () => remoteAuthService.register(testName, testEmail, testPassword),
          throwsA(isA<Exception>()),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
      },
    );

    test('register should throw exception when DioException occurs', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockApiClient.post('/auth/register', data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          message: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () => remoteAuthService.register(testName, testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    test(
      'login should check internet connection before making request',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act & Assert
        expect(
          () => remoteAuthService.login(testEmail, testPassword),
          throwsA(isA<Exception>()),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNever(() => mockApiClient.post(any(), data: any(named: 'data')));
      },
    );
  });
}
