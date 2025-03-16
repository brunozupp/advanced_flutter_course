import 'package:advanced_flutter_course/app/infra/repositories/api/clients/http_get_client.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_get_client.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/fakes.dart';
import '../../cache/mocks/cache_get_client_spy.dart';
import '../mocks/http_get_client_spy.dart';

final class AuthorizedHttpGetClient implements HttpGetClient {

  final CacheGetClient _cacheClient;
  final HttpGetClient _httpClient;

  const AuthorizedHttpGetClient({
    required CacheGetClient cacheClient,
    required HttpGetClient httpClient,
  }) : _cacheClient = cacheClient, _httpClient = httpClient;

  @override
  Future<dynamic> get({
    required String url,
    Json? params,
    Json? queryString,
    Json? headers,
  }) async {
    final authorizedHeader = await _cacheClient.get(key: 'current_user');

    if(authorizedHeader != null && authorizedHeader['accessToken'] != null) {
      headers ??= {};
      headers.addAll({
        'authorization': authorizedHeader['accessToken'],
      });
    }

    return await _httpClient.get(
      url: url,
      params: params,
      queryString: queryString,
      headers: headers,
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
  late Json headers;

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
    headers = anyJson();
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

  test(
    "Should call HttpClient with null headers",
    () async {
      cacheClient.response = null;
      await sut.get(
        url: url,
        headers: null,
      );
      expect(httpClient.headers, null);
    },
  );

  test(
    "Should call HttpClient with current headers",
    () async {
      cacheClient.response = null;
      await sut.get(
        url: url,
        headers: headers,
      );
      expect(httpClient.headers, headers);
    },
  );

  test(
    "Should call HttpClient with authorization header",
    () async {
      cacheClient.response = {
        'accessToken': 'any_token',
      };
      await sut.get(
        url: url,
        headers: null,
      );
      expect(
        httpClient.headers,
        {
          'authorization': 'any_token',
        },
      );
    },
  );

  test(
    "Should call HttpClient with authorization header and current headers",
    () async {
      cacheClient.response = {
        'accessToken': 'any_token',
      };
      await sut.get(
        url: url,
        headers: headers,
      );
      expect(
        httpClient.headers,
        {
          ...headers,
          'authorization': 'any_token',
        },
      );
    },
  );

  test(
    "Should call HttpClient with invalid cache",
    () async {
      cacheClient.response = {
        'invalid': 'invalid',
      };
      await sut.get(
        url: url,
        headers: headers,
      );
      expect(
        httpClient.headers,
        {
          ...headers,
        },
      );
    },
  );

  test(
    "Should call HttpClient with invalid cache and null headers",
    () async {
      cacheClient.response = {
        'invalid': 'invalid',
      };
      await sut.get(
        url: url,
        headers: null,
      );
      expect(
        httpClient.headers,
        null,
      );
    },
  );

  test(
    "Should rethrow on CacheClient error",
    () async {
      final error = Error();
      cacheClient.error = error;
      final future = sut.get(
        url: url,
      );
      expect(
        future,
        throwsA(error),
      );
    },
  );

  test(
    "Should rethrow on HttpClient error",
    () async {
      final error = Error();
      httpClient.error = error;
      final future = sut.get(
        url: url,
      );
      expect(
        future,
        throwsA(error),
      );
    },
  );

  test(
    "Should return same result as HttpClient",
    () async {

      final response = await sut.get(
        url: url,
        headers: headers,
      );
      expect(
        response,
        httpClient.response,
      );
    },
  );
}