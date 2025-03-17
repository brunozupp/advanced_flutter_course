import 'package:advanced_flutter_course/app/infra/repositories/api/clients/http_get_client.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_get_client.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

/// This implementation was made following the Decorator Design Pattern
/// so it is obeying the Open/Closed Principle.
final class AuthorizedHttpGetClient implements HttpGetClient {

  final CacheGetClient _cacheClient;
  final HttpGetClient _httpClient;

  const AuthorizedHttpGetClient({
    required CacheGetClient cacheClient,
    required HttpGetClient httpClient,
  }) : _cacheClient = cacheClient, _httpClient = httpClient;

  @override
  Future<dynamic> get({
    required String url,
    Json? params,
    Json? queryString,
    Json? headers,
  }) async {
    final authorizedHeader = await _cacheClient.get(key: 'current_user');

    if(authorizedHeader != null && authorizedHeader['accessToken'] != null) {
      headers ??= {};
      headers.addAll({
        'authorization': authorizedHeader['accessToken'],
      });
    }

    return await _httpClient.get(
      url: url,
      params: params,
      queryString: queryString,
      headers: headers,
    );
  }
}