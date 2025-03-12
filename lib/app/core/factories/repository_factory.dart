import 'package:advanced_flutter_course/app/core/constants.dart';
import 'package:advanced_flutter_course/app/core/factories/common_factory.dart';
import 'package:advanced_flutter_course/app/core/factories/mapper_factory.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/load_next_event_api_repository.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api_with_cache/load_next_event_api_with_cache_fallback_repository.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/load_next_event_cache_repository.dart';

final class RepositoryFactory {

  RepositoryFactory._();

  static LoadNextEventApiRepository makeLoadNextEventApiRepository() {
    return LoadNextEventApiRepository(
      httpClient: CommonFactory.makeHttpAdapter(),
      url: "${Constants.BASE_URL}/groups/:groupId/next_event",
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


}