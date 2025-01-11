import 'package:advanced_flutter_course/app/infra/repositories/api/clients/http_get_client.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/load_next_event_api_repository.dart';
import 'package:advanced_flutter_course/app/infra/types/json_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

class HttpGetClientSpy implements HttpGetClient {

  String? url;
  int callsCount = 0;
  Json? params;
  dynamic response;
  Error? error;

  @override
  Future<T> get<T>({
    required String url,
    Json? params,
  }) async {
    this.url = url;
    callsCount++;
    this.params = params;

    if(error != null) {
      throw error!;
    }

    return response;
  }

}

void main() {

  late String groupId;
  late String url;
  late HttpGetClientSpy httpClient;
  late LoadNextEventApiRepository sut;

  setUp(() {

    groupId = anyString();
    url = anyString();

    httpClient = HttpGetClientSpy();

    httpClient.response = mapNextEvent;

    sut = LoadNextEventApiRepository(
      httpClient: httpClient,
      url: url,
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

      expect(event.groupName, "any name");
      expect(event.date, DateTime(2024,8,30,10,30));

      expect(event.players[0].id, "id 1");
      expect(event.players[0].name, "name 1");
      expect(event.players[0].isConfirmed, true);

      expect(event.players[1].id, "id 2");
      expect(event.players[1].name, "name 2");
      expect(event.players[1].isConfirmed, false);
      expect(event.players[1].position, "position 2");
      expect(event.players[1].photo, "photo 2");
      expect(event.players[1].confirmationDate, DateTime(2024,8,29,11,00));
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
}