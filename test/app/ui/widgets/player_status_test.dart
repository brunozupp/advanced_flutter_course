import 'package:advanced_flutter_course/app/ui/pages/widgets/player_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets(
    "Should present green status",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerStatus(
          isConfirmed: true,
        ),
      );

      await tester.pumpWidget(sut);

      final boxDecoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;

      expect(boxDecoration.color, Colors.green);
    },
  );

  testWidgets(
    "Should present green status",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerStatus(
          isConfirmed: false,
        ),
      );

      await tester.pumpWidget(sut);

      final boxDecoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;

      expect(boxDecoration.color, Colors.red);
    },
  );

  testWidgets(
    "Should present grey status",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerStatus(
          isConfirmed: null,
        ),
      );

      await tester.pumpWidget(sut);

      final boxDecoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;

      expect(boxDecoration.color, Colors.grey);
    },
  );
}