import 'package:advanced_flutter_course/app/infra/types/json_type.dart';

abstract class HttpGetClient {

  Future<T> get<T>({
    required String url,
    Json? params,
  });
}