import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness4all/screen/home/Meals/meals_screen.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  group('MealsScreen Widget Tests', () {
    testWidgets('Test adding a meal', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: MealsScreen(),
      ));

      // Verify that the initial state is correct.
      expect(find.text('Add Meal'), findsOneWidget);
      expect(find.text('No meals saved yet.'), findsOneWidget);

      // Enter text into the meal name field.
      await tester.enterText(find.byType(TextField).at(0), 'Scrambled Eggs');
      await tester.enterText(find.byType(TextField).at(1), 'Breakfast');
      await tester.enterText(find.byType(TextField).at(2), '300');

      // Tap the 'Save Meal' button.
      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle(); // Wait for the widget to update

      // Verify that the meal was added successfully.
      expect(find.text('Scrambled Eggs'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('300 kcal'), findsOneWidget);
    });

    testWidgets('Test setting a calorie limit', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: MealsScreen(),
      ));

      // Navigate to the 'Set Calorie Limit' page.
      await tester.tap(find.text('Limits'));
      await tester.pumpAndSettle();

      // Enter a new calorie limit.
      await tester.enterText(find.byType(TextField), '2500');
      await tester.tap(find.text('Update Limit'));
      await tester.pumpAndSettle();

      // Verify that the calorie limit was updated.
      expect(find.text('📏 Current Calorie Limit: 2500 kcal'), findsOneWidget);
    });

    testWidgets('Test adding water intake', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: MealsScreen(),
      ));

      // Navigate to the 'Water Intake' page.
      await tester.tap(find.text('Water'));
      await tester.pumpAndSettle();

      // Enter water intake.
      await tester.enterText(find.byType(TextField), '500');
      await tester.tap(find.text('Add Water Intake'));
      await tester.pumpAndSettle();

      // Verify that the water intake was added.
      expect(find.text('💧 Total Water Intake: 500 ml'), findsOneWidget);
    });

    testWidgets('Test meal recommendations', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: MealsScreen(),
      ));

      // Navigate to the 'Meal & Snack Recommendations' page.
      await tester.tap(find.text('Suggestions'));
      await tester.pumpAndSettle();

      // Verify that meal recommendations are displayed.
      expect(find.text('🍳 Breakfast:'), findsOneWidget);
      expect(find.text('🍱 Lunch:'), findsOneWidget);
      expect(find.text('🍎 Snack:'), findsOneWidget);
      expect(find.text('🍽 Dinner:'), findsOneWidget);
    });
  });
}