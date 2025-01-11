import '../../../domain/entities/next_event.dart';
import '../../../domain/repositories/i_load_next_event_repository.dart';
import '../../types/json_type.dart';
import 'clients/http_get_client.dart';
import 'mappers/next_event_mapper.dart';

class LoadNextEventApiRepository implements ILoadNextEventRepository {

  final HttpGetClient _httpClient;
  final String _url;

  LoadNextEventApiRepository({
    required HttpGetClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {
    final event = await _httpClient.get<Json>(
      url: _url,
      params: {
        "groupId": groupId,
      },
    );

    return NextEventMapper.toObject(event);
  }
}