import 'package:advanced_flutter_course/app/infra/mappers/mapper_list.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

import '../../../mocks/fakes.dart';

final class MapperListSpy<Entity> extends MapperList<Entity> {

  dynamic toObjectListInput;
  int toObjectListCallsCount = 0;
  List<Entity> toObjectListOutput;

  List<Entity>? toJsonListInput;
  int toJsonListCallsCount = 0;
  JsonList toJsonListOutput = anyJsonList();

  MapperListSpy({
    required this.toObjectListOutput,
  });

  @override
  JsonList toJsonList(List<Entity> list) {
    toJsonListInput = list;
    toJsonListCallsCount++;
    return toJsonListOutput;
  }

  @override
  List<Entity> toObjectList(dynamic list) {
    toObjectListInput = list;
    toObjectListCallsCount++;
    return toObjectListOutput;
  }

  @override
  Json toJson(Entity entity) => throw UnimplementedError();

  @override
  Entity toObject(json) => throw UnimplementedError();
}