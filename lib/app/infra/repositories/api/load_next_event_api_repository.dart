import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';

import '../../../domain/entities/next_event.dart';
import 'clients/http_get_client.dart';

/// Because I don't have an usecase to be depended on an abstraction of a
/// repository, I don't need to use an interface here to implement this
/// repository, as I am using the method.signature to pass the action
/// to my Presenter. So doing this interface is redudant.
/// So I can have a repository without an interface
final class LoadNextEventApiRepository  {

  final HttpGetClient _httpClient;
  final String _url;
  final Mapper<NextEvent> _mapper;

  const LoadNextEventApiRepository({
    required HttpGetClient httpClient,
    required String url,
    required Mapper<NextEvent> mapper,
  })  : _httpClient = httpClient,
        _mapper = mapper,
        _url = url;

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

    return _mapper.toObject(event);
  }
}