import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_save_client.dart';

final class CacheSaveClientMock implements CacheSaveClient {

  String? key;
  dynamic value;

  @override
  Future<void> save({required String key, required value}) async {
    this.key = key;
    this.value = value;
  }
}