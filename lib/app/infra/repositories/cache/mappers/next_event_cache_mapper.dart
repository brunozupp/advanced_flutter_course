import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/mappers/next_event_player_cache_mapper.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

final class NextEventCacheMapper extends Mapper<NextEvent> {

  @override
  NextEvent toObject(dynamic json) => NextEvent(
    groupName: json["groupName"],
    date: json["date"],
    players: NextEventPlayerCacheMapper().toObjectList(json["players"])
  );

  Json toJson(NextEvent event) => {
    'groupName': event.groupName,
    'date': event.date,
    'players': NextEventPlayerCacheMapper().toJsonList(event.players)
  };
}