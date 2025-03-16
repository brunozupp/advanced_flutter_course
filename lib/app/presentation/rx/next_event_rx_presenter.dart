import 'package:advanced_flutter_course/app/presentation/view_models/next_event_view_model.dart';
import 'package:rxdart/subjects.dart';

import '../../domain/entities/next_event.dart';
import '../presenters/next_event_presenter.dart';

/// There is no need to have an abstraction from the Usecase to be passed
/// to the Presenter as it is only one method. But to not let the Presenter
/// tyed with the concrete class Usecase I can just pass the signature from
/// the call method inside that usecase. Doing this I don't couple the
/// concrete class inside the Presenter and I can change its implementation
/// by just calling another usecase with the same method's signature. And
/// this is good to test too as I don't need to depend on a concrete class.
/// Summarizing I will depend on a function and not on a concrete class.
///
/// But the usecase is a layer that is abstracted enough. It's rare the
/// time I will have 2 implementations from a usecase. That's why I
/// don't create an interface to the usecase. And I gain in the unit test
/// because I isolate the tests from mappers that were inside this file's test
/// so everytime I have another implementation of this Presenter I don't need
/// to write all my mapper tests again.
final class NextEventRxPresenter implements NextEventPresenter {

  final Future<NextEvent> Function({
    required String groupId,
  }) nextEventLoader;

  NextEventRxPresenter({
    required this.nextEventLoader,
  });

  final _nextEventSubject = BehaviorSubject<NextEventViewModel>();
  final _isBusyStream = BehaviorSubject<bool>();

  @override
  Stream<NextEventViewModel> get nextEventStream => _nextEventSubject.stream;

  @override
  Stream<bool> get isBusyStream => _isBusyStream.stream;

  @override
  Future<void> loadNextEvent({
    required String groupId,
    bool isReload = false,
  }) async {

    try {

      if(isReload) {
        _isBusyStream.add(true);
      }

      final event = await nextEventLoader(groupId: groupId);
      _nextEventSubject.add(NextEventViewModel.fromEntity(event));

    } catch (e) {
      _nextEventSubject.addError(e);

    } finally {
      if(isReload) {
        _isBusyStream.add(false);
      }
    }
  }
}