import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

abstract interface class HttpGetClient {

  Future<dynamic> get({
    required String url,
    Json? headers,
    Json? params,
    Json? queryString,
  });
}