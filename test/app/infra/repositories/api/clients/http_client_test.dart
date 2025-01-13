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
    Map<String, String>? headers,
    Map<String, String>? params,
  }) async {

    final uri = _buildUrl(
      url: url,
      params: params,
    );

    await _client.get(
      uri,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        if(headers != null) ...headers,
      },
    );
  }

  Uri _buildUrl({
    required String url,
    Map<String, String>? params,
  }) {

    var urlToFormat = url;

    params?.forEach((key, value) {
      urlToFormat = urlToFormat.replaceFirst(":$key", value);
    });

    return Uri.parse(urlToFormat);
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

      test(
        "Should request with default headers",
        () async {

          await sut.get(
            url: url,
          );

          expect(client.headers?["content-type"], "application/json");
          expect(client.headers?["accept"], "application/json");
        },
      );

      test(
        "Should append headers",
        () async {

          await sut.get(
            url: url,
            headers: {
              "custom-header-one": "value-custom-header-one",
              "custom-header-two": "value-custom-header-two",
            }
          );

          expect(client.headers?["custom-header-one"], "value-custom-header-one");
          expect(client.headers?["custom-header-two"], "value-custom-header-two");
        },
      );

      test(
        "Should request with correct params",
        () async {

          url = "http://anyurl.com/:p1/:p2";

          await sut.get(
            url: url,
            params: {
              "p1": "v1",
              "p2": "v2",
            },
          );

          expect(client.url, "http://anyurl.com/v1/v2");
        },
      );
    },
  );


}