import 'dart:convert';
import 'dart:typed_data';

import 'package:file/file.dart' as filePlugin;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/fakes.dart';

final class CacheManagerAdapter {

  final BaseCacheManager client;

  CacheManagerAdapter({
    required this.client,
  });

  Future<dynamic> get({
    required String key,
  }) async {
    await client.getFileFromCache(key);
    return null;
  }
}

final class FileSpy implements filePlugin.File {
  @override
  filePlugin.File get absolute => throw UnimplementedError();

  @override
  String get basename => throw UnimplementedError();

  @override
  Future<filePlugin.File> copy(String newPath) => throw UnimplementedError();

  @override
  filePlugin.File copySync(String newPath) => throw UnimplementedError();

  @override
  Future<filePlugin.File> create({bool recursive = false, bool exclusive = false}) => throw UnimplementedError();

  @override
  void createSync({bool recursive = false, bool exclusive = false}) => throw UnimplementedError();

  @override
  Future<filePlugin.FileSystemEntity> delete({bool recursive = false}) => throw UnimplementedError();

  @override
  void deleteSync({bool recursive = false}) => throw UnimplementedError();

  @override
  String get dirname => throw UnimplementedError();

  @override
  Future<bool> exists() => throw UnimplementedError();

  @override
  bool existsSync() => throw UnimplementedError();

  @override
  filePlugin.FileSystem get fileSystem => throw UnimplementedError();

  @override
  bool get isAbsolute => throw UnimplementedError();

  @override
  Future<DateTime> lastAccessed() => throw UnimplementedError();

  @override
  DateTime lastAccessedSync() => throw UnimplementedError();

  @override
  Future<DateTime> lastModified() => throw UnimplementedError();

  @override
  DateTime lastModifiedSync() => throw UnimplementedError();

  @override
  Future<int> length() => throw UnimplementedError();

  @override
  int lengthSync() => throw UnimplementedError();

  @override
  Future<filePlugin.RandomAccessFile> open({filePlugin.FileMode mode = filePlugin.FileMode.read}) => throw UnimplementedError();

  @override
  Stream<List<int>> openRead([int? start, int? end]) => throw UnimplementedError();

  @override
  filePlugin.RandomAccessFile openSync({filePlugin.FileMode mode = filePlugin.FileMode.read}) => throw UnimplementedError();

  @override
  filePlugin.IOSink openWrite({filePlugin.FileMode mode = filePlugin.FileMode.write, Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  filePlugin.Directory get parent => throw UnimplementedError();

  @override
  String get path => throw UnimplementedError();

  @override
  Future<Uint8List> readAsBytes() => throw UnimplementedError();

  @override
  Uint8List readAsBytesSync() => throw UnimplementedError();

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  Future<String> readAsString({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  String readAsStringSync({Encoding encoding = utf8}) => throw UnimplementedError();

  @override
  Future<filePlugin.File> rename(String newPath) => throw UnimplementedError();

  @override
  filePlugin.File renameSync(String newPath) => throw UnimplementedError();

  @override
  Future<String> resolveSymbolicLinks() => throw UnimplementedError();

  @override
  String resolveSymbolicLinksSync() => throw UnimplementedError();

  @override
  Future setLastAccessed(DateTime time) => throw UnimplementedError();

  @override
  void setLastAccessedSync(DateTime time) => throw UnimplementedError();

  @override
  Future setLastModified(DateTime time) => throw UnimplementedError();

  @override
  void setLastModifiedSync(DateTime time) => throw UnimplementedError();

  @override
  Future<filePlugin.FileStat> stat() => throw UnimplementedError();

  @override
  filePlugin.FileStat statSync() => throw UnimplementedError();

  @override
  Uri get uri => throw UnimplementedError();

  @override
  Stream<filePlugin.FileSystemEvent> watch({int events = filePlugin.FileSystemEvent.all, bool recursive = false}) => throw UnimplementedError();

  @override
  Future<filePlugin.File> writeAsBytes(List<int> bytes, {filePlugin.FileMode mode = filePlugin.FileMode.write, bool flush = false}) => throw UnimplementedError();

  @override
  void writeAsBytesSync(List<int> bytes, {filePlugin.FileMode mode = filePlugin.FileMode.write, bool flush = false}) => throw UnimplementedError();

  @override
  Future<filePlugin.File> writeAsString(String contents, {filePlugin.FileMode mode = filePlugin.FileMode.write, Encoding encoding = utf8, bool flush = false}) => throw UnimplementedError();

  @override
  void writeAsStringSync(String contents, {filePlugin.FileMode mode = filePlugin.FileMode.write, Encoding encoding = utf8, bool flush = false}) => throw UnimplementedError();

}

final class CacheManagerSpy implements BaseCacheManager {

  int getFileFromCacheCallsCount = 0;
  String? key;
  bool _isFileInfoEmpty = false;

  void simulateEmptyFileInfo() => _isFileInfoEmpty = true;

  @override
  Future<void> dispose() => throw UnimplementedError();

  @override
  Future<FileInfo> downloadFile(String url, {String? key, Map<String, String>? authHeaders, bool force = false}) => throw UnimplementedError();

  @override
  Future<void> emptyCache() => throw UnimplementedError();

  @override
  Stream<FileInfo> getFile(String url, {String? key, Map<String, String>? headers}) => throw UnimplementedError();

  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) async {
    getFileFromCacheCallsCount++;
    this.key = key;

    return _isFileInfoEmpty ? null : FileInfo(FileSpy(), FileSource.Cache, DateTime.now(), '');
  }

  @override
  Future<FileInfo?> getFileFromMemory(String key) => throw UnimplementedError();

  @override
  Stream<FileResponse> getFileStream(String url, {String? key, Map<String, String>? headers, bool? withProgress}) => throw UnimplementedError();

  @override
  Future<filePlugin.File> getSingleFile(String url, {String? key, Map<String, String>? headers}) => throw UnimplementedError();

  @override
  Future<filePlugin.File> putFile(String url, Uint8List fileBytes, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) => throw UnimplementedError();

  @override
  Future<filePlugin.File> putFileStream(String url, Stream<List<int>> source, {String? key, String? eTag, Duration maxAge = const Duration(days: 30), String fileExtension = 'file'}) => throw UnimplementedError();

  @override
  Future<void> removeFile(String key) => throw UnimplementedError();

}

void main() {

  late String key;
  late CacheManagerSpy client;
  late CacheManagerAdapter sut;

  setUp(() {
    key = anyString();
    client = CacheManagerSpy();
    sut = CacheManagerAdapter(
      client: client,
    );
  });

  test(
    "Should call getFileFromCache with correct input",
    () async {

      await sut.get(key: key);

      expect(client.key, key);
      expect(client.getFileFromCacheCallsCount, 1);
    },
  );

  test(
    "Should return null if FileInfo is empty",
    () async {

      client.simulateEmptyFileInfo();

      final json = await sut.get(key: key);

      expect(json, isNull);
    },
  );
}