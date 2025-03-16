@Timeout(Duration(seconds: 1)) library;

import 'package:advanced_flutter_course/app/presentation/rx/next_event_rx_presenter.dart';
import 'package:advanced_flutter_course/app/presentation/view_models/next_event_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../../domain/mocks/next_event_loader_use_case_spy.dart';


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

      expectLater(
        sut.nextEventStream,
        emits(const TypeMatcher<NextEventViewModel>()),
      );

      await sut.loadNextEvent(
        groupId: groupId,
        isReload: true,
      );
    },
  );

  test(
    "Should emit correct events on load with success",
    () async {

      sut.isBusyStream.listen(neverCalled);

      expectLater(
        sut.nextEventStream,
        emits(const TypeMatcher<NextEventViewModel>()),
      );

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );
}