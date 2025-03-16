import 'package:advanced_flutter_course/app/infra/repositories/api/clients/http_get_client.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_get_client.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/fakes.dart';
import '../../cache/mocks/cache_get_client_spy.dart';
import '../mocks/http_get_client_spy.dart';

final class AuthorizedHttpGetClient {

  final CacheGetClient _cacheClient;
  final HttpGetClient _httpClient;

  const AuthorizedHttpGetClient({
    required CacheGetClient cacheClient,
    required HttpGetClient httpClient,
  }) : _cacheClient = cacheClient, _httpClient = httpClient;

  Future<void> get({
    required String url,
    Json? params,
    Json? queryString,
  }) async {
    await _cacheClient.get(key: 'current_user');
    await _httpClient.get(
      url: url,
      params: params,
      queryString: queryString,
    );
  }
}

void main() {

  late CacheGetClientSpy cacheClient;
  late HttpGetClientSpy httpClient;
  late AuthorizedHttpGetClient sut;
  late String url;
  late Json params;
  late Json queryString;

  setUp(() {
    cacheClient = CacheGetClientSpy();
    httpClient = HttpGetClientSpy();
    sut = AuthorizedHttpGetClient(
      cacheClient: cacheClient,
      httpClient: httpClient,
    );
    url = anyString();
    params = anyJson();
    queryString = anyJson();
  });

  test(
    "Should call CacheClient with correct input",
    () async {

      await sut.get(url: url);
      expect(cacheClient.callsCount, 1);
      expect(cacheClient.key, 'current_user');
    },
  );

  test(
    "Should call HttpClient with correct input",
    () async {
      await sut.get(
        url: url,
        params: params,
        queryString: queryString,
      );
      expect(httpClient.callsCount, 1);
      expect(httpClient.url, url);
      expect(httpClient.params, params);
      expect(httpClient.queryString, queryString);
    },
  );
}