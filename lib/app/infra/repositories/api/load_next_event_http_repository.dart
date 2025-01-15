import 'dart:convert';

import '../../../domain/entities/domain_error.dart';
import '../../../domain/entities/next_event.dart';
import '../../../domain/entities/next_event_player.dart';
import '../../../domain/repositories/i_load_next_event_repository.dart';

import 'package:http/http.dart';

/// This repository was created to show the bad ways to do things where
/// I basically have everything inside this repository. It does more than
/// one job.
class LoadNextEventHttpRepository implements ILoadNextEventRepository {

  final Client _httpClient;
  final String _url;

  LoadNextEventHttpRepository({
    required Client httpClient,
    required String url,
  })  : _httpClient = httpClient,
        _url = url;

  @override
  Future<NextEvent> loadNextEvent({required String groupId}) async {

    final url = _url.replaceFirst(":groupId", groupId);

    final response = await _httpClient.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      }
    );

    switch(response.statusCode) {
      case 400:
      case 403:
      case 404:
      case 500:
        throw UnexpectedError();
      case 401:
        throw SessionExpiredError();
    }

    final eventMap = jsonDecode(response.body);

    return NextEvent(
      groupName: eventMap["groupName"],
      date: DateTime.parse(eventMap["date"]),
      players: eventMap["players"].map<NextEventPlayer>((player) => NextEventPlayer(
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