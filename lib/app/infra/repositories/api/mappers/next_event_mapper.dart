import 'package:advanced_flutter_course/app/infra/repositories/api/mappers/mapper.dart';

import '../../../../domain/entities/next_event.dart';
import '../../../types/json_type.dart';
import 'next_event_player_mapper.dart';

final class NextEventMapper extends Mapper<NextEvent> {

  @override
  NextEvent toObject(Json json) => NextEvent(
    groupName: json["groupName"],
    date: DateTime.parse(json["date"]),
    players: NextEventPlayerMapper().toObjectList(json["players"])
  );
}