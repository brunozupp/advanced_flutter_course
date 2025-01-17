import 'package:flutter/material.dart';

final class PlayerStatus extends StatelessWidget {

  final bool? isConfirmed;

  const PlayerStatus({
    super.key,
    this.isConfirmed,
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
    _ => Colors.grey,
  };
}