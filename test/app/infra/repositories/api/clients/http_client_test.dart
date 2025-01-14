import 'dart:convert';

import 'package:advanced_flutter_course/app/domain/entities/enums/domain_error.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import '../../../../../helpers/fakes.dart';
import 'client_spy.dart';

class HttpClient {

  final Client _client;

  HttpClient({
    required Client client,
  }) : _client = client;

  Future<T?> get<T>({
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

    final response = await _client.get(
      uri,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        if(headers != null) ...headers,
      },
    );

    switch(response.statusCode) {
      case 400:
      case 403:
      case 404:
      case 500:
        throw DomainError.unexpected;
      case 401:
        throw DomainError.sessionExpired;
    }

    if(response.body.isEmpty) {
      return null;
    }

    final responseDecode = jsonDecode(response.body);

    if(T == JsonList) {
      return responseDecode.map<Json>((e) => e as Json).toList();
    }

    return responseDecode;
  }

  Uri _buildUrl({
    required String url,
    Map<String, String?>? params,
    Map<String, String>? queryString,
  }) {

    var urlToFormat = url;

    urlToFormat = params?.keys
      .fold(
        urlToFormat,
        (result, key) =>
            result.replaceFirst(":$key", params[key] ?? ""))
      .removeSuffix("/") ??
    urlToFormat;

    urlToFormat = queryString?.keys
      .fold(
        "$urlToFormat?",
        (result, key) => "$result$key=${queryString[key]}&")
      .removeSuffix("&") ??
    urlToFormat;

    // params?.forEach((key, value) {

    //   if(value == null) {
    //     urlToFormat = urlToFormat.replaceFirst("/:$key", "");
    //   } else {
    //     urlToFormat = urlToFormat.replaceFirst(":$key", value);
    //   }
    // });

    // final queryStringList = queryString?.entries.toList() ?? [];

    // for (var i = 0; i < queryStringList.length; i++) {

    //   if(i == 0) {
    //     urlToFormat += "?";
    //   }

    //   urlToFormat += "${queryStringList[i].key}=${queryStringList[i].value}";

    //   if(i < queryStringList.length - 1) {
    //     urlToFormat += "&";
    //   }
    // }

    return Uri.parse(urlToFormat);
  }
}

void main() {

  late ClientSpy client;
  late HttpClient sut;
  late String url;

  setUp(() {

    client = ClientSpy();
    client.responseJson = jsonEncode(mapNextEvent);

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

      test(
        "Should throw UnexpectedError on 400",
        () async {

          client.statusCode = 400;

          final future = sut.get(url: url);

          expect(future, throwsA(DomainError.unexpected));
        },
      );

      test(
        "Should throw UnexpectedError on 401",
        () async {

          client.statusCode = 401;

          final future = sut.get(url: url);

          expect(future, throwsA(DomainError.sessionExpired));
        },
      );

      test(
        "Should throw UnexpectedError on 403",
        () async {

          client.statusCode = 403;

          final future = sut.get(url: url);

          expect(future, throwsA(DomainError.unexpected));
        },
      );

      test(
        "Should throw UnexpectedError on 404",
        () async {

          client.statusCode = 404;

          final future = sut.get(url: url);

          expect(future, throwsA(DomainError.unexpected));
        },
      );

      test(
        "Should throw UnexpectedError on 500",
        () async {

          client.statusCode = 500;

          final future = sut.get(url: url);

          expect(future, throwsA(DomainError.unexpected));
        },
      );

      test(
        "Should return a Map (typed)",
        () async {

          client.responseJson = jsonEncode({
            "key1": "value1",
            "key2": "value2",
          });

          final data = await sut.get<Json>(url: url);

          expect(data?["key1"], "value1");
          expect(data?["key2"], "value2");
        },
      );

      test(
        "Should return a Map (not typed)",
        () async {

          client.responseJson = jsonEncode({
            "key1": "value1",
            "key2": "value2",
          });

          final data = await sut.get<Json>(url: url);

          expect(data?["key1"], "value1");
          expect(data?["key2"], "value2");
        },
      );

      test(
        "Should return a List of Maps (typed)",
        () async {

          client.responseJson = jsonEncode([
            {
              "key1": "value1.1",
              "key2": "value2.1",
            },
            {
              "key1": "value1.2",
              "key2": "value2.2",
            },
          ]);

          final data = await sut.get<JsonList>(url: url);

          expect(data?[0]["key1"], "value1.1");
          expect(data?[0]["key2"], "value2.1");

          expect(data?[1]["key1"], "value1.2");
          expect(data?[1]["key2"], "value2.2");
        },
      );

      test(
        "Should return a List of Maps (not typed)",
        () async {

          client.responseJson = jsonEncode([
            {
              "key1": "value1.1",
              "key2": "value2.1",
            },
            {
              "key1": "value1.2",
              "key2": "value2.2",
            },
          ]);

          final data = await sut.get(url: url);

          expect(data[0]["key1"], "value1.1");
          expect(data[0]["key2"], "value2.1");

          expect(data[1]["key1"], "value1.2");
          expect(data[1]["key2"], "value2.2");
        },
      );

      test(
        "Should return null on 200 with empty response",
        () async {

          client.responseJson = "";
          client.statusCode = 200;

          final data = await sut.get(url: url);

          expect(data, isNull);
        },
      );

    },
  );

}