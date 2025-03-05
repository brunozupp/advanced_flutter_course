import 'dart:convert';
import 'dart:typed_data';

import 'package:advanced_flutter_course/app/infra/repositories/cache/clients/cache_get_client.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../clients/cache_save_client.dart';

final class CacheManagerAdapter implements CacheGetClient, CacheSaveClient {

  final BaseCacheManager client;

  CacheManagerAdapter({
    required this.client,
  });

  @override
  Future<dynamic> get({
    required String key,
  }) async {
    try {

      final fileInfo = await client.getFileFromCache(key);

      if(fileInfo?.validTill.isBefore(DateTime.now()) != false) return null;

      if(!(await fileInfo!.file.exists())) return null;

      final data = await fileInfo.file.readAsString();

      return jsonDecode(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save({
    required String key,
    required dynamic value,
  }) async {
    await client.putFile(key, utf8.encode(jsonEncode(value)), fileExtension: "json");
  }
}