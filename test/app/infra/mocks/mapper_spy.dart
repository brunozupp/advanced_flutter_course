import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

import '../../../mocks/fakes.dart';

final class MapperSpy<Entity> implements Mapper<Entity> {

  Json? toObjectInput;
  int toObjectInputCallsCount = 0;
  Entity toObjectOutput;

  Json toJsonOutput = anyJson();
  int toJsonCallsCount = 0;
  Entity? toJsonInput;

  MapperSpy({
    required this.toObjectOutput,
  });

  @override
  Json toJson(Entity entity) {
    toJsonInput = entity;
    toJsonCallsCount++;
    return toJsonOutput;
  }

  @override
  Entity toObject(json) {
    toObjectInput = json;
    toObjectInputCallsCount++;
    return toObjectOutput;
  }
}