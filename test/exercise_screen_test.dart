import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness4all/screen/home/exercises/exercises_screen.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  group('ExerciseScreen Widget Tests', () {
    testWidgets('Test adding an exercise', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: ExerciseScreen(),
      ));

      // Verify that the initial state is correct.
      expect(find.text('Add Exercise'), findsOneWidget);
      expect(find.text('No exercises logged yet.'), findsOneWidget);

      // Enter text into the exercise name field.
      await tester.enterText(find.byType(TextField).at(0), 'Push-ups');
      await tester.enterText(find.byType(TextField).at(1), '50');
      await tester.enterText(find.byType(TextField).at(2), '10');
      await tester.enterText(find.byType(TextField).at(3), 'Great workout!');

      // Tap the 'Log Exercise' button.
      await tester.tap(find.text('Log Exercise'));
      await tester.pumpAndSettle(); // Wait for the widget to update

      // Verify that the exercise was added successfully.
      expect(find.text('Push-ups'), findsOneWidget);
      expect(find.text('🔥 50 kcal burned'), findsOneWidget);
      expect(find.text('⏱ Time Spent: 10 minutes'), findsOneWidget);
      expect(find.text('📝 Notes: Great workout!'), findsOneWidget);
    });

    testWidgets('Test starting and stopping the timer', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: ExerciseScreen(),
      ));

      // Navigate to the 'Time to Calories' page.
      await tester.tap(find.text('Time to Calories'));
      await tester.pumpAndSettle();

      // Verify that the timer is initially stopped.
      expect(find.text('Click here'), findsOneWidget);

      // Start the timer.
      await tester.tap(find.text('Click here'));
      await tester.pumpAndSettle();

      // Verify that the timer is running.
      expect(find.text('Stop'), findsOneWidget);

      // Stop the timer.
      await tester.tap(find.text('Stop'));
      await tester.pumpAndSettle();

      // Verify that the timer is stopped and results are displayed.
      expect(find.text('Click here'), findsOneWidget);
      expect(find.text('Timer stopped!'), findsOneWidget);
    });

    testWidgets('Test logging time manually', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: ExerciseScreen(),
      ));

      // Navigate to the 'Time Setter' page.
      await tester.tap(find.text('Time Setter'));
      await tester.pumpAndSettle();

      // Enter time spent.
      await tester.enterText(find.byType(TextField), '30');

      // Tap the 'Log Time' button.
      await tester.tap(find.text('Log Time'));
      await tester.pumpAndSettle();

      // Verify that the time was logged successfully.
      expect(find.text('Time logged successfully!'), findsOneWidget);
    });

    testWidgets('Test resetting data', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: ExerciseScreen(),
      ));

      // Navigate to the 'Time to Calories' page.
      await tester.tap(find.text('Time to Calories'));
      await tester.pumpAndSettle();

      // Tap the 'Reset Data' button.
      await tester.tap(find.text('Reset Data'));
      await tester.pumpAndSettle();

      // Verify that the data was reset.
      expect(find.text('Calories and time reset!'), findsOneWidget);
    });

    testWidgets('Test exercise recommendations', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: ExerciseScreen(),
      ));

      // Navigate to the 'Exercise Recommendations' page.
      await tester.tap(find.text('Suggestions'));
      await tester.pumpAndSettle();

      // Verify that exercise recommendations are displayed.
      expect(find.text('🏋‍♂ Weightlifting'), findsOneWidget);
      expect(find.text('🏃‍♂ Running'), findsOneWidget);
      expect(find.text('🚴‍♂ Cycling'), findsOneWidget);
    });

    testWidgets('Test saving a daily exercise plan', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MaterialApp(
        home: ExerciseScreen(),
      ));

      // Navigate to the 'Daily Exercise Plan' page.
      await tester.tap(find.text('Daily Plan'));
      await tester.pumpAndSettle();

      // Enter morning, afternoon, and evening plans.
      await tester.enterText(find.byType(TextField).at(0), 'Morning jog');
      await tester.enterText(find.byType(TextField).at(1), 'Afternoon yoga');
      await tester.enterText(find.byType(TextField).at(2), 'Evening weights');

      // Tap the 'Customize Plan' button.
      await tester.tap(find.text('Customize Plan'));
      await tester.pumpAndSettle();

      // Verify that the plan was saved successfully.
      expect(find.text('Daily exercise plan saved successfully!'), findsOneWidget);
    });
  });
}