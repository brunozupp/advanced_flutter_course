import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import '../../../../../helpers/fakes.dart';
import 'client_spy.dart';

class HttpClient {

  final Client _client;

  HttpClient({
    required Client client,
  }) : _client = client;

  Future<void> get({
    required String url,
  }) async {
    await _client.get(Uri.parse(url));
  }
}

void main() {

  late ClientSpy client;
  late HttpClient sut;
  late String url;

  setUp(() {

    client = ClientSpy();

    sut = HttpClient(
      client: client,
    );

    url = anyString();
  });

  group(
    "Tests from .get method",
    () {
      test(
        "Should request with correct method",
        () async {

          await sut.get(
            url: url,
          );

          expect(client.method, "GET");
          expect(client.callsCount, 1);
        },
      );

      test(
        "Should request with correct url",
        () async {

          await sut.get(
            url: url,
          );

          expect(client.url, url);
        },
      );
    },
  );


}