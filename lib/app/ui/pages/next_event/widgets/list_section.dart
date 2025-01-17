import 'package:flutter/material.dart';

import '../../../../presentation/presenters/next_event_presenter.dart';

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