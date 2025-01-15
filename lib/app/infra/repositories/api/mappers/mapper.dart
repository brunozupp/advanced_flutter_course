import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

/// This implementation has one benefit and one fail
/// Benefit: I just need to implement the method toObject and
/// every class that implements Mapper will only override the
/// toObject method and will gain the ability to do the parse
/// to a list of objects.
/// Fail: the fail is the benefit itself, because some classes
/// will not need the toObjectList. So, I will put more things
/// to my class than it needs to work properly.
///
/// So this solution is something to be balenced and verify
/// if is something good to implement.
///
/// TODO: I can do a test about the I from SOLID, where I can
/// divide this implementation in Mapper and MapperList, which
/// MapperList will be a generic that extends from Mapper. This
/// can be a solution to avoid a class has more methods than
/// necessary
///
abstract base class Mapper<T> {

  List<T> toObjectList(JsonList list) => list.map(toObject).toList();

  T toObject(Json json);
}