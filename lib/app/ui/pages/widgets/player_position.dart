import 'package:flutter/material.dart';

final class PlayerPosition extends StatelessWidget {

  final String? position;

  const PlayerPosition({
    super.key,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Text(buildPositionLabel());
  }

  String buildPositionLabel() => switch(position) {
    "goalkeeper" => "Goleiro",
    "defender" => "Zagueiro",
    "midfielder" => "Meia",
    "forward" => "Atacante",
    _ => "Gandula"
  };
}