import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper_list.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

final class NextEventMapper implements Mapper<NextEvent> {

  final MapperList<NextEventPlayer> playerMapper;

  const NextEventMapper({
    required this.playerMapper,
  });

  @override
  NextEvent toObject(dynamic json) => NextEvent(
    groupName: json["groupName"],
    date: DateTime.parse(json["date"]),
    players: playerMapper.toObjectList(json["players"])
  );

  @override
  Json toJson(NextEvent entity) => {
    'groupName': entity.groupName,
    'date': entity.date.toIso8601String(),
    'players': playerMapper.toJsonList(entity.players)
  };
}