import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/load_next_event_api_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';
import '../../mocks/mapper_spy.dart';
import 'mocks/http_get_client_spy.dart';

void main() {

  late String groupId;
  late String url;
  late HttpGetClientSpy httpClient;
  late LoadNextEventApiRepository sut;
  late MapperSpy<NextEvent> mapper;

  setUp(() {

    groupId = anyString();
    url = anyString();

    httpClient = HttpGetClientSpy();

    mapper = MapperSpy(
      toObjectOutput: anyNextEvent(),
    );

    sut = LoadNextEventApiRepository(
      httpClient: httpClient,
      url: url,
      mapper: mapper,
    );
  });

  test(
    "Should call HttpClient with correct input",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(httpClient.url, url);
      expect(httpClient.callsCount, 1);
      expect(httpClient.params, {"groupId" : groupId});
    },
  );

  test(
    "Should return NextEvent on success",
    () async {

      final event = await sut.loadNextEvent(groupId: groupId);

      expect(mapper.toObjectInput, httpClient.response);
      expect(mapper.toObjectInputCallsCount, 1);
      expect(event, mapper.toObjectOutput);

    },
  );

  test(
    "Should rethrow on error",
    () async {

      final error = Error();

      httpClient.error = error;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(error));
    },
  );

  test(
    "Should throw UnexpectedError on null response",
    () async {

      httpClient.response = null;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(const TypeMatcher<UnexpectedError>()));
    },
  );
}