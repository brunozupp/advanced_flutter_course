import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';

import '../../../helpers/fakes.dart';

final class NextEventViewModel {

  final List<NextEventPlayerViewModel> goalKeepers;

  const NextEventViewModel({
    this.goalKeepers = const [],
  });
}

final class NextEventPlayerViewModel {

  final String name;

  const NextEventPlayerViewModel({
    required this.name,
  });
}

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
    return Scaffold(
      body: StreamBuilder<NextEventViewModel>(
        stream: presenter.nextEventStream,
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.active) {
            return const CircularProgressIndicator();
          }

          if(snapshot.hasError) return const SizedBox.shrink();

          final nextEvent = snapshot.data!;

          return ListView(
            children: [
              Visibility(
                visible: nextEvent.goalKeepers.isNotEmpty,
                child: ListSection(
                  title: "DENTRO - GOLEIROS",
                  players: nextEvent.goalKeepers,
                )
              ),
            ],
          );
        },
      ),
    );
  }
}

class ListSection extends StatelessWidget {

  final String title;
  final List<NextEventPlayerViewModel> players;

  const ListSection({
    super.key,
    required this.title,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Text(players.length.toString()),
        ...players.map((goalKeeper) => Text(goalKeeper.name))
      ],
    );
  }
}

abstract interface class NextEventPresenter {

  Stream<NextEventViewModel> get nextEventStream;

  void loadNextEvent({
    required String groupId,
  });
}

final class NextEventPresenterSpy implements NextEventPresenter {

  int loadCallsCount = 0;
  String? groupId;
  var nextEventSubject = BehaviorSubject<NextEventViewModel>();

  @override
  Stream<NextEventViewModel> get nextEventStream => nextEventSubject.stream;

  /// These emit methods are just to the spy

  void emitNextEvent([NextEventViewModel? viewModel]) {
    nextEventSubject.add(viewModel ?? const NextEventViewModel());
  }

  void emitNextEventWith({
    List<NextEventPlayerViewModel> goalKeepers = const [],
  }) {
    nextEventSubject.add(NextEventViewModel(
      goalKeepers: goalKeepers,
    ));
  }

  void emitError() {
    nextEventSubject.addError(Error());
  }

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
    "Should present spinner while data is loading",
    (WidgetTester tester) async {

      await tester.pumpWidget(sut);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    "Should hide spinner on load success",
    (WidgetTester tester) async {

      /// When I execute this method I guarantee that I build
      /// this component virtually and it is with that initial image
      /// that it asks to render
      await tester.pumpWidget(sut);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      presenter.emitNextEvent();

      /// So everything that is async (schedule to the future) I need to force my screen to rerender
      /// virtually because has things to happen (new ui). So to do this
      /// update I need to use the .pump method. This will execute the next loop from the event
      /// and will update the screen

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    "Should hide spinner on load error",
    (WidgetTester tester) async {

      /// When I execute this method I guarantee that I build
      /// this component virtually and it is with that initial image
      /// that it asks to render
      await tester.pumpWidget(sut);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      presenter.emitError();

      /// So everything that is async (schedule to the future) I need to force my screen to rerender
      /// virtually because has things to happen (new ui). So to do this
      /// update I need to use the .pump method. This will execute the next loop from the event
      /// and will update the screen

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    "Should present goalkeepers section",
    (WidgetTester tester) async {

      await tester.pumpWidget(sut);

      presenter.emitNextEventWith(
        goalKeepers: const [
          NextEventPlayerViewModel(name: "Rodrigo"),
          NextEventPlayerViewModel(name: "Rafael"),
          NextEventPlayerViewModel(name: "Pedro"),
        ]
      );

      await tester.pump();

      expect(find.text("DENTRO - GOLEIROS"), findsOneWidget);
      expect(find.text("3"), findsOneWidget);
      expect(find.text("Rodrigo"), findsOneWidget);
      expect(find.text("Rafael"), findsOneWidget);
      expect(find.text("Pedro"), findsOneWidget);
    },
  );

  testWidgets(
    "Should hide all sections",
    (WidgetTester tester) async {

      await tester.pumpWidget(sut);

      presenter.emitNextEvent();

      await tester.pump();

      expect(find.text("DENTRO - GOLEIROS"), findsNothing);
    },
  );
}