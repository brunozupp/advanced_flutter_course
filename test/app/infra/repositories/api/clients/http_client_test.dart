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

  late ClientSpy client;
  late HttpClient sut;

  setUp(() {
    client = ClientSpy();

    sut = HttpClient(
      client: client,
    );
  });

  test(
    "Should request with correct method",
    () async {

      await sut.get();

      expect(client.method, "GET");
      expect(client.callsCount, 1);
    },
  );
}