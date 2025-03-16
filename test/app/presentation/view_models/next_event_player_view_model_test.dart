import 'package:advanced_flutter_course/app/domain/entities/next_event_player.dart';
import 'package:advanced_flutter_course/app/presentation/view_models/next_event_player_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakes.dart';

void main() {

  test(
    "Should map player without confirmationDate",
    () async {

      final entity = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: anyBool(),
        photo: anyString(),
        position: anyString(),
      );

      final viewModel = NextEventPlayerViewModel.fromEntity(entity);

      expect(viewModel.name, entity.name);
      expect(viewModel.initials, entity.initials);
      expect(viewModel.isConfirmed, null);
      expect(viewModel.photo, entity.photo);
      expect(viewModel.position, entity.position);
    },
  );

  test(
    "Should map player with confirmationDate",
    () async {

      final entity = NextEventPlayer(
        id: anyString(),
        name: anyString(),
        isConfirmed: false,
        photo: anyString(),
        position: anyString(),
        confirmationDate: anyDate(),
      );

      final viewModel = NextEventPlayerViewModel.fromEntity(entity);

      expect(viewModel.name, entity.name);
      expect(viewModel.initials, entity.initials);
      expect(viewModel.isConfirmed, entity.isConfirmed);
      expect(viewModel.photo, entity.photo);
      expect(viewModel.position, entity.position);
    },
  );

  /// Doubt list has:
  /// confirmationDate == null
  test(
    "Should build doubt list sorted by name",
    () async {

      final doubt = NextEventPlayerViewModel.filterDoubtPlayers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: anyBool(),
          confirmationDate: anyDate(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: anyBool(),
        ),
      ]);

      expect(doubt.length, 3);
      expect(doubt[0].name, 'A');
      expect(doubt[1].name, 'C');
      expect(doubt[2].name, 'D');
    },
  );

  /// Out list has:
  /// confirmationDate != null
  /// isConfirmed == false
  test(
    "Should build out list sorted by confirmation date",
    () async {

      final out = NextEventPlayerViewModel.filterOutPlayers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,10),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,11),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,9),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'E',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,12),
        ),
      ]);

      expect(out.length, 3);
      expect(out[0].name, 'D');
      expect(out[1].name, 'C');
      expect(out[2].name, 'E');
    },
  );

  /// Goalkeepers list has:
  /// confirmationDate != null
  /// isConfirmed == true
  /// position == goalkeeper
  test(
    "Should build goalkeepers list sorted by confirmation date",
    () async {

      final goalKeepers = NextEventPlayerViewModel.filterGoalkeepers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,10),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,11),
          position: "defender",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,9),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'E',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,12),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'F',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,8),
          position: "goalkeeper",
        ),
      ]);

      expect(goalKeepers.length, 2);
      expect(goalKeepers[0].name, 'F');
      expect(goalKeepers[1].name, 'C');
    },
  );

  /// Players list has:
  /// confirmationDate != null
  /// isConfirmed == true
  /// position: it can and can not value
  test(
    "Should build players list sorted by confirmation date",
    () async {

      final players = NextEventPlayerViewModel.filterPlayers([
        NextEventPlayer(
          id: anyString(),
          name: 'C',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,10),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'A',
          isConfirmed: anyBool(),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'B',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,11),
          position: "defender",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'D',
          isConfirmed: false,
          confirmationDate: DateTime(2024,1,1,9),
          position: "goalkeeper",
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'E',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,12),
        ),
        NextEventPlayer(
          id: anyString(),
          name: 'F',
          isConfirmed: true,
          confirmationDate: DateTime(2024,1,1,8),
          position: "goalkeeper",
        ),
      ]);

      expect(players.length, 2);
      expect(players[0].name, 'B');
      expect(players[1].name, 'E');
    },
  );
}