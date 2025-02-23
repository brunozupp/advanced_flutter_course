import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/repositories/api/mappers/next_event_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';


/// It's interesting to have an unique Mapper to the cache layer, because
/// it's important that the Mapper from the cache does not know about
/// the Api layer. And another point is when I have an API that are not
/// following some standards, for example, the language it returns the
/// attributes is in Portuguese, not in English as all my application
/// is made based on this language. So the Mapper layer would serve
/// as an Anti-Corruption layer, where it would attend the data from
/// my API and would do the parse to the correct attributes to my
/// Entity. And when I need to send the data to my backend and there needs to
/// be in Portuguese, the Mapper from my Api layer would be responsible
/// for set all the attributes in their correct places in Portuguese.
/// So my Entity would be fully in English following the standard.
/// Following this line of thought, there is no need of having the challenge
/// of parse all the attributes to Portuguese to save in my cache
/// implementation. Instead of this, I would do another Mapper that would
/// be responsible for saving the data in another format (from this example,
/// following the English language and parsing the attributes to and from
/// the Entity). Another example of this is that I don't need to do
/// some transformation in my data as demanded in the HttpClient, because
/// there all my data needs to my passed as a String (json), so I need
/// to parse any Class Type to this specific format. As an example I can
/// quote the Date class. When passing this attribute to the HttpClient
/// I need to use the toIso8601String to format to a valid string format.
/// When using the Mapper from the cache layer, I can let this attribute
/// as it was created and save as Date Type.

final class CacheGetClientSpy implements CacheGetClient {

  String? key;
  int callsCount = 0;
  dynamic response;

  @override
  Future<dynamic> get({
    required String key,
  }) async {
    this.key = key;
    callsCount++;

    return response;
  }
}

abstract interface class CacheGetClient {

  Future<dynamic> get({
    required String key,
  });
}

final class LoadNextEventCacheRepository  {

  final CacheGetClient _cacheClient;
  final String _key;

  const LoadNextEventCacheRepository({
    required CacheGetClient cacheClient,
    required String key,
  })  : _cacheClient = cacheClient,
        _key = key;

  Future<NextEvent> loadNextEvent({
    required String groupId,
  }) async {

    final event = await _cacheClient.get(
      key: "$_key:$groupId",
    );

    if(event == null) {
      throw UnexpectedError();
    }

    return NextEventMapper().toObject(event);
  }
}

abstract base class Mapper<T> {

  List<T> toObjectList(dynamic list) => list.map<T>(toObject).toList();

  T toObject(dynamic json);
}

final class NextEventPlayerMapper extends Mapper<NextEventPlayer> {

  @override
  NextEventPlayer toObject(dynamic json) => NextEventPlayer(
    id: json["id"],
    name: json["name"],
    isConfirmed: json["isConfirmed"],
    photo: json["photo"],
    position: json["position"],
    confirmationDate: json["confirmationDate"],
  );
}

final class NextEventMapper extends Mapper<NextEvent> {

  @override
  NextEvent toObject(dynamic json) => NextEvent(
    groupName: json["groupName"],
    date: json["date"],
    players: NextEventPlayerMapper().toObjectList(json["players"])
  );
}

void main() {

  late String groupId;
  late String key;
  late CacheGetClientSpy cacheClient;
  late LoadNextEventCacheRepository sut;

  setUp(() {

    groupId = anyString();
    key = anyString();

    cacheClient = CacheGetClientSpy();

    cacheClient.response = mapNextEventCache;

    sut = LoadNextEventCacheRepository(
      cacheClient: cacheClient,
      key: key,
    );
  });

  test(
    "Should call CacheClient with correct input",
    () async {

      await sut.loadNextEvent(groupId: groupId);

      /// Because I can have more than one group (key), I need to concatenate
      /// the groupId to identify which group I want to select.
      expect(cacheClient.key, '$key:$groupId');
      expect(cacheClient.callsCount, 1);
    },
  );

    test(
    "Should return NextEvent on success",
    () async {

      final event = await sut.loadNextEvent(groupId: groupId);

      expect(event.groupName, "any name");
      expect(event.date, DateTime(2024,1,1,10,30));

      expect(event.players[0].id, "id 1");
      expect(event.players[0].name, "name 1");
      expect(event.players[0].isConfirmed, true);

      expect(event.players[1].id, "id 2");
      expect(event.players[1].name, "name 2");
      expect(event.players[1].isConfirmed, false);
      expect(event.players[1].position, "position 2");
      expect(event.players[1].photo, "photo 2");
      expect(event.players[1].confirmationDate, DateTime(2024,1,1,12,30));
    },
  );
}