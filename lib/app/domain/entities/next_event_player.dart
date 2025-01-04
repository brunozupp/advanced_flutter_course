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