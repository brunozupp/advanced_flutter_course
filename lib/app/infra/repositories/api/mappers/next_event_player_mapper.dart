import '../../../../domain/entities/next_event_player.dart';
import '../../../types/json_type.dart';

final class NextEventPlayerMapper {

  NextEventPlayerMapper._();

  static NextEventPlayer toObject(Json map) => NextEventPlayer(
    id: map["id"],
    name: map["name"],
    isConfirmed: map["isConfirmed"],
    photo: map["photo"],
    position: map["position"],
    confirmationDate: DateTime.tryParse(map["confirmationDate"] ?? ""),
  );

  static List<NextEventPlayer> toObjectList(JsonList list) {
    return list.map(toObject).toList();
  }
}