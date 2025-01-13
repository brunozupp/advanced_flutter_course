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
    Map<String, String?>? params,
    Map<String, String>? queryString,
  }) async {

    final uri = _buildUrl(
      url: url,
      params: params,
      queryString: queryString,
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
    Map<String, String?>? params,
    Map<String, String>? queryString,
  }) {

    var urlToFormat = url;

    params?.forEach((key, value) {

      if(value == null) {
        urlToFormat = urlToFormat.replaceFirst("/:$key", "");
      } else {
        urlToFormat = urlToFormat.replaceFirst(":$key", value);
      }
    });

    final queryStringList = queryString?.entries.toList() ?? [];

    for (var i = 0; i < queryStringList.length; i++) {

      if(i == 0) {
        urlToFormat += "?";
      }

      urlToFormat += "${queryStringList[i].key}=${queryStringList[i].value}";

      if(i < queryStringList.length - 1) {
        urlToFormat += "&";
      }
    }

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

      test(
        "Should request with optional params",
        () async {

          url = "http://anyurl.com/:p1/:p2";

          await sut.get(
            url: url,
            params: {
              "p1": "v1",
              "p2": null,
            },
          );

          expect(client.url, "http://anyurl.com/v1");
        },
      );

      test(
        "Should request with invalid params",
        () async {

          url = "http://anyurl.com/:p1/:p2";

          await sut.get(
            url: url,
            params: {
              "p3": "v3",
            },
          );

          expect(client.url, "http://anyurl.com/:p1/:p2");
        },
      );

      test(
        "Should request with correct query string",
        () async {

          await sut.get(
            url: url,
            queryString: {
              "q1": "v1",
              "q2": "v2",
            },
          );

          expect(client.url, "$url?q1=v1&q2=v2");
        },
      );

      test(
        "Should request with correct query string and params",
        () async {

          url = "http://anyurl.com/:p3/:p4";

          await sut.get(
            url: url,
            queryString: {
              "q1": "v1",
              "q2": "v2",
            },
            params: {
              "p3": "v3",
              "p4": "v4",
            },
          );

          expect(client.url, "http://anyurl.com/v3/v4?q1=v1&q2=v2");
        },
      );
    },
  );


}