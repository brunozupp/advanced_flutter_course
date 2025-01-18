abstract interface class NextEventPresenter {

  Stream<NextEventViewModel> get nextEventStream;

  Stream<bool> get isBusyStream;

  void loadNextEvent({
    required String groupId,
  });

  void reloadNextEvent({
    required String groupId,
  });
}

/// Because these ViewModels are a direct dependency from NextEventPresenter
/// I can let these 2 inside the presenter's file. It means that these
/// viewmodels are used just inside this presenter/view.
/// But I could have created another directory inside presentation named
/// view_models and put these 2 if I wanted.
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
}

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
}