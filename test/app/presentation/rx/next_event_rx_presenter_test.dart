import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

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
/// don't create an interface to the usecase.
final class NextEventRxPresenter {

  final Future<void> Function({
    required String groupId,
  }) nextEventLoader;

  const NextEventRxPresenter({
    required this.nextEventLoader,
  });

  Future<void> loadNextEvent({
    required String groupId,
  }) async {
    await nextEventLoader(groupId: groupId);
  }
}

final class NextEventLoaderUseCaseSpy {

  int callsCount = 0;
  String? groupId;

  Future<void> call({
    required String groupId,
  }) async {
    this.groupId = groupId;
    callsCount++;
  }
}

void main() {

  late NextEventLoaderUseCaseSpy nextEventLoader;
  late String groupId;
  late NextEventRxPresenter sut;

  setUp(() {
    nextEventLoader = NextEventLoaderUseCaseSpy();

    groupId = anyString();

    sut = NextEventRxPresenter(
      //nextEventLoader: nextEventLoader, // Tear-off pointer like this will work too
      nextEventLoader: nextEventLoader.call, // Tear-off pointer
    );
  });

  test(
    "Should get event data",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(nextEventLoader.callsCount, 1);
      expect(nextEventLoader.groupId, groupId);
    },
  );
}