import '../entities/next_event.dart';

abstract interface class ILoadNextEventRepository {

  Future<NextEvent> loadNextEvent({required String groupId});
}