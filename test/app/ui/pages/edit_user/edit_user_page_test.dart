import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/fakes.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({
    super.key,
    required this.loadUserData,
  });

  final Future<EditUserViewModel> Function() loadUserData;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future: widget.loadUserData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if(snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }

          if(snapshot.hasData) {

            final user = snapshot.data!;

            return Column(
              children: [
                RadioListTile(
                  value: true,
                  groupValue: user.isNaturalPerson,
                  onChanged: (value) {},
                  title: const Text('Pessoa física'),
                ),
                RadioListTile(
                  value: false,
                  groupValue: user.isNaturalPerson,
                  onChanged: (value) {},
                  title: const Text('Pessoa jurídica'),
                ),
              ],
            );
          }

          return SizedBox.fromSize();
        },
      ),
    );
  }
}

final class LoadUserDataSpy {

  bool isCalled = false;
  EditUserViewModel response = EditUserViewModel(
    isNaturalPerson: anyBool(),
  );

  Future<EditUserViewModel> call() async {
    isCalled = true;
    return response;
  }
}

final class EditUserViewModel {

  EditUserViewModel({
    required this.isNaturalPerson,
  });

  final bool isNaturalPerson;
}

void main() {

  late LoadUserDataSpy loadUserData;

  late Widget sut;

  setUp(() {
    loadUserData = LoadUserDataSpy();

    sut = MaterialApp(
      home: EditUserPage(
        loadUserData: loadUserData.call,
      ),
    );
  });

  testWidgets(
    "should load user data on page init",
    (WidgetTester tester) async {

      await tester.pumpWidget(sut);

      expect(loadUserData.isCalled, true);
    },
  );

  /// This is an approach I have to minimize the amount of code my file has
  /// and gain the possibility to reuse this code in many tests inside this
  /// file. For now I am using the Extension approach and this approach.
  ({Finder finderNaturalPerson, Finder finderLegalPerson}) getFinderRadios(WidgetTester tester) {
    final finderRadioListTile = find.byType(RadioListTile<bool>);
    final radiosWidget = tester.widgetList<RadioListTile>(finderRadioListTile).toList();

    /// To test the properties from the widget I need to convert the Finder
    /// object in a Widget using the tester.widget passing the Finder from
    /// the widget I wanted. I can not forget to write the type of my widget.
    final finderNaturalPerson = find.byWidget(radiosWidget.where((radio) => radio.value).first);
    final finderLegalPerson = find.byWidget(radiosWidget.where((radio) => !radio.value).first);
    return (finderNaturalPerson: finderNaturalPerson, finderLegalPerson: finderLegalPerson);
  }

  testWidgets(
    "Should have both radios inside the screen with correct names",
    (WidgetTester tester) async {

      loadUserData.response = EditUserViewModel(
        isNaturalPerson: true,
      );

      await tester.pumpWidget(sut);

      /// Used everytime I want to refresh my virtual screen so the frames
      /// is updated and I can see the changes in my screen. In this case,
      /// after calling the method in the initState I need to refresh the
      /// frames so the screen will be able to update itself.
      await tester.pump();

      final finderRadioListTile = find.byType(RadioListTile<bool>);
      expect(finderRadioListTile, findsExactly(2));

      final (:finderNaturalPerson, :finderLegalPerson) = getFinderRadios(tester);

      expect(finderNaturalPerson, findsOneWidget);
      expect(finderLegalPerson, findsOneWidget);

      /// Both expects will look for the Pessoa física in the screen, but
      /// the first implementation is isolated in the component, so I can
      /// have this same text wherever in my screen, but if it's not inside
      /// the RadioListTile it will give me an error. The second one will
      /// try to find this text in all my screen, it's not isolated as the
      /// first one.
      expect(
        find.descendant(
          of: finderRadioListTile,
          matching: find.text('Pessoa jurídica'),
        ),
        findsOneWidget,
      );
      expect(
        find.text('Pessoa jurídica'),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: finderRadioListTile,
          matching: find.text('Pessoa física'),
        ),
        findsOneWidget,
      );
      expect(
        find.text('Pessoa física'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Should check natural person",
    (WidgetTester tester) async {

      loadUserData.response = EditUserViewModel(
        isNaturalPerson: true,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.naturalPersonRadio.checked, true);
      expect(tester.legalPersonRadio.checked, false);
    },
  );

  testWidgets(
    "Should check legal person",
    (WidgetTester tester) async {

      loadUserData.response = EditUserViewModel(
        isNaturalPerson: false,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.naturalPersonRadio.checked, false);
      expect(tester.legalPersonRadio.checked, true);
    },
  );
}

/// This is another option I have to refactor my tests.
/// Using this I gain the possibility to add helpers inside the WidgetTester
/// so I can replace the Records approach for this one.
extension EditUserPageExtension on WidgetTester {

  Finder get _finderRadioListTile => find.byType(RadioListTile<bool>);
  Iterable<RadioListTile> get _radiosWidget => widgetList(_finderRadioListTile);

  Finder get finderNaturalPerson => find.byWidget(_radiosWidget.where((radio) => radio.value).first);
  Finder get finderLegalPerson => find.byWidget(_radiosWidget.where((radio) => !radio.value).first);

  RadioListTile get naturalPersonRadio => widget(finderNaturalPerson);
  RadioListTile get legalPersonRadio => widget(finderLegalPerson);
}