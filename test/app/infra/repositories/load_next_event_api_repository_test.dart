import 'dart:convert';

import 'dart:typed_data';

import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/repositories/i_load_next_event_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import '../../../helpers/fakes.dart';

class LoadNextEventApiRepository {

  final Client _httpClient;
  final String _url;

  LoadNextEventApiRepository({
    required Client httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  //@override
  //Future<NextEvent> loadNextEvent({required String groupId}) async {
  Future<void> loadNextEvent({required String groupId}) async {

    final url = _url.replaceFirst(":groupId", groupId);

    await _httpClient.get(Uri.parse(url));
  }

}

class HttpClientSpy implements Client {

  String? method;
  int callsCount = 0;
  String? url;

  @override
  void close() { }

  @override
  Future<Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    method = "GET";
    callsCount++;
    this.url = url.toString();

    return Response('', 200);
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    throw UnimplementedError();
  }

}

void main() {

  late final String groupId;
  late final String url;
  late final HttpClientSpy httpClient;
  late final LoadNextEventApiRepository sut;

  setUpAll(() {
    groupId = anyString();

    url = "https://domain.com/api/groups/:groupId/next_event";

    httpClient = HttpClientSpy();

    sut = LoadNextEventApiRepository(
      httpClient: httpClient,
      url: url,
    );
  });

  test(
    "Should request with correct method",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(httpClient.method, "GET");
      expect(httpClient.callsCount, 1);
    },
  );

  test(
    "Should request with correct url",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      expect(httpClient.url, "https://domain.com/api/groups/$groupId/next_event");
    },
  );
}