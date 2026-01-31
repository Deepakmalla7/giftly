import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/widgets/my_button.dart';

void main() {
  group('MyButton Widget -', () {
    const testText = 'Click Me';

    testWidgets('should display button text', (WidgetTester tester) async {
      // Arrange
      var pressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
      expect(pressed, false);
    });

    testWidgets('should call onPressed when tapped',
        (WidgetTester tester) async {
      // Arrange
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(pressed, true);
    });

    testWidgets('should have correct button styling',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final elevatedButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final style = elevatedButton.style;

      expect(style, isNotNull);
      expect(
        style!.backgroundColor?.resolve({}),
        const Color(0xFFF57C00),
      );
      expect(style.foregroundColor?.resolve({}), Colors.white);
    });

    testWidgets('should have full width', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('should have correct text styling',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text(testText));
      expect(textWidget.style?.fontSize, 16);
    });

    testWidgets('should have correct padding', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(Padding),
        ),
      );
      expect(padding.padding, const EdgeInsets.symmetric(vertical: 12.0));
    });

    testWidgets('should be found by text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.widgetWithText(ElevatedButton, testText), findsOneWidget);
    });

    testWidgets('should call onPressed multiple times',
        (WidgetTester tester) async {
      // Arrange
      var pressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: testText,
              onPressed: () {
                pressCount++;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(pressCount, 3);
    });

    testWidgets('should work with different text values',
        (WidgetTester tester) async {
      // Arrange
      const differentText = 'Submit';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyButton(
              text: differentText,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(differentText), findsOneWidget);
      expect(find.text(testText), findsNothing);
    });
  });
}
