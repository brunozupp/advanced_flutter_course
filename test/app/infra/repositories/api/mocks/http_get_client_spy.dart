import 'package:advanced_flutter_course/app/infra/repositories/api/clients/http_get_client.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

final class HttpGetClientSpy implements HttpGetClient {

  String? url;
  int callsCount = 0;
  Json? params;
  Json? queryString;
  Json? headers;
  dynamic response;
  Error? error;

  @override
  Future<dynamic> get({
    required String url,
    Json? headers,
    Json? params,
    Json? queryString,
  }) async {
    this.url = url;
    callsCount++;
    this.params = params;
    this.queryString = queryString;
    this.headers = headers;

    if(error != null) {
      throw error!;
    }

    return response;
  }
}