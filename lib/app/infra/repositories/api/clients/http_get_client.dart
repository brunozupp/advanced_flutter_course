import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

abstract interface class HttpGetClient {

  Future<T?> get<T>({
    required String url,
    Json? headers,
    Json? params,
    Json? queryString,
  });
}