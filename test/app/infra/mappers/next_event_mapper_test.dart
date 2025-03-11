import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper_list.dart';
import 'package:advanced_flutter_course/app/infra/mappers/next_event_mapper.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';

final class MapperListSpy<Entity> extends MapperList<Entity> {

  dynamic toObjectListInput;
  int toObjectListCallsCount = 0;
  List<Entity> toObjectListOutput;

  List<Entity>? toJsonListInput;
  int toJsonListCallsCount = 0;
  JsonList toJsonListOutput = anyJsonList();

  MapperListSpy({
    required this.toObjectListOutput,
  });

  @override
  JsonList toJsonList(List<Entity> list) {
    toJsonListInput = list;
    toJsonListCallsCount++;
    return toJsonListOutput;
  }

  @override
  List<Entity> toObjectList(dynamic list) {
    toObjectListInput = list;
    toObjectListCallsCount++;
    return toObjectListOutput;
  }

  @override
  Json toJson(Entity entity) => throw UnimplementedError();

  @override
  Entity toObject(json) => throw UnimplementedError();

}

void main() {

  late NextEventMapper sut;
  late MapperListSpy<NextEventPlayer> playerMapper;

  setUp(() {
    playerMapper = MapperListSpy(
      toObjectListOutput: anyNextEventPlayerList(),
    );
    sut = NextEventMapper(
      playerMapper: playerMapper,
    );
  });

  test(
    "Should map to object",
    () {

      final json = <String,dynamic>{
        "groupName": anyString(),
        "date": DateTime(2024,8,30,10,30).toIso8601String(),
        "players": anyJsonList(),
      };

      final event = sut.toObject(json);

      expect(event.groupName, json["groupName"]);
      expect(event.date, DateTime.parse(json["date"]));
      expect(playerMapper.toObjectListInput, json["players"]);
      expect(playerMapper.toObjectListCallsCount, 1);
      expect(event.players, playerMapper.toObjectListOutput);
    },
  );

  test(
    "Should map to json",
    () {

      final object = NextEvent(
        groupName: anyString(),
        date: DateTime(2024, 8, 30, 10, 30),
        players: anyNextEventPlayerList(),
      );

      final json = sut.toJson(object);

      expect(json["groupName"], object.groupName);
      expect(json["date"], object.date.toIso8601String());
      expect(playerMapper.toJsonListInput, object.players);
      expect(playerMapper.toJsonListCallsCount, 1);
      expect(json["players"], playerMapper.toJsonListOutput);
    },
  );
}