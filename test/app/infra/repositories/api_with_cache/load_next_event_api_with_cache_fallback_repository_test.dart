import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/mappers/next_event_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';

final class LoadNextEventApiWithCacheFallbackRepository {

  final Future<NextEvent> Function({
    required String groupId,
  }) _loadNextEventApi;
  final CacheSaveClient _cacheClient;
  final String _key;

  LoadNextEventApiWithCacheFallbackRepository({
    required final Future<NextEvent> Function({
      required String groupId,
    }) loadNextEventApi,
    required CacheSaveClient cacheClient,
    required String key,
  }) : _loadNextEventApi = loadNextEventApi, _cacheClient = cacheClient, _key = key;

  Future<void> loadNextEvent({
    required String groupId,
  }) async {
    final event = await _loadNextEventApi(groupId: groupId);
    final json = NextEventMapper().toJson(event);
    await _cacheClient.save(key: "$_key:$groupId", value: json);
  }
}

final class LoadNextEventApiRepositorySpy {

  String? groupId;
  int callsCounts = 0;

  /// To guarantee that my other tests will have a response of success, but
  /// this response is not important to be checked I can set a default
  /// value to this output here. In the case I want to check the success
  /// scenario where I need to check the values, I will pass a new output
  /// inside the arrange section of my test, so I can have the control to
  /// verify all the values.
  NextEvent output = NextEvent(
    groupName: anyString(),
    date: anyDate(),
    players: [],
  );

  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {
    this.groupId = groupId;
    callsCounts++;
    return output;
  }
}

abstract interface class CacheSaveClient {
  Future<void> save({
    required String key,
    required dynamic value,
  });
}

final class CacheSaveClientSpy implements CacheSaveClient {

  String? key;
  dynamic value;

  @override
  Future<void> save({required String key, required value}) async {
    this.key = key;
    this.value = value;
  }

}

void main() {

  late String groupId;
  late String key;
  late LoadNextEventApiRepositorySpy apiRepo;
  late CacheSaveClientSpy cacheClient;
  late LoadNextEventApiWithCacheFallbackRepository sut;

  setUp(() {
    groupId = anyString();
    key = anyString();
    apiRepo = LoadNextEventApiRepositorySpy();
    cacheClient = CacheSaveClientSpy();
    sut = LoadNextEventApiWithCacheFallbackRepository(
      key: key,
      cacheClient: cacheClient,
      loadNextEventApi: apiRepo.loadNextEvent,
    );
  });

  test(
    "Should load event data from api repo",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(apiRepo.groupId, groupId);
      expect(apiRepo.callsCounts, 1);
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
}