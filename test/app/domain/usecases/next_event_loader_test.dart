import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/domain/repositories/i_load_next_event_repository.dart';
import 'package:advanced_flutter_course/app/domain/usecases/next_event_loader_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';
import '../../infra/mocks/load_next_event_repository_spy.dart';

void main() {

  late final ILoadNextEventRepository repository;
  late final NextEventLoaderUseCase sut;

  late final String groupId;

  setUpAll(() {

    groupId = anyString();

    repository = LoadNextEventRepositorySpy()
      ..output = NextEvent(
        groupName: "any group name",
        date: DateTime.now(),
        players: [
          NextEventPlayer(
            id: "any id 1",
            name: "any name 1",
            isConfirmed: true,
            photo: "any photo 1",
            confirmationDate: DateTime.now(),
          ),
          NextEventPlayer(
            id: "any id 2",
            name: "any name 2",
            isConfirmed: false,
            position: "any position 2",
            confirmationDate: DateTime.now(),
          ),
        ],
      );

    sut = NextEventLoaderUseCase(
      loadNextEventRepository: repository,
    );
  });

  test(
    "Should load event data from a repository",
    () async {

      await sut(
        groupId: groupId,
      );

      expect((repository as LoadNextEventRepositorySpy).groupId, groupId);
      expect((repository as LoadNextEventRepositorySpy).callsCount, 1);
    },
  );

  test(
    "Should return event data on success",
    () async {

      final event = await sut(
        groupId: groupId,
      );

      final repoParsed = (repository as LoadNextEventRepositorySpy);

      expect(event.groupName, repoParsed.output?.groupName);
      expect(event.date, repoParsed.output?.date);
      expect(event.players.length, repoParsed.output?.players.length);

      expect(event.players[0].id, repoParsed.output?.players[0].id);
      expect(event.players[0].name, repoParsed.output?.players[0].name);
      expect(event.players[0].initials, isNotEmpty);
      expect(event.players[0].photo, repoParsed.output?.players[0].photo);
      expect(event.players[0].isConfirmed, repoParsed.output?.players[0].isConfirmed);
      expect(event.players[0].confirmationDate, repoParsed.output?.players[0].confirmationDate);

      expect(event.players[1].id, repoParsed.output?.players[1].id);
      expect(event.players[1].name, repoParsed.output?.players[1].name);
      expect(event.players[1].initials, isNotEmpty);
      expect(event.players[1].position, repoParsed.output?.players[1].position);
      expect(event.players[1].isConfirmed, repoParsed.output?.players[1].isConfirmed);
      expect(event.players[1].confirmationDate, repoParsed.output?.players[1].confirmationDate);

    },
  );

  test(
    "Should rethrow on error",
    () async {

      final repoParsed = (repository as LoadNextEventRepositorySpy);

      final error = Error();

      repoParsed.error = error;

      final future = sut(
        groupId: groupId,
      );

      expect(future, throwsA(error));
    },
  );
}