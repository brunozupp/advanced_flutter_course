import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class PlayerStatus extends StatelessWidget {

  final bool isConfirmed;

  const PlayerStatus({
    super.key,
    required this.isConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColorStatus(),
      ),
    );
  }

  Color getColorStatus() => switch(isConfirmed) {
    true => Colors.green,
    false => Colors.red,
  };
}

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
}