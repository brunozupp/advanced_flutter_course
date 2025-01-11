import '../../../../domain/entities/next_event.dart';
import '../../../types/json_type.dart';
import 'next_event_player_mapper.dart';

final class NextEventMapper {

  NextEventMapper._();

  static NextEvent toObject(Json map) => NextEvent(
    groupName: map["groupName"],
    date: DateTime.parse(map["date"]),
    players: NextEventPlayerMapper.toObjectList(map["players"])
  );
}