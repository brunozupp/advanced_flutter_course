import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';

import '../../../domain/entities/next_event.dart';
import '../../../domain/repositories/i_load_next_event_repository.dart';
import 'clients/http_get_client.dart';
import 'mappers/next_event_mapper.dart';

final class LoadNextEventApiRepository implements ILoadNextEventRepository {

  final HttpGetClient _httpClient;
  final String _url;

  const LoadNextEventApiRepository({
    required HttpGetClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {
    final event = await _httpClient.get(
      url: _url,
      params: {
        "groupId": groupId,
      },
    );

    if(event == null) {
      throw UnexpectedError();
    }

    return NextEventMapper().toObject(event);
  }
}