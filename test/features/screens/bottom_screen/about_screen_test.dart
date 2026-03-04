import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giftly/core/models/gift_item.dart';
import 'package:giftly/features/screens/bottom_screen/about_screen.dart';

void main() {
  group('AboutScreen Widget -', () {
    testWidgets('renders key sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AboutScreen(favorites: [])),
      );

      expect(find.text('About Giftly'), findsOneWidget);
      expect(find.text('What Giftly does'), findsOneWidget);
      expect(find.text('Your favorites'), findsOneWidget);
    });

    testWidgets('shows empty favorites message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AboutScreen(favorites: [])),
      );

      expect(
        find.text(
          'No favorites yet. Tap the heart on Home to save gifts you love.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows favorite tiles when provided', (
      WidgetTester tester,
    ) async {
      final favorites = [
        const GiftItem(
          id: '1',
          name: 'Rose Bouquets',
          description: 'Beautiful rose bouquets',
          category: 'Flowers',
          price: 49.99,
          occasion: ['Anniversary'],
          rating: 4.1,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(home: AboutScreen(favorites: favorites)),
      );

      expect(find.text('Rose Bouquets'), findsOneWidget);
    });
  });
}
