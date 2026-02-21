import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/location/location.dart';
import 'package:flutterconf/schedule/schedule.dart';

void main() {
  group('VenueBanner', () {
    const location = Location(
      name: 'Test Venue',
      coordinates: (0, 0),
    );

    testWidgets('renders venue name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VenueBanner(location: location),
          ),
        ),
      );

      expect(find.text('CONFERENCE VENUE'), findsOneWidget);
      expect(find.text('Test Venue'), findsOneWidget);
      expect(find.text('Show in Google Maps'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('is tappable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VenueBanner(location: location),
          ),
        ),
      );

      final button = find.byType(OutlinedButton);
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump();
    });
  });
}
