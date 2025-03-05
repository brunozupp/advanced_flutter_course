import 'dart:convert';

import 'package:advanced_flutter_course/app/infra/repositories/cache/adapters/cache_manager_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../mocks/fakes.dart';
import '../mocks/cache_manager_spy.dart';

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

  group(
    ".get method",
    () {
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

      test(
        "Should return null if cache is old",
        () async {
          client.simulateCacheOld();

          final json = await sut.get(key: key);

          expect(json, isNull);
        },
      );

      test(
        "Should call filePlugin.exists only once",
        () async {
          await sut.get(key: key);

          expect(client.file.existsCallsCount, 1);
        },
      );

      test(
        "Should return null if file is empty",
        () async {
          client.file.simulateFileEmpty();

          final json = await sut.get(key: key);

          expect(json, isNull);
        },
      );

      test(
        "Should call filePlugin.readAsString only once",
        () async {
          await sut.get(key: key);

          expect(client.file.readAsStringCallsCount, 1);
        },
      );

      test(
        "Should return null if cache is invalid",
        () async {
          client.file.simulateInvalidResponse();

          final json = await sut.get(key: key);

          expect(json, isNull);
        },
      );

      test(
        "Should return json if cache is invalid",
        () async {
          client.file.simulateValidResponse('''
        {
          "key1": "value1",
          "key2": "value2"
        }
      ''');

          final json = await sut.get(key: key);

          expect(json["key1"], "value1");
          expect(json["key2"], "value2");
        },
      );

      test(
        "Should return null if filePlugin.readAsString fails",
        () async {
          client.file.simulateReadAsStringError();

          final json = await sut.get(key: key);

          expect(json, isNull);
        },
      );

      test(
        "Should return null if filePlugin.exists fails",
        () async {
          client.file.simulateExistsError();

          final json = await sut.get(key: key);

          expect(json, isNull);
        },
      );

      test(
        "Should return null if getFileFromCache fails",
        () async {
          client.simulateGetFileFromCacheError();

          final json = await sut.get(key: key);

          expect(json, isNull);
        },
      );
    },
  );

  group(
    ".save method",
    () {

      late Map<String, dynamic> value;

      setUp(() {
        value = {
          'key1': anyString(),
          'key2': anyIsoDate(),
          'key3': anyBool(),
          'key4': anyInt(),
        };
      });

      test(
        "Should call putFile with correct input",
        () async {

          await sut.save(key: key, value: value);

          /// I need to do this to test the encoding from the value passed
          /// to the package that I do inside de adapter. I do a reverse
          /// engineering in this case.
          final fileBytesDecoded = jsonDecode(utf8.decode(client.fileBytes!));

          expect(client.putFileCallsCount, 1);
          expect(client.key, key);
          expect(client.fileExtension, 'json');
          expect(fileBytesDecoded, value);
        },
      );
    },
  );
}
