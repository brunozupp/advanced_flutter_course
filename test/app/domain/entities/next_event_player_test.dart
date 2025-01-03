import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
    final String id;
    final String name;
    final String? photo;
    final String? position;
    final bool isConfirmed;
    final DateTime? confirmationDate;

    NextEventPlayer({
        required this.id,
        required this.name,
        this.photo,
        this.position,
        required this.isConfirmed,
        this.confirmationDate,
    });

    String getInitials() {

        final names = name.split(" ");

        return "${names.first[0]}${names.last[0]}";
    }
}

void main() {

  test(
    "Should return the first letter of the first and last names",
    () {

        /// As the only information I am interested to test is the name
        /// I can take off the attributes that is optional.
        final player = NextEventPlayer(
            id: "",
            name: "Bruno Noveli",
            isConfirmed: true,
        );

        /// To test something I need to do 3 steps. Generally devs call
        /// these steps from both conventions:
        /// Triple A (aaa) = arrange, act, asset
        /// Given, when, then

        expect(player.getInitials(), "BN");
    },
  );
}