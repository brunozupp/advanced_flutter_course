import 'package:flutter_test/flutter_test.dart';

class NextEventLoader {

  final LoadNextEventRepository _loadNextEventRepository;

  NextEventLoader({
    required LoadNextEventRepository loadNextEventRepository,
  }) : _loadNextEventRepository = loadNextEventRepository;

  Future<void> call({required String groupId}) async {
    await _loadNextEventRepository.loadNextEvent(groupId: groupId);
  }
}

class LoadNextEventRepository {

  var isCalled = false;

  Future<void> loadNextEvent({required String groupId}) async {
    isCalled = true;
  }
}

void main() {

  test(
    "Should load event data from a repository",
    () async {

      final repo = LoadNextEventRepository();

      final sut = NextEventLoader(
        loadNextEventRepository: repo,
      );

      await sut(
        groupId: "",
      );

      expect(repo.isCalled, true);
    },
  );
}