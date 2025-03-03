import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';

import '../../../../domain/entities/next_event.dart';
import 'next_event_player_api_mapper.dart';

final class NextEventApiMapper extends Mapper<NextEvent> {

  @override
  NextEvent toObject(dynamic json) => NextEvent(
    groupName: json["groupName"],
    date: DateTime.parse(json["date"]),
    players: NextEventPlayerApiMapper().toObjectList(json["players"])
  );
}