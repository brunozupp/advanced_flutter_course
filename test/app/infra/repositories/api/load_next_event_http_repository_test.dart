import 'dart:convert';

import 'package:advanced_flutter_course/app/domain/entities/enums/domain_error.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/load_next_event_http_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';
import 'clients/http_client_spy.dart';

void main() {

  late final String groupId;
  late final String url;
  late HttpClientSpy httpClient;
  late LoadNextEventHttpRepository sut;

  setUpAll(() {
    groupId = anyString();

    url = "https://domain.com/api/groups/:groupId/next_event";
  });

  setUp(() {
    httpClient = HttpClientSpy();

    final mapResponse = <String,dynamic>{
      "groupName": "any name",
      "date": DateTime(2024,8,30,10,30).toIso8601String(),
      "players": [
        {
          "id": "id 1",
          "name": "name 1",
          "isConfirmed": true,
          "photo": null,
          "position": null,
          "confirmationDate": null,
        },
        {
          "id": "id 2",
          "name": "name 2",
          "isConfirmed": false,
          "photo": "photo 2",
          "position": "position 2",
          "confirmationDate": DateTime(2024,8,29,11,00).toIso8601String(),
        },
      ]
    };

    httpClient.responseJson = jsonEncode(mapResponse);

    sut = LoadNextEventHttpRepository(
      httpClient: httpClient,
      url: url,
    );
  });

  test(
    "Should request with correct method",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(httpClient.method, "GET");
      expect(httpClient.callsCount, 1);
    },
  );

  test(
    "Should request with correct url",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(httpClient.url, "https://domain.com/api/groups/$groupId/next_event");
    },
  );

  test(
    "Should request with correct headers",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(httpClient.headers?["content-type"], "application/json");
      expect(httpClient.headers?["accept"], "application/json");
    },
  );

  test(
    "Should return NextEvent on status 200",
    () async {

      final event = await sut.loadNextEvent(groupId: groupId);

      expect(event.groupName, "any name");
      expect(event.date, DateTime(2024,8,30,10,30));

      expect(event.players[0].id, "id 1");
      expect(event.players[0].name, "name 1");
      expect(event.players[0].isConfirmed, true);

      expect(event.players[1].id, "id 2");
      expect(event.players[1].name, "name 2");
      expect(event.players[1].isConfirmed, false);
      expect(event.players[1].position, "position 2");
      expect(event.players[1].photo, "photo 2");
      expect(event.players[1].confirmationDate, DateTime(2024,8,29,11,00));
    },
  );

  /// UnexpectedError is a error from my Domain Layer. This is because
  /// I don't want send an error from infra to my UI Layer, the user
  /// doesn't care about the specific error that occurred.
  test(
    "Should throw UnexpectedError on 400",
    () async {

      /// Arrange
      httpClient.statusCode = 400;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "Should throw SessionExpiredError on 401",
    () async {

      /// Arrange
      httpClient.statusCode = 401;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(DomainError.sessionExpired));
    },
  );

  test(
    "Should throw UnexpectedError on 403",
    () async {

      /// Arrange
      httpClient.statusCode = 403;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "Should throw UnexpectedError on 404",
    () async {

      /// Arrange
      httpClient.statusCode = 404;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "Should throw UnexpectedError on 500",
    () async {

      /// Arrange
      httpClient.statusCode = 500;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}