import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';

final class CacheGetClientSpy implements CacheGetClient {

  String? key;
  int callsCount = 0;

  @override
  Future<void> get({
    required String key,
  }) async {
    this.key = key;
    callsCount++;
  }
}

abstract interface class CacheGetClient {

  Future<void> get({
    required String key,
  });
}

final class LoadNextEventCacheRepository  {

  final CacheGetClient _cacheClient;
  final String _key;

  const LoadNextEventCacheRepository({
    required CacheGetClient cacheClient,
    required String key,
  })  : _cacheClient = cacheClient,
        _key = key;

  Future<void> loadNextEvent({
    required String groupId,
  }) async {

    await _cacheClient.get(
      key: "$_key:$groupId",
    );
  }
}

void main() {

  late String groupId;
  late String key;
  late CacheGetClientSpy cacheClient;
  late LoadNextEventCacheRepository sut;

  setUp(() {

    groupId = anyString();
    key = anyString();

    cacheClient = CacheGetClientSpy();

    // httpClient.response = mapNextEvent;

    sut = LoadNextEventCacheRepository(
      cacheClient: cacheClient,
      key: key,
    );
  });

  test(
    "Should call CacheClient with correct input",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      /// Because I can have more than one group (key), I need to concatenate
      /// the groupId to identify which group I want to select.
      expect(cacheClient.key, '$key:$groupId');
      expect(cacheClient.callsCount, 1);
    },
  );
}