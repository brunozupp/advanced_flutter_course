import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper_list.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

final class NextEventPlayerMapper extends MapperList<NextEventPlayer> {

  @override
  NextEventPlayer toObject(dynamic json) => NextEventPlayer(
    id: json["id"],
    name: json["name"],
    isConfirmed: json["isConfirmed"],
    photo: json["photo"],
    position: json["position"],
    confirmationDate: json["confirmationDate"] != null
        ? DateTime.parse(json["confirmationDate"])
        : null,
  );

  @override
  Json toJson(NextEventPlayer entity) => {
    'id': entity.id,
    'name': entity.name,
    'position': entity.position,
    'photo': entity.photo,
    'confirmationDate': entity.confirmationDate?.toIso8601String(),
    'isConfirmed': entity.isConfirmed,
  };
}