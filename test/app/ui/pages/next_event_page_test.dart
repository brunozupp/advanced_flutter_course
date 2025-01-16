import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

final class NextEventPage extends StatefulWidget {

  final NextEventPresenter presenter;
  final String groupId;

  const NextEventPage({
    super.key,
    required this.presenter,
    required this.groupId,
  });

  @override
  State<NextEventPage> createState() => _NextEventPageState();
}

class _NextEventPageState extends State<NextEventPage> {

  NextEventPresenter get presenter => widget.presenter;

  @override
  void initState() {
    super.initState();

    presenter.loadNextEvent(groupId: widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

abstract interface class NextEventPresenter {

  void loadNextEvent({
    required String groupId,
  });
}

final class NextEventPresenterSpy implements NextEventPresenter {

  int loadCallsCount = 0;
  String? groupId;

  @override
  void loadNextEvent({required String groupId}) {
    loadCallsCount++;
    this.groupId = groupId;
  }

}

void main() {

  late NextEventPresenterSpy presenter;
  late String groupId;
  late Widget sut;

  setUp(() {
    presenter = NextEventPresenterSpy();
    groupId = anyString();

    /// As I am testing a widget from Material Design it needs to be
    /// inside a MaterialApp
    sut = MaterialApp(
      home: NextEventPage(
        presenter: presenter,
        groupId: groupId,
      ),
    );
  });

  testWidgets(
    "Should load event data on page init",
    (WidgetTester tester) async {

      /// To test a component I need to create it virtually, so it can emulate
      /// this component to be tested virtually.
      /// And to do this I need to use the method .pump
      await tester.pumpWidget(sut);

      expect(presenter.loadCallsCount, 1);
      expect(presenter.groupId, groupId);
    },
  );
}