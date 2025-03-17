import 'package:advanced_flutter_course/app/infra/repositories/api/adapters/http_adapter.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/clients/authorized_http_get_client.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/adapters/cache_manager_adapter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';

final class CommonFactory {

  CommonFactory._();

  static HttpAdapter makeHttpAdapter() {
    return HttpAdapter(
      client: Client(),
    );
  }

  static CacheManagerAdapter makeCacheManagerAdapter() {
    return CacheManagerAdapter(
      client: DefaultCacheManager(),
    );
  }

  static AuthorizedHttpGetClient makeAuthorizedHttpGetClient() {
    return AuthorizedHttpGetClient(
      cacheClient: makeCacheManagerAdapter(),
      httpClient: makeHttpAdapter(),
    );
  }
}