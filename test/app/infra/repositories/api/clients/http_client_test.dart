import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'client_spy.dart';

class HttpClient {

  final Client _client;

  HttpClient({
    required Client client,
  }) : _client = client;

  Future<void> get() async {
    await _client.get(Uri());
  }
}

void main() {

  test(
    "Should request with correct method",
    () async {

      final client = ClientSpy();

      final sut = HttpClient(
        client: client,
      );

      await sut.get();

      expect(client.method, "get");
      expect(client.callsCount, 1);
    },
  );
}