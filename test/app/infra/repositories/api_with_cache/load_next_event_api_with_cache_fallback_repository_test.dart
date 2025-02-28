import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';

final class LoadNextEventApiWithCacheFallbackRepository {

  final Future<void> Function({
    required String groupId,
  }) loadNextEventApi;

  LoadNextEventApiWithCacheFallbackRepository({
    required this.loadNextEventApi,
  });

  Future<void> loadNextEvent({
    required String groupId,
  }) async {
    await loadNextEventApi(groupId: groupId);
  }
}

final class LoadNextEventApiRepositorySpy {

  String? groupId;
  int callsCounts = 0;

  Future<void> loadNextEvent({
    required String groupId,
  }) async {
    this.groupId = groupId;
    callsCounts++;
  }
}

void main() {

  late String groupId;
  late LoadNextEventApiRepositorySpy apiRepo;
  late LoadNextEventApiWithCacheFallbackRepository sut;

  setUp(() {
    groupId = anyString();
    apiRepo = LoadNextEventApiRepositorySpy();
    sut = LoadNextEventApiWithCacheFallbackRepository(
      loadNextEventApi: apiRepo.loadNextEvent,
    );
  });

  test(
    "Should load event data from api repo",
    () async {



      await sut.loadNextEvent(groupId: groupId);

      expect(apiRepo.groupId, groupId);
      expect(apiRepo.callsCounts, 1);
    },
  );
}