@Timeout(Duration(seconds: 1))

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';

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

  NextEventRxPresenter({
    required this.nextEventLoader,
  });

  final _nextEventSubject = BehaviorSubject();
  final _isBusyStream = BehaviorSubject<bool>();

  Stream get nextEventStream => _nextEventSubject.stream;
  Stream<bool> get isBusyStream => _isBusyStream.stream;

  Future<void> loadNextEvent({
    required String groupId,
    bool isReload = false,
  }) async {

    try {

      if(isReload) {
        _isBusyStream.add(true);
      }

      await nextEventLoader(groupId: groupId);
    } catch (e) {
      _nextEventSubject.addError(e);

    } finally {
      if(isReload) {
        _isBusyStream.add(false);
      }
    }
  }
}

final class NextEventLoaderUseCaseSpy {

  int callsCount = 0;
  String? groupId;
  Error? error;

  Future<void> call({
    required String groupId,
  }) async {
    this.groupId = groupId;
    callsCount++;

    if(error != null) {
      throw error!;
    }
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

  test(
    "Should emit correct events on reload with error",
    () async {

      /// Arrange
      nextEventLoader.error = Error();

      /// See the explanation to this block of code in the comment below
      /// It's the same as the block below (sugar sintax)
      // sut.nextEventStream.listen(
      //   null,
      //   onError: (error) {
      //     expect(error, nextEventLoader.error);
      //   }
      // );

      /// It works the same as the block of code above. This is just
      /// a sugar sintax to test streams.
      expectLater(
        sut.nextEventStream,
        emitsError(nextEventLoader.error),
      );

      /// I could have had two equal expectLater, but each one with
      /// emits(true/false), this would work two. But I can use the
      /// emitsInOrder to guarantee that it test in the order I passed
      /// in the array
      expectLater(
        sut.isBusyStream,
        emitsInOrder([true, false]),
      );

      /// When my tests in a stream give me an error it will not fail
      /// on time. It will wait 30 seconds. To this, I can change the
      /// timeout passing a new one in the .test method.
      /// Another way of doing this that is more performatic is applying
      /// this change in the top of this file using @Timeout

      /// Act
      await sut.loadNextEvent(
        groupId: groupId,
        isReload: true,
      );

      /// IMPORTANT: Test STREAM
      /// To test a Stream I need to listen to it before the
      /// 'act' part is executed. My Asset (the third part
      /// of the TDD) stays inside the Stream.listen. Because
      /// inside it that I will have access to the values
      /// and so I will put the expects there.
    },
  );

  test(
    "Should emit correct events on load with error",
    () async {

      nextEventLoader.error = Error();

      expectLater(
        sut.nextEventStream,
        emitsError(nextEventLoader.error),
      );

      // If my stream emits any value it will make this test fails
      sut.isBusyStream.listen(neverCalled);

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  test(
    "Should emit correct events on reload with success",
    () async {

      expectLater(
        sut.isBusyStream,
        emitsInOrder([true, false]),
      );

      await sut.loadNextEvent(
        groupId: groupId,
        isReload: true,
      );
    },
  );
}