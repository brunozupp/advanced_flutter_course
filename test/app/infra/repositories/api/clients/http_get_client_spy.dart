import 'package:advanced_flutter_course/app/infra/repositories/api/clients/http_get_client.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

class HttpGetClientSpy implements HttpGetClient {

  String? url;
  int callsCount = 0;
  Json? params;
  dynamic response;
  Error? error;

  @override
  Future<T> get<T>({
    required String url,
    Json? params,
  }) async {
    this.url = url;
    callsCount++;
    this.params = params;

    if(error != null) {
      throw error!;
    }

    return response;
  }
}