import 'package:advanced_flutter_course/app/core/factories/presenter_factory.dart';
import 'package:advanced_flutter_course/app/ui/pages/next_event/next_event_page.dart';
import 'package:flutter/material.dart';

final class PageFactory {

  PageFactory._();

  static Widget makeNextEventPage() {
    return NextEventPage(
      presenter: PresenterFactory.makeNextEventRxPresenter(),
      groupId: "valid_id",
    );
  }
}