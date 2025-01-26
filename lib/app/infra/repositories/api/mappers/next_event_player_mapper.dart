import '../../../../domain/entities/next_event_player.dart';
import '../../../types/json_type.dart';
import 'mapper.dart';

final class NextEventPlayerMapper extends Mapper<NextEventPlayer> {

  @override
  NextEventPlayer toObject(dynamic json) => NextEventPlayer(
    id: json["id"],
    name: json["name"],
    isConfirmed: json["isConfirmed"],
    photo: json["photo"],
    position: json["position"],
    confirmationDate: DateTime.tryParse(json["confirmationDate"] ?? ""),
  );
}