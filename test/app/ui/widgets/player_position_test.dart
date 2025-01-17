import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class PlayerPosition extends StatelessWidget {

  final String? position;

  const PlayerPosition({
    super.key,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Text(buildPositionLabel());
  }

  String buildPositionLabel() => switch(position) {
    "goalkeeper" => "Goleiro",
    "defender" => "Zagueiro",
    _ => "Gandula"
  };
}

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