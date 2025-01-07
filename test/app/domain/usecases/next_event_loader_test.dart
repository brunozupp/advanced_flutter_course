import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

class NextEventLoader {

  final ILoadNextEventRepository _loadNextEventRepository;

  NextEventLoader({
    required ILoadNextEventRepository loadNextEventRepository,
  }) : _loadNextEventRepository = loadNextEventRepository;

  Future<void> call({required String groupId}) async {
    await _loadNextEventRepository.loadNextEvent(groupId: groupId);
  }
}

/// Mock, Spy, Stub
/// When I test both input and output it's a spy;
/// When I am worried only about the input it's a mock;
/// When I am worried only about the output it's a stub;
class LoadNextEventMockRepository implements ILoadNextEventRepository {

  /// These properties make sense just in this case, when I make a Mock
  /// There is no sense doing this in a real repository implementation.
  /// But in the case of mocks it's acceptable to test things like if
  /// the inputs (parameters) are correct.
  String? groupId;
  var callsCount = 0;

  @override
  Future<void> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
    callsCount = 1;
  }
}

abstract interface class ILoadNextEventRepository {

  Future<void> loadNextEvent({required String groupId});
}

void main() {

  late final ILoadNextEventRepository repository;
  late final NextEventLoader sut;

  late final String groupId;

  setUpAll(() {

    groupId = Random().nextInt(3000).toString();

    repository = LoadNextEventMockRepository();

    sut = NextEventLoader(
      loadNextEventRepository: repository,
    );
  });

  test(
    "Should load event data from a repository",
    () async {

      await sut(
        groupId: groupId,
      );

      expect((repository as LoadNextEventMockRepository).groupId, groupId);
      expect((repository as LoadNextEventMockRepository).callsCount, 1);
    },
  );
}