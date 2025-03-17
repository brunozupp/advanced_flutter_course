import 'package:advanced_flutter_course/app/core/factories/common_factory.dart';
import 'package:advanced_flutter_course/app/core/factories/mapper_factory.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/load_next_event_api_repository.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api_with_cache/load_next_event_api_with_cache_fallback_repository.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/load_next_event_cache_repository.dart';

final class RepositoryFactory {

  RepositoryFactory._();

  static LoadNextEventApiRepository makeLoadNextEventApiRepository() {
    return LoadNextEventApiRepository(
      /// The factory from the Decorator implementation
      /// Here I am respecting the Liskov principle that says I can
      /// replace a class if both have the same interface
      httpClient: CommonFactory.makeAuthorizedHttpGetClient(),
      //httpClient: CommonFactory.makeHttpAdapter(),
      url: "${CommonFactory.makeBaseUrl()}/groups/:groupId/next_event",
      mapper: MapperFactory.makeNextEventMapper(),
    );
  }

  static LoadNextEventCacheRepository makeLoadNextEventCacheRepository() {
    return LoadNextEventCacheRepository(
      cacheClient: CommonFactory.makeCacheManagerAdapter(),
      key: "next_event",
      mapper: MapperFactory.makeNextEventMapper(),
    );
  }

  static LoadNextEventApiWithCacheFallbackRepository makeLoadNextEventApiWithCacheFallbackRepository() {
    return LoadNextEventApiWithCacheFallbackRepository(
      cacheClient: CommonFactory.makeCacheManagerAdapter(),
      key: "next_event",
      mapper: MapperFactory.makeNextEventMapper(),
      loadNextEventApi: makeLoadNextEventApiRepository().loadNextEvent,
      loadNextEventCache: makeLoadNextEventCacheRepository().loadNextEvent,
    );
  }
}