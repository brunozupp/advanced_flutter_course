import 'dart:convert';

import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/adapters/http_adapter.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/fakes.dart';
import '../clients/client_spy.dart';


void main() {

  late ClientSpy client;
  late HttpAdapter sut;
  late String url;

  setUp(() {

    client = ClientSpy();
    client.responseJson = jsonEncode(mapNextEvent);

    sut = HttpAdapter(
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
              "custom-header-three": 123,
            }
          );

          expect(client.headers?["custom-header-one"], "value-custom-header-one");
          expect(client.headers?["custom-header-two"], "value-custom-header-two");
          expect(client.headers?["custom-header-three"], "123");
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

          expect(future, throwsA(isA<UnexpectedError>()));
        },
      );

      test(
        "Should throw UnexpectedError on 401",
        () async {

          client.statusCode = 401;

          final future = sut.get(url: url);

          expect(future, throwsA(isA<SessionExpiredError>()));
        },
      );

      test(
        "Should throw UnexpectedError on 403",
        () async {

          client.statusCode = 403;

          final future = sut.get(url: url);

          expect(future, throwsA(isA<UnexpectedError>()));
        },
      );

      test(
        "Should throw UnexpectedError on 404",
        () async {

          client.statusCode = 404;

          final future = sut.get(url: url);

          expect(future, throwsA(isA<UnexpectedError>()));
        },
      );

      test(
        "Should throw UnexpectedError on 500",
        () async {

          client.statusCode = 500;

          final future = sut.get(url: url);

          expect(future, throwsA(isA<UnexpectedError>()));
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

      test(
        "Should return null on 204",
        () async {

          client.statusCode = 204;
          client.responseJson = "";

          final data = await sut.get(url: url);

          expect(data, isNull);
        },
      );

    },
  );

}