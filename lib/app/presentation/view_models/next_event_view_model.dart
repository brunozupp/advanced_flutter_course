import '../../domain/entities/next_event.dart';
import 'next_event_player_view_model.dart';

final class NextEventViewModel {

  final List<NextEventPlayerViewModel> goalKeepers;
  final List<NextEventPlayerViewModel> players;
  final List<NextEventPlayerViewModel> out;
  final List<NextEventPlayerViewModel> doubt;

  const NextEventViewModel({
    this.goalKeepers = const [],
    this.players = const [],
    this.out = const [],
    this.doubt = const [],
  });

  // _mapEventToViewModel
  factory NextEventViewModel.fromEntity(NextEvent event) =>
    NextEventViewModel(
      doubt: NextEventPlayerViewModel.filterDoubtPlayers(event.players),
      out: NextEventPlayerViewModel.filterOutPlayers(event.players),
      goalKeepers: NextEventPlayerViewModel.filterGoalkeepers(event.players),
      players: NextEventPlayerViewModel.filterPlayers(event.players),
    );
}