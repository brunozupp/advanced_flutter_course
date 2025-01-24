@Timeout(Duration(seconds: 1))

import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/presentation/presenters/next_event_presenter.dart';
import 'package:dartx/dartx.dart';
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
      _nextEventSubject.add(_mapEventToViewModel(event));

    } catch (e) {
      _nextEventSubject.addError(e);

    } finally {
      if(isReload) {
        _isBusyStream.add(false);
      }
    }
  }

  NextEventViewModel _mapEventToViewModel(NextEvent event) => NextEventViewModel(
        doubt: event.players
            .where((player) => player.confirmationDate == null)
            .sortedBy((player) => player.name)
            .map(_mapPlayerToViewModel)
            .toList(),
        out: event.players
            .where((player) => player.confirmationDate != null && !player.isConfirmed)
            .sortedBy((player) => player.confirmationDate!)
            .map(_mapPlayerToViewModel)
            .toList(),
        goalKeepers: event.players
            .where((player) => player.confirmationDate != null && player.isConfirmed && player.position == "goalkeeper")
            .sortedBy((player) => player.confirmationDate!)
            .map(_mapPlayerToViewModel)
            .toList(),
        players: event.players
            .where((player) => player.confirmationDate != null && player.isConfirmed && player.position != "goalkeeper")
            .sortedBy((player) => player.confirmationDate!)
            .map(_mapPlayerToViewModel)
            .toList(),
  );

  NextEventPlayerViewModel _mapPlayerToViewModel(NextEventPlayer player) =>
      NextEventPlayerViewModel(
        name: player.name,
        initials: player.initials,
        photo: player.photo,
        position: player.position,
        isConfirmed: player.confirmationDate == null ? null : player.isConfirmed,
      );
}

final class NextEventLoaderUseCaseSpy {

  int callsCount = 0;
  String? groupId;
  Error? error;
  NextEvent output = NextEvent(
    groupName: anyString(),
    date: anyDate(),
    players: [],
  );

  void simulatePlayers(List<NextEventPlayer> players) {
    output = NextEvent(
      groupName: anyString(),
      date: anyDate(),
      players: players,
    );
  }

  Future<NextEvent> call({
    required String groupId,
  }) async {
    this.groupId = groupId;
    callsCount++;

    if(error != null) {
      throw error!;
    }

    return output;
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