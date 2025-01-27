import 'package:advanced_flutter_course/app/infra/repositories/api/adapters/http_adapter.dart';
import 'package:http/http.dart';

final class CommonFactory {

  CommonFactory._();

  static HttpAdapter makeHttpAdapter() {
    return HttpAdapter(
      client: Client(),
    );
  }
}