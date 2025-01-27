import 'package:advanced_flutter_course/app/ui/pages/widgets/player_photo.dart';
import 'package:advanced_flutter_course/app/ui/pages/widgets/player_position.dart';
import 'package:advanced_flutter_course/app/ui/pages/widgets/player_status.dart';
import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
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
        Padding(
          padding: const EdgeInsets.only(
            left:  16,
            right: 16,
            bottom: 8,
            top: 32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.textStyles.titleSmall,
              ),
              Text(
                players.length.toString(),
                style: context.textStyles.titleSmall,
              ),
            ],
          ),
        ),
        const Divider(),
        ...players.map((player) => Container(
          color: context.colors.scheme.onSurface.withValues(alpha: 0.03),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              PlayerPhoto(
                initials: player.initials,
                photo: player.photo,
              ),

              const SizedBox(
                width: 16,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: context.textStyles.labelLarge,
                    ),
                    PlayerPosition(
                      position: player.position,
                    ),
                  ],
                ),
              ),

              PlayerStatus(
                isConfirmed: player.isConfirmed,
              ),

            ],
          ),
        )).separatedBy(const Divider(indent: 82,)),

        const Divider(),
      ],
    );
  }
}