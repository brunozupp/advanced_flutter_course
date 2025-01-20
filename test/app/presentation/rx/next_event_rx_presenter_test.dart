import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

final class NextEventRxPresenter {

  final Future<void> Function({
    required String groupId,
  }) nextEventLoader;

  const NextEventRxPresenter({
    required this.nextEventLoader,
  });

  Future<void> loadNextEvent({
    required String groupId,
  }) async {
    await nextEventLoader(groupId: groupId);
  }
}

final class NextEventLoaderUseCaseSpy {

  int callsCount = 0;
  String? groupId;

  Future<void> call({
    required String groupId,
  }) async {
    this.groupId = groupId;
    callsCount++;
  }
}

void main() {

  late NextEventLoaderUseCaseSpy nextEventLoader;
  late String groupId;
  late NextEventRxPresenter sut;

  setUp(() {
    nextEventLoader = NextEventLoaderUseCaseSpy();

    groupId = anyString();

    sut = NextEventRxPresenter(
      nextEventLoader: nextEventLoader, // Tear-off pointer
    );
  });

  test(
    "Should get event data",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(nextEventLoader.callsCount, 1);
      expect(nextEventLoader.groupId, groupId);
    },
  );
}