import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api_with_cache/load_next_event_api_with_cache_fallback_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';
import '../../mocks/load_next_event_repository_spy.dart';
import '../../mocks/mapper_spy.dart';
import '../cache/mocks/cache_save_client_mock.dart';

void main() {

  late String groupId;
  late String key;
  late LoadNextEventRepositorySpy apiRepo;
  late LoadNextEventRepositorySpy cacheRepo;
  late CacheSaveClientMock cacheClient;
  late LoadNextEventApiWithCacheFallbackRepository sut;
  late MapperSpy<NextEvent> mapper;

  setUp(() {
    groupId = anyString();
    key = anyString();
    apiRepo = LoadNextEventRepositorySpy();
    cacheRepo = LoadNextEventRepositorySpy();
    cacheClient = CacheSaveClientMock();
    mapper = MapperSpy(
      toObjectOutput: anyNextEvent(),
    );
    sut = LoadNextEventApiWithCacheFallbackRepository(
      key: key,
      cacheClient: cacheClient,
      loadNextEventApi: apiRepo.loadNextEvent,
      loadNextEventCache: cacheRepo.loadNextEvent,
      mapper: mapper,
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

      await sut.loadNextEvent(groupId: groupId);

      expect(cacheClient.key, '$key:$groupId');
      expect(cacheClient.value, mapper.toJsonOutput);
      expect(mapper.toJsonInput, apiRepo.output);
      expect(mapper.toJsonCallsCount, 1);
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
    "Should rethrow api error when it's SessionExpiredError",
    () async {

      apiRepo.error = SessionExpiredError();

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(apiRepo.error));
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

  test(
    "Should rethrow cache error when api and cache fails",
    () async {

      apiRepo.error = Error();
      cacheRepo.error = Error();

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(cacheRepo.error));
    },
  );
}