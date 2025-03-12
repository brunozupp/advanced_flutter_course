import 'package:advanced_flutter_course/app/domain/entities/domain_error.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/infra/repositories/cache/load_next_event_cache_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';
import '../../mocks/mapper_spy.dart';
import 'mocks/cache_get_client_spy.dart';

/// Mappers
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
///
/// P.S: I was seem that the plugin used to save the cache does not work
/// with DateTime attributes, so I need to parse them to string in order
/// to save them. Because of that I can have just ONE MAPPER that will
/// work to both api and cache. In this situation I can get the exact
/// context: when I have the control of the API/Backend it would be
/// a waste of time to have two different implementations of mappers
/// as it would work the same to both situations and I would have a
/// duplication of code. But in the case where I don't have the control
/// of the API and this API is made not following the good practices, I
/// would be good to have two implementations because I would guarantee
/// that my entity is correct and my mappers would work as a Anti-Corruption
/// layer to treat the API's response.

void main() {

  late String groupId;
  late String key;
  late CacheGetClientSpy cacheClient;
  late LoadNextEventCacheRepository sut;
  late MapperSpy<NextEvent> mapper;

  setUp(() {

    groupId = anyString();
    key = anyString();

    cacheClient = CacheGetClientSpy();

    mapper = MapperSpy(
      toObjectOutput: anyNextEvent(),
    );

    sut = LoadNextEventCacheRepository(
      cacheClient: cacheClient,
      key: key,
      mapper: mapper,
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

      expect(mapper.toObjectInput, cacheClient.response);
      expect(mapper.toObjectInputCallsCount, 1);
      expect(event, mapper.toObjectOutput);
    },
  );

  test(
    "Should rethrow on error",
    () async {

      final error = Error();

      cacheClient.error = error;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(error));
    },
  );

  test(
    "Should throw UnexpectedError on null response",
    () async {

      cacheClient.response = null;

      final future = sut.loadNextEvent(groupId: groupId);

      expect(future, throwsA(const TypeMatcher<UnexpectedError>()));
    },
  );
}