import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_get_client.dart';

final class LoadNextEventCacheRepository  {

  final CacheGetClient _cacheClient;
  final String _key;
  final Mapper<NextEvent> _mapper;

  const LoadNextEventCacheRepository({
    required CacheGetClient cacheClient,
    required String key,
    required Mapper<NextEvent> mapper,
  })  : _cacheClient = cacheClient,
        _mapper = mapper,
        _key = key;

  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {

    final event = await _cacheClient.get(
      key: "$_key:$groupId",
    );

    if(event == null) {
      throw UnexpectedError();
    }

    return _mapper.toObject(event);
  }
}