import 'dart:math';

String anyString() => Random().nextInt(3000).toString();

bool anyBool() => Random().nextBool();

DateTime anyDate() => DateTime.fromMillisecondsSinceEpoch(Random().nextInt(99999999));

Map<String, dynamic> get mapNextEvent => {
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