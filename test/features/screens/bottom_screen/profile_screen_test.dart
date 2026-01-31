import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/features/screens/bottom_screen/profile_screen.dart';

void main() {
  group('ProfileScreen Widget -', () {
    testWidgets('should display profile screen text', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Assert
      expect(find.text('this is Profile screen'), findsOneWidget);
    });

    testWidgets('should use SizedBox.expand for layout', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, double.infinity);
    });

    testWidgets('should center content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Assert
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should have correct widget hierarchy', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Assert
      expect(
        find.descendant(
          of: find.byType(SizedBox),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(Center), matching: find.byType(Text)),
        findsOneWidget,
      );
    });

    testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Assert
      expect(find.byType(ProfileScreen), findsOneWidget);
      final widget = tester.widget<ProfileScreen>(find.byType(ProfileScreen));
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('should maintain const constructor', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      const screen1 = ProfileScreen();
      const screen2 = ProfileScreen();

      // Assert - const constructors create identical instances
      expect(identical(screen1, screen2), true);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ProfileScreen())),
      );

      // Assert - Should complete without throwing
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be composable in larger widget tree', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('App')),
            body: const ProfileScreen(),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('this is Profile screen'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should rebuild correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

      // Act
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
      await tester.pump();

      // Assert
      expect(find.text('this is Profile screen'), findsOneWidget);
    });

    testWidgets('should work with different themes', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(theme: ThemeData.dark(), home: const ProfileScreen()),
      );

      // Assert
      expect(find.text('this is Profile screen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
