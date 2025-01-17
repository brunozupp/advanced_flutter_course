import 'package:advanced_flutter_course/app/ui/pages/widgets/player_photo.dart';
import 'package:advanced_flutter_course/app/ui/pages/widgets/player_position.dart';
import 'package:advanced_flutter_course/app/ui/pages/widgets/player_status.dart';
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
        ...players.map((player) => Row(
          children: [
            Text(player.name),
            PlayerPosition(
              position: player.position,
            ),
            PlayerStatus(
              isConfirmed: player.isConfirmed,
            ),
            PlayerPhoto(
              initials: player.initials,
              photo: player.photo,
            ),
          ],
        )),
      ],
    );
  }
}