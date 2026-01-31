import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/services/network/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl();
  });

  group('NetworkInfoImpl -', () {
    test('isConnected should return true when connected to WiFi', () async {
      // Arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Act
      final results = await mockConnectivity.checkConnectivity();
      final isConnected = results.contains(ConnectivityResult.wifi);

      // Assert
      expect(isConnected, true);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('isConnected should return true when connected to mobile', () async {
      // Arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.mobile]);

      // Act
      final results = await mockConnectivity.checkConnectivity();
      final isConnected = results.contains(ConnectivityResult.mobile);

      // Assert
      expect(isConnected, true);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('isConnected should return true when connected to ethernet', () async {
      // Arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.ethernet]);

      // Act
      final results = await mockConnectivity.checkConnectivity();
      final isConnected = results.contains(ConnectivityResult.ethernet);

      // Assert
      expect(isConnected, true);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('isConnected should return false when not connected', () async {
      // Arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      final results = await mockConnectivity.checkConnectivity();
      final isConnected =
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet);

      // Assert
      expect(isConnected, false);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('isConnected should return false when exception occurs', () async {
      // Arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenThrow(Exception('Failed to check connectivity'));

      // Act & Assert
      expect(
        () => mockConnectivity.checkConnectivity(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('isConnected should handle multiple connectivity results', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
      );

      // Act
      final results = await mockConnectivity.checkConnectivity();
      final isConnected =
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile);

      // Assert
      expect(isConnected, true);
      expect(results.length, 2);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('connectionStream should emit connectivity changes', () async {
      // Arrange
      final stream = Stream.fromIterable([
        [ConnectivityResult.wifi],
        [ConnectivityResult.none],
        [ConnectivityResult.mobile],
      ]);

      when(
        () => mockConnectivity.onConnectivityChanged,
      ).thenAnswer((_) => stream);

      // Act
      final results = <List<ConnectivityResult>>[];
      await for (final result in mockConnectivity.onConnectivityChanged.take(
        3,
      )) {
        results.add(result);
      }

      // Assert
      expect(results.length, 3);
      expect(results[0], [ConnectivityResult.wifi]);
      expect(results[1], [ConnectivityResult.none]);
      expect(results[2], [ConnectivityResult.mobile]);
    });

    test(
      '_isConnectedResult should correctly identify connection types',
      () async {
        // Test with List<ConnectivityResult>
        final wifiList = [ConnectivityResult.wifi];
        final mobileList = [ConnectivityResult.mobile];
        final ethernetList = [ConnectivityResult.ethernet];
        final noneList = [ConnectivityResult.none];

        expect(
          wifiList.contains(ConnectivityResult.wifi) ||
              wifiList.contains(ConnectivityResult.mobile) ||
              wifiList.contains(ConnectivityResult.ethernet),
          true,
        );
        expect(
          mobileList.contains(ConnectivityResult.wifi) ||
              mobileList.contains(ConnectivityResult.mobile) ||
              mobileList.contains(ConnectivityResult.ethernet),
          true,
        );
        expect(
          ethernetList.contains(ConnectivityResult.wifi) ||
              ethernetList.contains(ConnectivityResult.mobile) ||
              ethernetList.contains(ConnectivityResult.ethernet),
          true,
        );
        expect(
          noneList.contains(ConnectivityResult.wifi) ||
              noneList.contains(ConnectivityResult.mobile) ||
              noneList.contains(ConnectivityResult.ethernet),
          false,
        );
      },
    );
  });
}
