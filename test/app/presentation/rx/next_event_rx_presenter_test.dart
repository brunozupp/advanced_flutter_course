@Timeout(Duration(seconds: 1))

import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/presentation/presenters/next_event_presenter.dart';
import 'package:advanced_flutter_course/app/presentation/rx/next_event_rx_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';
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

  /// Doubt list has:
  /// confirmationDate == null
  test(
    "Should build doubt list sorted by name",
    () async {

      nextEventLoader.simulatePlayers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: anyBool(),
          confirmationDate: anyDate(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: anyBool(),
        ),
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.doubt.length, 3);
        expect(event.doubt[0].name, 'A');
        expect(event.doubt[1].name, 'C');
        expect(event.doubt[2].name, 'D');
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  test(
    "Should map doubt player",
    () async {

      final player = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: anyBool(),
        photo: anyString(),
        position: anyString(),
      );

      /// Verify if the map is filling the viewmodel
      /// I will not check the confirmationDate because
      /// to have a doubt list I can not have confirmationDate set

      nextEventLoader.simulatePlayers([
        player,
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.doubt[0].name, player.name);
        expect(event.doubt[0].initials, player.initials);
        expect(event.doubt[0].isConfirmed, null);
        expect(event.doubt[0].photo, player.photo);
        expect(event.doubt[0].position, player.position);
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  /// Out list has:
  /// confirmationDate != null
  /// isConfirmed == false
  test(
    "Should build out list sorted by confirmation date",
    () async {

      nextEventLoader.simulatePlayers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,10),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,11),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,9),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'E',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,12),
        ),
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.out.length, 3);
        expect(event.out[0].name, 'D');
        expect(event.out[1].name, 'C');
        expect(event.out[2].name, 'E');
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  test(
    "Should map out player",
    () async {

      /// I need to guarantee that the isConfirmed is false
      final player = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: false,
        photo: anyString(),
        position: anyString(),
        confirmationDate: anyDate(),
      );

      nextEventLoader.simulatePlayers([
        player,
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.out[0].name, player.name);
        expect(event.out[0].initials, player.initials);
        expect(event.out[0].isConfirmed, player.isConfirmed);
        expect(event.out[0].photo, player.photo);
        expect(event.out[0].position, player.position);
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  /// Goalkeepers list has:
  /// confirmationDate != null
  /// isConfirmed == true
  /// position == goalkeeper
  test(
    "Should build goalkeepers list sorted by confirmation date",
    () async {

      nextEventLoader.simulatePlayers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,10),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,11),
          position: "defender",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,9),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'E',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,12),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'F',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,8),
          position: "goalkeeper",
        ),
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.goalKeepers.length, 2);
        expect(event.goalKeepers[0].name, 'F');
        expect(event.goalKeepers[1].name, 'C');
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  test(
    "Should map goalkeeper",
    () async {

      /// I need to guarantee that the isConfirmed is true
      /// and position == "goalkeeper"
      final player = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: true,
        photo: anyString(),
        position: "goalkeeper",
        confirmationDate: anyDate(),
      );

      nextEventLoader.simulatePlayers([
        player,
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.goalKeepers[0].name, player.name);
        expect(event.goalKeepers[0].initials, player.initials);
        expect(event.goalKeepers[0].isConfirmed, player.isConfirmed);
        expect(event.goalKeepers[0].photo, player.photo);
        expect(event.goalKeepers[0].position, player.position);
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  /// Players list has:
  /// confirmationDate != null
  /// isConfirmed == true
  /// position: it can and can not value
  test(
    "Should build players list sorted by confirmation date",
    () async {

      nextEventLoader.simulatePlayers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,10),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,11),
          position: "defender",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,9),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'E',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,12),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'F',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,8),
          position: "goalkeeper",
        ),
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.players.length, 2);
        expect(event.players[0].name, 'B');
        expect(event.players[1].name, 'E');
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );

  test(
    "Should map player",
    () async {

      /// position can be any value (even null), but not goalkeeper
      final player = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: true,
        photo: anyString(),
        position: anyString(),
        confirmationDate: anyDate(),
      );

      nextEventLoader.simulatePlayers([
        player,
      ]);

      sut.nextEventStream.listen((event) {
        expect(event.players[0].name, player.name);
        expect(event.players[0].initials, player.initials);
        expect(event.players[0].isConfirmed, player.isConfirmed);
        expect(event.players[0].photo, player.photo);
        expect(event.players[0].position, player.position);
      });

      await sut.loadNextEvent(
        groupId: groupId,
      );
    },
  );
}