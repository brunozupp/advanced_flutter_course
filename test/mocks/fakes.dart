import 'dart:math';

import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

int anyInt() => Random().nextInt(999999999);

String anyString() => anyInt.toString();

bool anyBool() => Random().nextBool();

DateTime anyDate() => DateTime.fromMillisecondsSinceEpoch(anyInt());
String anyIsoDate() => DateTime.fromMillisecondsSinceEpoch(anyInt()).toIso8601String();

Json get mapNextEventApi => {
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

/// With the mock in cache I can save the Date as an object. No need to parse
/// in and out from the class.
Json get mapNextEventCache => {
  "groupName": "any name",
  "date": DateTime(2024,1,1,10,30),
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
      "confirmationDate": DateTime(2024,1,1,12,30),
    },
  ]
};