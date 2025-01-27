import 'package:advanced_flutter_course/app/core/constants.dart';
import 'package:advanced_flutter_course/app/core/factories/common_factory.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/load_next_event_api_repository.dart';

final class RepositoryFactory {

  RepositoryFactory._();

  static LoadNextEventApiRepository makeLoadNextEventApiRepository() {
    return LoadNextEventApiRepository(
      httpClient: CommonFactory.makeHttpAdapter(),
      url: "${Constants.BASE_URL}/groups/:groupId/next_event",
    );
  }
}