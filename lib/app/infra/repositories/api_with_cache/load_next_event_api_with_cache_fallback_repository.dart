import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/infra/mappers/mapper.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_save_client.dart';

typedef LoadNextEventRepository = Future<NextEvent> Function({
  required String groupId,
});

final class LoadNextEventApiWithCacheFallbackRepository {

  final LoadNextEventRepository _loadNextEventApi;
  final LoadNextEventRepository _loadNextEventCache;
  final CacheSaveClient _cacheClient;
  final String _key;
  final Mapper<NextEvent> _mapper;

  LoadNextEventApiWithCacheFallbackRepository({
    required final Future<NextEvent> Function({
      required String groupId,
    }) loadNextEventApi,
    required final Future<NextEvent> Function({
      required String groupId,
    }) loadNextEventCache,
    required CacheSaveClient cacheClient,
    required String key,
    required Mapper<NextEvent> mapper,
  })  : _loadNextEventApi = loadNextEventApi,
        _loadNextEventCache = loadNextEventCache,
        _cacheClient = cacheClient,
        _mapper = mapper,
        _key = key;

  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {
    try {
      final event = await _loadNextEventApi(groupId: groupId);
      final json = _mapper.toJson(event);
      await _cacheClient.save(key: "$_key:$groupId", value: json);
      return event;
    } on SessionExpiredError {
      rethrow;
    } catch (error) {
      return await _loadNextEventCache(groupId: groupId);
    }
  }
}