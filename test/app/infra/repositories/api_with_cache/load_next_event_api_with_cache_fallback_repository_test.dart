import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api_with_cache/load_next_event_api_with_cache_fallback_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';
import '../../mocks/load_next_event_repository_spy.dart';
import '../cache/mocks/cache_save_client_spy.dart';

void main() {

  late String groupId;
  late String key;
  late LoadNextEventRepositorySpy apiRepo;
  late LoadNextEventRepositorySpy cacheRepo;
  late CacheSaveClientSpy cacheClient;
  late LoadNextEventApiWithCacheFallbackRepository sut;

  setUp(() {
    groupId = anyString();
    key = anyString();
    apiRepo = LoadNextEventRepositorySpy();
    cacheRepo = LoadNextEventRepositorySpy();
    cacheClient = CacheSaveClientSpy();
    sut = LoadNextEventApiWithCacheFallbackRepository(
      key: key,
      cacheClient: cacheClient,
      loadNextEventApi: apiRepo.loadNextEvent,
      loadNextEventCache: cacheRepo.loadNextEvent,
    );
  });

  test(
    "Should load event data from api repo",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(apiRepo.groupId, groupId);
      expect(apiRepo.callsCount, 1);
    },
  );

  test(
    "Should save event data from api on cache",
    () async {

      apiRepo.output = NextEvent(
        groupName: anyString(),
        date: anyDate(),
        players: [
          NextEventPlayer(
            id: anyString(),
            name: anyString(),
            isConfirmed: anyBool(),
          ),
          NextEventPlayer(
            id: anyString(),
            name: anyString(),
            isConfirmed: anyBool(),
            photo: anyString(),
            position: anyString(),
            confirmationDate: anyDate(),
          ),
        ],
      );

      await sut.loadNextEvent(groupId: groupId);

      expect(cacheClient.key, '$key:$groupId');
      expect(cacheClient.value, {
        'groupName': apiRepo.output.groupName,
        'date': apiRepo.output.date,
        'players': [
          {
            // I need to pass even the nullable fields, because it saves as null in cache
            'id': apiRepo.output.players[0].id,
            'name': apiRepo.output.players[0].name,
            'isConfirmed': apiRepo.output.players[0].isConfirmed,
            'photo': apiRepo.output.players[0].photo,
            'position': apiRepo.output.players[0].position,
            'confirmationDate': apiRepo.output.players[0].confirmationDate,
          },
          {
            'id': apiRepo.output.players[1].id,
            'name': apiRepo.output.players[1].name,
            'isConfirmed': apiRepo.output.players[1].isConfirmed,
            'photo': apiRepo.output.players[1].photo,
            'position': apiRepo.output.players[1].position,
            'confirmationDate': apiRepo.output.players[1].confirmationDate,
          },
        ]
      });
    },
  );

  test(
    "Should return api data on success",
    () async {

      final event = await sut.loadNextEvent(groupId: groupId);

      expect(event, apiRepo.output);
    },
  );

  test(
    "Should load event data from cache repo when api fails",
    () async {

      apiRepo.error = Error();

      await sut.loadNextEvent(groupId: groupId);

      expect(cacheRepo.groupId, groupId);
      expect(cacheRepo.callsCount, 1);
    },
  );

  test(
    "Should return cache data when api fails",
    () async {

      apiRepo.error = Error();

      final event = await sut.loadNextEvent(groupId: groupId);

      expect(event, cacheRepo.output);
    },
  );

  /// This test explains how to test an implementation that has two try/catch
  /// One try/catch inside the other one.
  /// I can do using a longer way - commented one
  /// I can do using the expect that is not commented.
  test(
    "Should throw UnexpectedError when api and cache fails",
    () async {

      apiRepo.error = Error();
      cacheRepo.error = Error();

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(isA<UnexpectedError>()));

      // sut.loadNextEvent(groupId: groupId).then(
      //   (_) {},
      //   onError: (error) => expect(
      //     error,
      //     isA<UnexpectedError>(),
      //   ),
      // );
    },
  );
}