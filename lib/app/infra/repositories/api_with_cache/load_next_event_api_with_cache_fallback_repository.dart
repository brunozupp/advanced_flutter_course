import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_save_client.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/mappers/next_event_cache_mapper.dart';

final class LoadNextEventApiWithCacheFallbackRepository {

  final Future<NextEvent> Function({
    required String groupId,
  }) _loadNextEventApi;
  final Future<NextEvent> Function({
    required String groupId,
  }) _loadNextEventCache;
  final CacheSaveClient _cacheClient;
  final String _key;

  LoadNextEventApiWithCacheFallbackRepository({
    required final Future<NextEvent> Function({
      required String groupId,
    }) loadNextEventApi,
    required final Future<NextEvent> Function({
      required String groupId,
    }) loadNextEventCache,
    required CacheSaveClient cacheClient,
    required String key,
  })  : _loadNextEventApi = loadNextEventApi,
        _loadNextEventCache = loadNextEventCache,
        _cacheClient = cacheClient,
        _key = key;

  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {
    try {
      final event = await _loadNextEventApi(groupId: groupId);
      final json = NextEventCacheMapper().toJson(event);
      await _cacheClient.save(key: "$_key:$groupId", value: json);
      return event;
    } catch (_) {
      try {
        return await _loadNextEventCache(groupId: groupId);
      } catch (_) {
        throw UnexpectedError();
      }
    }
  }
}