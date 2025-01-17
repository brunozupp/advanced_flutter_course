import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// To widgets like this that are used in more than one page/module
/// it is not recommended to put the viewmodel as a paramters, because
/// doing this I am binding the viewmodel with the component and restricting
/// its using to a specific page/module.
/// So, it's recommended to put just the parameters needed separeted.

class PlayerPhoto extends StatelessWidget {

  final String initials;
  final String? photo;

  const PlayerPhoto({
    super.key,
    required this.initials,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text("BN"),
    );
  }
}

void main() {

  testWidgets(
    "should present initials when there is no photo",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerPhoto(
          initials: "BN",
          photo: null,
        ),
      );

      await tester.pumpWidget(sut);

      expect(find.text("BN"), findsOneWidget);
    },
  );
}