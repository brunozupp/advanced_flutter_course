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

    presenter.isBusyStream.listen((isBusy) {
      isBusy ? showLoading() : hideLoading();
    });
  }

  /// I am using this just to accelerate my job because of the hot reload
  /// from flutter that when executed runs the build method again and
  /// rebuild the screen. Doing this, my Stream comes back to the waiting
  /// state and will no longer show the list. This happens because the
  /// initState where I run the load method to send data to the Stream
  /// executes just once before the first build of the page.
  /// And this method didUpdateWidget executes everytime my .build method
  /// executes.
  /// Uncomment this block of code when doing tests in this page about
  /// development.
  // @override
  // void didUpdateWidget(covariant NextEventPage oldWidget) {
  //   presenter.loadNextEvent(groupId: widget.groupId);

  //   presenter.isBusyStream.listen((isBusy) {
  //     isBusy ? showLoading() : hideLoading();
  //   });

  //   super.didUpdateWidget(oldWidget);
  // }

  void showLoading() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void hideLoading() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Game"),
      ),
      body: StreamBuilder<NextEventViewModel>(
        stream: presenter.nextEventStream,
        builder: (context, snapshot) {

          /// After receiving for the first time a value inside this stream
          /// its state stays like .active forever. Only if an error occurrs is
          /// that this state will change, otherwise it will be .active forever
          /// So the state .waiting is just when I built the component and no
          /// value enters in this stream.
          /// Said that, this initial state will only happens one time
          if(snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError) {
            return NextEventErrorLayout(
              onRetry: () {
                presenter.loadNextEvent(
                  groupId: widget.groupId,
                  isReload: true,
                );
              },
            );
          }

          final nextEvent = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              presenter.loadNextEvent(
                groupId: widget.groupId,
                isReload: true,
              );
            },
            child: ListView(
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
            ),
          );
        },
      ),
    );
  }
}