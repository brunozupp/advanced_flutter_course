import 'package:advanced_flutter_course/app/core/factories/repository_factory.dart';
import 'package:advanced_flutter_course/app/presentation/rx/next_event_rx_presenter.dart';

final class PresenterFactory {

  PresenterFactory._();

  static NextEventRxPresenter makeNextEventRxPresenter() {

    final repository = RepositoryFactory.makeLoadNextEventApiRepository();

    return NextEventRxPresenter(
      nextEventLoader: repository.loadNextEvent,
    );
  }
}