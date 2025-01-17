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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
    );
  }
}

void main() {

  testWidgets(
    "Should present green status",
    (WidgetTester tester) async {

      final sut = MaterialApp(
        home: PlayerStatus(
          isConfirmed: true,
        ),
      );

      await tester.pumpWidget(sut);

      final boxDecoration = tester.firstWidget<Container>(find.byType(Container)).decoration as BoxDecoration;

      expect(boxDecoration.color, Colors.green);
    },
  );
}