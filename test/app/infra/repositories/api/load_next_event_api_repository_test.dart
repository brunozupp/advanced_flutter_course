import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

class LoadNextEventApiRepository {

  final HttpGetClient _httpClient;
  final String _url;

  LoadNextEventApiRepository({
    required HttpGetClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  Future<void> loadNextEvent({
    required String groupId,
  }) async {
    await _httpClient.get(
      url: _url,
      params: {
        "groupId": groupId,
      },
    );
  }
}

abstract class HttpGetClient {

  Future<void> get({
    required String url,
    Map<String, String>? params,
  });
}

class HttpGetClientSpy implements HttpGetClient {

  String? url;
  int callsCount = 0;
  Map<String, String>? params;

  @override
  Future<void> get({
    required String url,
    Map<String, String>? params,
  }) async {
    this.url = url;
    callsCount++;
    this.params = params;
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

    // httpClient.responseJson = jsonEncode(mapNextEvent);

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
}