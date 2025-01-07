import '../entities/next_event.dart';
import '../repositories/i_load_next_event_repository.dart';

class NextEventLoaderUseCase {

  final ILoadNextEventRepository _loadNextEventRepository;

  NextEventLoaderUseCase({
    required ILoadNextEventRepository loadNextEventRepository,
  }) : _loadNextEventRepository = loadNextEventRepository;

  Future<NextEvent> call({required String groupId}) async {
    return await _loadNextEventRepository.loadNextEvent(groupId: groupId);
  }
}