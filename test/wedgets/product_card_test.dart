import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/wedgets/product_card.dart';

void main() {
  group('ProductCard Widget -', () {
    const testImage = 'assets/images/gifts.png';
    const testTitle = 'Test Product';
    const testRating = 4.5;

    testWidgets('should display product image', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: testRating,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
    });

    testWidgets('should display product title', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: testRating,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testTitle), findsOneWidget);
      final titleWidget = tester.widget<Text>(find.text(testTitle));
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.fontSize, 16);
    });

    testWidgets('should display rating with star icon',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: testRating,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text(testRating.toString()), findsOneWidget);

      final starIcon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(starIcon.color, Colors.amber);
      expect(starIcon.size, 20);
    });

    testWidgets('should display favorite icon button',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: testRating,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);

      final favoriteIcon =
          tester.widget<Icon>(find.byIcon(Icons.favorite_border));
      expect(favoriteIcon.color, Colors.black54);
    });

    testWidgets('should have correct container styling',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: testRating,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.white);
      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
    });

    testWidgets('should be tappable on favorite button',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: testRating,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Assert - should not throw any errors
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should display different ratings correctly',
        (WidgetTester tester) async {
      // Test with different rating value
      const differentRating = 3.8;

      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: differentRating,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(differentRating.toString()), findsOneWidget);
    });

    testWidgets('should have proper layout structure',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              image: testImage,
              title: testTitle,
              rating: testRating,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Row), findsWidgets);
    });
  });
}
