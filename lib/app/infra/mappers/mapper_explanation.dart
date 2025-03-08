import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

/// Explanation about the implementation of Mappers
/// In the context of this application It's Ok this solution because
/// I am working with saving the information I receive from the API
/// inside the cache. So in every Entity I would have a feature of
/// parsing to/from json. The only difference would be that some
/// entities I would need the list methods to do this. And using the
/// Interface Segregation Principle I can do like the code below
/// to separate the interface which I just have the parse from 1:1
/// and to cases where I need to use the list method of the Mapper
/// during the parse.
abstract interface class Mapper<T> {

  T toObject(dynamic json);

  Json toJson(T entity);
}

abstract base class MapperList<T> implements Mapper<T> {

  List<T> toObjectList(dynamic list) => list.map<T>(toObject).toList();

  JsonList toJsonList(List<T> list) => list.map(toJson).toList();
}

/// Another context would be if my application doesn't have the
/// feature to save in the cache or if only some APIs would be
/// allowed to save the information inside the cache. In this scenario
/// I would need to have a more complex use of the Interface Segregation
/// which I would focus in the action of the parse (to/from something) as
/// the example below.
/// This guarantees to me that I can have just what I will need in each Mapper
abstract interface class MapperToObject<T> {

  T toObject(dynamic json);
}

abstract base class MapperToObjectList<T> implements MapperToObject<T> {

  List<T> toObjectList(dynamic list) => list.map<T>(toObject).toList();
}

abstract interface class MapperToJson<T> {

  Json toJson(T entity);
}

abstract base class MapperToJsonList<T> implements MapperToJson<T> {

  JsonList toJsonList(List<T> list) => list.map(toJson).toList();
}