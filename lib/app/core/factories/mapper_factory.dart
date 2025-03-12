import 'package:advanced_flutter_course/app/infra/mappers/next_event_mapper.dart';
import 'package:advanced_flutter_course/app/infra/mappers/next_event_player_mapper.dart';

final class MapperFactory {

  MapperFactory._();

  static NextEventMapper makeNextEventMapper() {
    return NextEventMapper(
      playerMapper: NextEventPlayerMapper(),
    );
  }
}