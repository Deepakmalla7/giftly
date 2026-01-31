import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/widgets/my_textfield.dart';
// testing

void main() {
  group('MyTextField Widget -', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display hint text', (WidgetTester tester) async {
      // Arrange
      const hintText = 'Enter your email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: hintText,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.labelText, hintText);
    });

    testWidgets('should accept text input', (WidgetTester tester) async {
      // Arrange
      const inputText = 'test@example.com';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), inputText);

      // Assert
      expect(controller.text, inputText);
      expect(find.text(inputText), findsOneWidget);
    });

    testWidgets('should obscure text when obscureText is true', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Password',
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('should not obscure text when obscureText is false', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, false);
    });

    testWidgets('should use correct keyboard type', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Email',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('should have outlined border decoration', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Name',
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.border, isA<OutlineInputBorder>());
    });

    testWidgets('should use provided controller', (WidgetTester tester) async {
      // Arrange
      controller.text = 'Initial text';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Name',
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Initial text'), findsOneWidget);
      expect(controller.text, 'Initial text');
    });

    testWidgets('should update controller when text changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Name',
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'New text');

      // Assert
      expect(controller.text, 'New text');
    });

    testWidgets('should work with number keyboard type', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Phone',
              obscureText: false,
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.phone);
    });

    testWidgets('should clear text when controller is cleared', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyTextField(
              controller: controller,
              hintText: 'Name',
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Some text');
      expect(controller.text, 'Some text');

      // Act
      controller.clear();
      await tester.pump();

      // Assert
      expect(controller.text, '');
    });
  });
}
