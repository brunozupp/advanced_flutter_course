import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';

final class NextEventPlayerMapper extends Mapper<NextEventPlayer> {

  @override
  NextEventPlayer toObject(dynamic json) => NextEventPlayer(
    id: json["id"],
    name: json["name"],
    isConfirmed: json["isConfirmed"],
    photo: json["photo"],
    position: json["position"],
    confirmationDate: json["confirmationDate"],
  );
}