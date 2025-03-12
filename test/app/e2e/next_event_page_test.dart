import 'dart:convert';

import 'package:advanced_flutter_course/app/core/factories/mapper_factory.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/adapters/http_adapter.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/load_next_event_api_repository.dart';
import 'package:advanced_flutter_course/app/presentation/rx/next_event_rx_presenter.dart';
import 'package:advanced_flutter_course/app/ui/pages/next_event/next_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakes.dart';
import '../infra/repositories/api/mocks/client_spy.dart';

void main() {

  testWidgets(
    "Should present next event page",
    (WidgetTester tester) async {

      final client = ClientSpy();

      client.responseJson = _getResponseJson();

      final httpClient = HttpAdapter(client: client);
      final repository = LoadNextEventApiRepository(
        httpClient: httpClient,
        url: anyString(),
        mapper: MapperFactory.makeNextEventMapper(),
      );
      final presenter = NextEventRxPresenter(nextEventLoader: repository.loadNextEvent);

      final sut = MaterialApp(
        home: NextEventPage(
          presenter: presenter,
          groupId: anyString(),
        ),
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      /// I need to use ensureVisible because of my UI, as the list will not
      /// show the elements without scrolling. And the method
      /// ensureVisible asks to put the skipOffstage in the element it
      /// will ensure visibility.
      /// And after this I need to use the pump method to update the frames
      /// from the screen
      await tester.ensureVisible(find.text("Cristiano Ronaldo", skipOffstage: false));
      await tester.pump();
      expect(find.text("Cristiano Ronaldo"), findsOneWidget);

      await tester.ensureVisible(find.text("Lionel Messi", skipOffstage: false));
      await tester.pump();
      expect(find.text("Lionel Messi"), findsOneWidget);

      await tester.ensureVisible(find.text("Claudio Gamarra", skipOffstage: false));
      await tester.pump();
      expect(find.text("Claudio Gamarra"), findsOneWidget);
    },
  );
}

  String _getResponseJson() {
    return jsonEncode({
      "id": "1",
      "groupName": "Pelada Chega+",
      "date": "2024-01-11T11:10:00.000Z",
      "players": [
        {
          "id": "1",
          "name": "Cristiano Ronaldo",
          "position": "forward",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T11:07:00.000Z"
        },
        {
          "id": "2",
          "name": "Lionel Messi",
          "position": "midfielder",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T11:08:00.000Z"
        },
        {
          "id": "3",
          "name": "Dida",
          "position": "goalkeeper",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T09:10:00.000Z"
        },
        {
          "id": "4",
          "name": "Romario",
          "position": "forward",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T11:10:00.000Z"
        },
        {
          "id": "5",
          "name": "Claudio Gamarra",
          "position": "defender",
          "isConfirmed": false,
          "confirmationDate": "2024-01-10T13:10:00.000Z"
        },
        {
          "id": "6",
          "name": "Diego Forlan",
          "position": "defender",
          "isConfirmed": false,
          "confirmationDate": "2024-01-10T14:10:00.000Z"
        },
        {
          "id": "7",
          "name": "Zé Ninguém",
          "isConfirmed": false
        },
        {
          "id": "8",
          "name": "Rodrigo Manguinho",
          "isConfirmed": false
        },
        {
          "id": "9",
          "name": "Claudio Taffarel",
          "position": "goalkeeper",
          "isConfirmed": true,
          "confirmationDate": "2024-01-10T09:15:00.000Z"
        },
      ],
    });
  }