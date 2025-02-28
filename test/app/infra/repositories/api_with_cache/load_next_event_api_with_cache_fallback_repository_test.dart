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

  test(
    "Should load event data from api repo",
    () async {

      final groupId = anyString();
      final apiRepo = LoadNextEventApiRepositorySpy();

      final sut = LoadNextEventApiWithCacheFallbackRepository(
        loadNextEventApi: apiRepo.loadNextEvent,
      );

      await sut.loadNextEvent(groupId: groupId);

      expect(apiRepo.groupId, groupId);
      expect(apiRepo.callsCounts, 1);
    },
  );
}