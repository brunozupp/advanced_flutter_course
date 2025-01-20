import 'package:advanced_flutter_course/app/domain/usecases/next_event_loader_usecase.dart';
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

  test(
    "Should get event data",
    () async {

      final nextEventLoader = NextEventLoaderUseCaseSpy();

      final groupId = anyString();

      final sut = NextEventRxPresenter(
        nextEventLoader: nextEventLoader, // Tear-off pointer
      );

      await sut.loadNextEvent(groupId: groupId);

      expect(nextEventLoader.callsCount, 1);
      expect(nextEventLoader.groupId, groupId);
    },
  );
}