import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_get_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../cache/mocks/cache_get_client_spy.dart';

final class AuthorizedHttpGetClient {

  final CacheGetClient _cacheClient;

  const AuthorizedHttpGetClient({
    required CacheGetClient cacheClient,
  }) : _cacheClient = cacheClient;

  Future<void> get() async {
    await _cacheClient.get(key: 'current_user');
  }
}

void main() {

  CacheGetClientSpy cacheClient;
  AuthorizedHttpGetClient sut;

  setUp(() {
    cacheClient = CacheGetClientSpy();
    sut = AuthorizedHttpGetClient(
      cacheClient: cacheClient,
    );
  });

  test(
    "Should call CacheClient with correct input",
    () async {

      cacheClient = CacheGetClientSpy();
      sut = AuthorizedHttpGetClient(
        cacheClient: cacheClient,
      );
      await sut.get();
      expect(cacheClient.callsCount, 1);
      expect(cacheClient.key, 'current_user');
    },
  );
}