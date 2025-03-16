import 'package:dartx/dartx.dart';

import '../../domain/entities/next_event_player.dart';

final class NextEventPlayerViewModel {

  final String name;
  final String initials;
  final String? photo;
  final String? position;
  final bool? isConfirmed;

  const NextEventPlayerViewModel({
    required this.name,
    required this.initials,
    this.position,
    this.isConfirmed,
    this.photo,
  });

  factory NextEventPlayerViewModel.fromEntity(NextEventPlayer player) =>
    NextEventPlayerViewModel(
      name: player.name,
      initials: player.initials,
      photo: player.photo,
      position: player.position,
      isConfirmed: player.confirmationDate == null ? null : player.isConfirmed,
    );

  static List<NextEventPlayerViewModel> _convertToListViewModel(
    Iterable<NextEventPlayer> players,
  ) => players.map(NextEventPlayerViewModel.fromEntity).toList();

  static List<NextEventPlayerViewModel> filterDoubtPlayers(
    List<NextEventPlayer> players,
  ) {
    return _convertToListViewModel(
      players.where((player) => player.confirmationDate == null)
            .sortedBy((player) => player.name),
    );
  }

  static List<NextEventPlayerViewModel> filterOutPlayers(
    List<NextEventPlayer> players,
  ) {
    return _convertToListViewModel(
      players
            .where((player) => player.confirmationDate != null && !player.isConfirmed)
            .sortedBy((player) => player.confirmationDate!),
    );
  }

  static List<NextEventPlayerViewModel> filterGoalkeepers(
    List<NextEventPlayer> players,
  ) {
    return _convertToListViewModel(
      players
            .where((player) => player.confirmationDate != null && player.isConfirmed && player.position == "goalkeeper")
            .sortedBy((player) => player.confirmationDate!),
    );
  }

  static List<NextEventPlayerViewModel> filterPlayers(
    List<NextEventPlayer> players,
  ) {
    return _convertToListViewModel(
      players.where((player) => player.confirmationDate != null && player.isConfirmed && player.position != "goalkeeper")
            .sortedBy((player) => player.confirmationDate!),
    );
  }
}