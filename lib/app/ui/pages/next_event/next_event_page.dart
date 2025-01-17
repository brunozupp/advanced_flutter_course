import 'package:advanced_flutter_course/app/ui/pages/next_event/widgets/next_event_error_layout.dart';
import 'package:flutter/material.dart';

import '../../../presentation/presenters/next_event_presenter.dart';
import 'widgets/list_section.dart';

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

          if(snapshot.hasError) return const NextEventErrorLayout();

          final nextEvent = snapshot.data!;

          return ListView(
            children: [
              Visibility(
                visible: nextEvent.goalKeepers.isNotEmpty,
                child: ListSection(
                  title: "DENTRO - GOLEIROS",
                  players: nextEvent.goalKeepers,
                ),
              ),

              Visibility(
                visible: nextEvent.players.isNotEmpty,
                child: ListSection(
                  title: "DENTRO - JOGADORES",
                  players: nextEvent.players,
                ),
              ),

              Visibility(
                visible: nextEvent.out.isNotEmpty,
                child: ListSection(
                  title: "FORA",
                  players: nextEvent.out,
                ),
              ),

              Visibility(
                visible: nextEvent.doubt.isNotEmpty,
                child: ListSection(
                  title: "DÚVIDA",
                  players: nextEvent.doubt,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}