import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/features/screens/bottom_screen/about_screen.dart';

void main() {
  group('AboutScreen Widget -', () {
    testWidgets('should display about screen text',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      // Assert
      expect(find.text('this is about screen'), findsOneWidget);
    });

    testWidgets('should use SizedBox.expand for layout',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      // Assert
      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, double.infinity);
    });

    testWidgets('should center content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      // Assert
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should have correct widget hierarchy',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      // Assert
      expect(
        find.descendant(
          of: find.byType(SizedBox),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(Center),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      // Assert
      expect(find.byType(AboutScreen), findsOneWidget);
      final widget = tester.widget<AboutScreen>(find.byType(AboutScreen));
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('should maintain const constructor',
        (WidgetTester tester) async {
      // Arrange & Act
      const screen1 = AboutScreen();
      const screen2 = AboutScreen();

      // Assert - const constructors create identical instances
      expect(identical(screen1, screen2), true);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutScreen(),
          ),
        ),
      );

      // Assert - Should complete without throwing
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be composable in navigation',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('About')),
            body: const AboutScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('this is about screen'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('should rebuild correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutScreen(),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('this is about screen'), findsOneWidget);
    });

    testWidgets('should work with custom themes', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 18),
            ),
          ),
          home: const AboutScreen(),
        ),
      );

      // Assert
      expect(find.text('this is about screen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should be navigable', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                child: const Text('Go to About'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Go to About'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AboutScreen), findsOneWidget);
      expect(find.text('this is about screen'), findsOneWidget);
    });

    testWidgets('should handle back navigation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                child: const Text('Go to About'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go to About'));
      await tester.pumpAndSettle();
      expect(find.byType(AboutScreen), findsOneWidget);

      // Act
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AboutScreen), findsNothing);
      expect(find.text('Go to About'), findsOneWidget);
    });
  });
}
