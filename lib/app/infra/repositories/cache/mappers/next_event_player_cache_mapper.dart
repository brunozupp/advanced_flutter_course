import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

final class NextEventPlayerCacheMapper extends Mapper<NextEventPlayer> {

  @override
  NextEventPlayer toObject(dynamic json) => NextEventPlayer(
    id: json["id"],
    name: json["name"],
    isConfirmed: json["isConfirmed"],
    photo: json["photo"],
    position: json["position"],
    confirmationDate: json["confirmationDate"],
  );

  Json toJson(NextEventPlayer player) => {
    'id': player.id,
    'name': player.name,
    'position': player.position,
    'photo': player.photo,
    'confirmationDate': player.confirmationDate,
    'isConfirmed': player.isConfirmed,
  };

  JsonList toJsonList(List<NextEventPlayer> list) => list.map(toJson).toList();
}