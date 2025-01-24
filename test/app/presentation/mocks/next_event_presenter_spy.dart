import 'package:advanced_flutter_course/app/presentation/presenters/next_event_presenter.dart';
import 'package:rxdart/subjects.dart';

final class NextEventPresenterSpy implements NextEventPresenter {

  int callsCount = 0;
  String? groupId;
  bool? isReload;
  final nextEventSubject = BehaviorSubject<NextEventViewModel>();
  final isBusySubject = BehaviorSubject<bool>();

  @override
  Stream<NextEventViewModel> get nextEventStream => nextEventSubject.stream;

  @override
  Stream<bool> get isBusyStream => isBusySubject.stream;

  /// These emit methods are just to the spy

  void emitNextEvent([NextEventViewModel? viewModel]) {
    nextEventSubject.add(viewModel ?? const NextEventViewModel());
  }

  void emitNextEventWith({
    List<NextEventPlayerViewModel> goalKeepers = const [],
    List<NextEventPlayerViewModel> players = const [],
    List<NextEventPlayerViewModel> out = const [],
    List<NextEventPlayerViewModel> doubt = const [],
  }) {
    nextEventSubject.add(NextEventViewModel(
      goalKeepers: goalKeepers,
      players: players,
      out: out,
      doubt: doubt,
    ));
  }

  void emitError() {
    nextEventSubject.addError(Error());
  }

  void emitIsBusy([bool isBusy = true]) {
    isBusySubject.add(isBusy);
  }

  @override
  Future<void> loadNextEvent({
    required String groupId,
    bool isReload = false,
  }) async {
    callsCount++;
    this.groupId = groupId;
    this.isReload = isReload;
  }
}