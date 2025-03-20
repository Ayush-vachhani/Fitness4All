import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness4all/screen/home/Main_home/garph.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  group('ReportsScreen Widget Tests', () {
    testWidgets('Test Quick View section', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget( MaterialApp(
        home: ReportsScreen(),
      ));

      // Verify that the Quick View section is displayed.
      expect(find.text('Quick View'), findsOneWidget);
      expect(find.text('Here are your progress'), findsOneWidget);
      expect(find.byIcon(Icons.supervisor_account), findsOneWidget);
    });

    testWidgets('Test Caloric Progress card and pie chart', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget( MaterialApp(
        home: ReportsScreen(),
      ));

      // Verify that the Caloric Progress card is displayed.
      expect(find.text('Caloric Progress'), findsOneWidget);

      // Verify that the pie chart is displayed.
      expect(find.byType(PieChart), findsOneWidget);

      // Verify the legend items.
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('Test Progress card and line chart', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget( MaterialApp(
        home: ReportsScreen(),
      ));

      // Verify that the Progress card is displayed.
      expect(find.text('Progress'), findsOneWidget);

      // Verify that the line chart is displayed.
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('Test legend items', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget( MaterialApp(
        home: ReportsScreen(),
      ));

      // Verify that the legend items are displayed.
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);

      // Verify the legend item colors.
      final completedLegend = find.text('Completed');
      final pendingLegend = find.text('Pending');

      // Check the color of the "Completed" legend item
      final completedContainer = tester.widget<Container>(
          find.ancestor(
            of: completedLegend,
            matching: find.byType(Container),
          ));
          expect(
          (completedContainer.decoration as BoxDecoration).color,
          Colors.green,
      );

      // Check the color of the "Pending" legend item
      final pendingContainer = tester.widget<Container>(
      find.ancestor(
      of: pendingLegend,
      matching: find.byType(Container),
      ));
      expect(
      (pendingContainer.decoration as BoxDecoration).color,
      Colors.red,
      );
    });
  });
}