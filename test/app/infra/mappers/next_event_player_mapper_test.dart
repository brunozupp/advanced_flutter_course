import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/mappers/next_event_player_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';

void main() {

  late NextEventPlayerMapper sut;

  setUp(() {
    sut = NextEventPlayerMapper();
  });

  test(
    "Should map to object",
    () {

      final json = {
        "id": anyString(),
        "name": anyString(),
        "isConfirmed": anyBool(),
        "photo": anyString(),
        "position": anyString(),
        "confirmationDate": anyIsoDate(),
      };

      final player = sut.toObject(json);

      expect(json["id"], player.id);
      expect(json["name"], player.name);
      expect(json["isConfirmed"], player.isConfirmed);
      expect(json["position"], player.position);
      expect(json["photo"], player.photo);
      expect(json["confirmationDate"], player.confirmationDate!.toIso8601String());
    },
  );

  test(
    "Should map to object with only required fields",
    () {

      final json = {
        "id": anyString(),
        "name": anyString(),
        "isConfirmed": anyBool(),
      };

      final player = sut.toObject(json);

      expect(json["id"], player.id);
      expect(json["name"], player.name);
      expect(json["isConfirmed"], player.isConfirmed);
      expect(json["position"], null);
      expect(json["photo"], null);
      expect(json["confirmationDate"], null);
    },
  );

  test(
    "Should map to json",
    () {

      final player = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: anyBool(),
        photo: anyString(),
        position: anyString(),
        confirmationDate: anyDate(),
      );

      final json = sut.toJson(player);

      expect(json["id"], player.id);
      expect(json["name"], player.name);
      expect(json["isConfirmed"], player.isConfirmed);
      expect(json["position"], player.position);
      expect(json["photo"], player.photo);
      expect(json["confirmationDate"], player.confirmationDate!.toIso8601String());
    },
  );

  test(
    "Should map to json with only required fields",
    () {

      final player = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: anyBool(),
      );

      final json = sut.toJson(player);

      expect(json["id"], player.id);
      expect(json["name"], player.name);
      expect(json["isConfirmed"], player.isConfirmed);
      expect(json["position"], null);
      expect(json["photo"], null);
      expect(json["confirmationDate"], null);
    },
  );
}