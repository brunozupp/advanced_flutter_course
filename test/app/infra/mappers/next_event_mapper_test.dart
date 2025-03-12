import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';
import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/infra/mappers/next_event_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';
import '../mocks/mapper_list_spy.dart';

/// Explanation about why the mapper is passed as an attribute to
/// the repositories:
/// Before this refactoring to pass the mapper as a parameter to
/// the repositories, I had created them directly inside the method
/// I was running. This implied with the repository having two jobs:
/// getting the data from the datasource and creating the mapper. This
/// second point can be put as an extra job to the repository and it
/// creates a direct dependecy to the repository. If some day I needed to
/// change the instance of the mapper I would need to alter the repository
/// directly, what can inflict the O in SOLID (Open/Closed Principle), where
/// an implementation is closed to changes, but opened to extension (as I
/// would need to change the repository and it would inflict the Closed part
/// from the principle). And another principle could be the D
/// (Dependency Inversion Principle) that says that my class should depend on
/// abstractions and not from implementations.
/// Another point to be taken into account is that this application works with
/// cache. So, the mapper abstraction goes as a parameter to both repositories
/// api and cache. And it goes inside the third one, that uses the Composite
/// Design Pattern. Thinking about this context, having a dependency on a
/// abstraction mapper could maintain the standard between the repositories
/// and it would guarantee that I could use the same implementation to the
/// 3 repositories, or if someday the backend changes the way it sends the data
/// and it will affect just one repository I can just create another
/// implementation and change the instance's creation of this repository in
/// the Dependency Injection.
/// The question that stands now is: it could be considered over engineering?
/// In the context where I don't have to implement cache the implementation
/// of a dependency from a mapper to the repository could be over engineering?
void main() {

  late NextEventMapper sut;
  late MapperListSpy<NextEventPlayer> playerMapper;

  setUp(() {
    playerMapper = MapperListSpy(
      toObjectListOutput: anyNextEventPlayerList(),
    );
    sut = NextEventMapper(
      playerMapper: playerMapper,
    );
  });

  test(
    "Should map to object",
    () {

      final json = <String,dynamic>{
        "groupName": anyString(),
        "date": DateTime(2024,8,30,10,30).toIso8601String(),
        "players": anyJsonList(),
      };

      final event = sut.toObject(json);

      expect(event.groupName, json["groupName"]);
      expect(event.date, DateTime.parse(json["date"]));
      expect(playerMapper.toObjectListInput, json["players"]);
      expect(playerMapper.toObjectListCallsCount, 1);
      expect(event.players, playerMapper.toObjectListOutput);
    },
  );

  test(
    "Should map to json",
    () {

      final object = NextEvent(
        groupName: anyString(),
        date: DateTime(2024, 8, 30, 10, 30),
        players: anyNextEventPlayerList(),
      );

      final json = sut.toJson(object);

      expect(json["groupName"], object.groupName);
      expect(json["date"], object.date.toIso8601String());
      expect(playerMapper.toJsonListInput, object.players);
      expect(playerMapper.toJsonListCallsCount, 1);
      expect(json["players"], playerMapper.toJsonListOutput);
    },
  );
}