import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

final class MapperSpy<Entity> implements Mapper<Entity> {

  Json? toObjectInput;
  int toObjectInputCallsCount = 0;
  Entity toObjectOutput;

  MapperSpy({
    required this.toObjectOutput
  });

  @override
  Json toJson(Entity entity) => throw UnimplementedError();

  @override
  Entity toObject(json) {
    toObjectInput = json;
    toObjectInputCallsCount++;
    return toObjectOutput;
  }
}