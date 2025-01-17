import 'package:advanced_flutter_course/app/ui/pages/widgets/player_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets(
    "Should handle goalkeeper position",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerPosition(
          position: "goalkeeper",
        ),
      );

      await tester.pumpWidget(sut);

      expect(find.text("Goleiro"), findsOneWidget);
    },
  );

  testWidgets(
    "Should handle defender position",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerPosition(
          position: "defender",
        ),
      );

      await tester.pumpWidget(sut);

      expect(find.text("Zagueiro"), findsOneWidget);
    },
  );

  testWidgets(
    "Should handle midfielder position",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerPosition(
          position: "midfielder",
        ),
      );

      await tester.pumpWidget(sut);

      expect(find.text("Meia"), findsOneWidget);
    },
  );

  testWidgets(
    "Should handle forward position",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerPosition(
          position: "forward",
        ),
      );

      await tester.pumpWidget(sut);

      expect(find.text("Atacante"), findsOneWidget);
    },
  );

  testWidgets(
    "Should handle positionless",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerPosition(
          position: null,
        ),
      );

      await tester.pumpWidget(sut);

      expect(find.text("Gandula"), findsOneWidget);
    },
  );
}