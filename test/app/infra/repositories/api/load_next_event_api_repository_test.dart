import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/domain/repositories/i_load_next_event_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fakes.dart';

class LoadNextEventApiRepository implements ILoadNextEventRepository {

  final HttpGetClient _httpClient;
  final String _url;

  LoadNextEventApiRepository({
    required HttpGetClient httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {
    final event = await _httpClient.get(
      url: _url,
      params: {
        "groupId": groupId,
      },
    );

    return NextEvent(
      groupName: event["groupName"],
      date: DateTime.parse(event["date"]),
      players: event["players"].map<NextEventPlayer>((player) => NextEventPlayer(
        id: player["id"],
        name: player["name"],
        isConfirmed: player["isConfirmed"],
        photo: player["photo"],
        position: player["position"],
        confirmationDate: DateTime.tryParse(player["confirmationDate"] ?? ""),
      )).toList(),
    );
  }
}

abstract class HttpGetClient {

  Future<dynamic> get({
    required String url,
    Map<String, String>? params,
  });
}

class HttpGetClientSpy implements HttpGetClient {

  String? url;
  int callsCount = 0;
  Map<String, String>? params;
  dynamic response;

  @override
  Future<dynamic> get({
    required String url,
    Map<String, String>? params,
  }) async {
    this.url = url;
    callsCount++;
    this.params = params;

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
}