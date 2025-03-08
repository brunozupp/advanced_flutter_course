import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

abstract base class MapperList<T> implements Mapper<T> {

  List<T> toObjectList(dynamic list) => list.map<T>(toObject).toList();

  JsonList toJsonList(List<T> list) => list.map(toJson).toList();
}