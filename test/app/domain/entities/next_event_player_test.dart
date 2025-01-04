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

  String get initials {

    /// TODO: this case should be studied, because whitespaces in the name
    /// is something related to the rules from the instantiation from a class.
    /// To understand clearer:
    /// .toUpperCase is just applied to a specific rule in my application, it
    /// is not related to the value itself. It will just transform to fit a
    /// specific flow specified by the rule.
    /// .trim is a treatment that should have been made before the instance creation
    /// because this affects how the entity is understood by the system. So it can
    /// be defined as a rule from the instantiation.
    ///
    /// For now, I will let the trim here as a treatment to show the initials in
    /// the correct way. But, doing this rule in the instantiation this treatment
    /// wouldn't be necessary.
    final nameTrim = name.trim();

    if(nameTrim.isEmpty) {
      return "-";
    }

    final names = nameTrim.toUpperCase().split(" ");

    final firstLetter = names.first[0];

    final String lastLetter;

    if(names.length > 1) {
      lastLetter = names.last[0];
    } else if(names.first.length > 1) {
      lastLetter = names.first[1];
    } else {
      lastLetter = "";
    }

    return "$firstLetter$lastLetter";
  }
}

void main() {

    /// As my tests depend on the name only, I can create a method
    /// to facilitate and optimize the process of creating the object
    /// that is being tested.
    /// And to focus more in the enterprise rule from this object I can be
    /// more direct and return the initials from this method, because I
    /// jsut care about the initials to test.
    String makeSut(String name) => NextEventPlayer(
      id: "",
      name: name,
      isConfirmed: true,
    ).initials;

    test(
      "Should return the first letter from the first and last names when the person has just one surname",
      () {

        /// As the only information I am interested to test is the name
        /// I can take off the attributes that is optional.
        /// sut -> it's a conventional word in the TDD used to point the object that
        /// is being tested. It means System Under Test
        /// Some people like to put 'out' that means Object Under Test. One point in
        /// this is that in some programming languages the word out is a key word from
        /// the language, so it can lead to problems.
        final sut = makeSut("Bruno Noveli");

        /// To test something I need to do 3 steps. Generally devs call
        /// these steps from both conventions:
        /// Triple A (aaa) = arrange, act, asset
        /// Given, when, then

        expect(sut, "BN");
      },
  );

  test(
    "Should return the first letter from the first and last names when the person has two surnames or more",
    () {

      final sut = makeSut("Bruno Noveli Zupp");

      expect(sut, "BZ");
    },
  );

  test(
    "Should return the first two letters from the first name when the player doesn't have surname",
    () {

      final sut = makeSut("Bruno");

      expect(sut, "BR");
    },
  );

  test(
    "Should return the initials in uppercase",
    () {

      final sut = makeSut("bruno");

      expect(sut, "BR");
    },
  );

  test(
    "Should return just one letter when the name contains just one letter",
    () {

      final sutUppercase = makeSut("B");
      expect(sutUppercase, "B");

      final sutLowercase = makeSut("s");
      expect(sutLowercase, "S");
    },
  );

  test(
    "Should return - when the name is empty",
    () {

      final sut = makeSut("");

      expect(sut, "-");
    },
  );

  test(
    "Should ignore extra whitespaces",
    () {

      final sut1 = makeSut("Bruno Noveli ");
      final sut2 = makeSut(" Bruno Noveli");
      final sut3 = makeSut(" Bruno Noveli ");
      final sut4 = makeSut("Bruno ");
      final sut5 = makeSut(" Bruno");
      final sut6 = makeSut(" Bruno ");
      final sut7 = makeSut("B ");
      final sut8 = makeSut(" B");
      final sut9 = makeSut(" B ");
      final sut10 = makeSut(" ");
      final sut11 = makeSut("      ");

      expect(sut1, "BN");
      expect(sut2, "BN");
      expect(sut3, "BN");
      expect(sut4, "BR");
      expect(sut5, "BR");
      expect(sut6, "BR");
      expect(sut7, "B");
      expect(sut8, "B");
      expect(sut9, "B");
      expect(sut10, "-");
      expect(sut11, "-");
    },
  );
}