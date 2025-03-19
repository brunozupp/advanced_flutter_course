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
                if(user.showCPF)
                  TextFormField(
                    initialValue: user.cpf,
                    decoration: const InputDecoration(
                      label: Text('CPF'),
                    ),
                  ),
                if(user.showCNPJ)
                  TextFormField(
                    initialValue: user.cnpj,
                    decoration: const InputDecoration(
                      label: Text('CNPJ'),
                    ),
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

  int callsCount = 0;
  EditUserViewModel _response = EditUserViewModel(
    isNaturalPerson: anyBool(),
    showCPF: anyBool(),
    showCNPJ: anyBool(),
  );

  void mockResponse({
    bool? isNaturalPerson,
    bool? showCPF,
    bool? showCNPJ,
    String? cpf,
    String? cnpj,
  }) {
    _response = EditUserViewModel(
      isNaturalPerson: isNaturalPerson ?? anyBool(),
      showCPF: showCPF ?? anyBool(),
      showCNPJ: showCNPJ ?? anyBool(),
      cpf: cpf,
      cnpj: cnpj,
    );
  }

  Future<EditUserViewModel> call() async {
    callsCount++;
    return _response;
  }
}

final class EditUserViewModel {

  EditUserViewModel({
    required this.isNaturalPerson,
    required this.showCPF,
    required this.showCNPJ,
    this.cpf,
    this.cnpj,
  });

  final bool isNaturalPerson;
  final bool showCPF;
  final bool showCNPJ;
  final String? cpf;
  final String? cnpj;
}

void main() {

  late LoadUserDataSpy loadUserData;
  late Widget sut;
  late String cpf;
  late String cnpj;

  setUp(() {
    loadUserData = LoadUserDataSpy();

    sut = MaterialApp(
      home: EditUserPage(
        loadUserData: loadUserData.call,
      ),
    );

    cpf = anyString();
    cnpj = anyString();
  });

  testWidgets(
    "should load user data on page init",
    (WidgetTester tester) async {

      await tester.pumpWidget(sut);

      expect(loadUserData.callsCount, 1);
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

      loadUserData.mockResponse(
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

      loadUserData.mockResponse(
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

      loadUserData.mockResponse(
        isNaturalPerson: false,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.naturalPersonRadio.checked, false);
      expect(tester.legalPersonRadio.checked, true);
    },
  );

  testWidgets(
    "Should show CPF",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        showCPF: true,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.finderCPF, findsOneWidget);
    },
  );

  testWidgets(
    "Should hide CPF",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        showCPF: false,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.finderCPF, findsNothing);
    },
  );

  testWidgets(
    "Should show CNPJ",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        showCNPJ: true,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.finderCNPJ, findsOneWidget);
    },
  );

  testWidgets(
    "Should hide CNPJ",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        showCNPJ: false,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.finderCNPJ, findsNothing);
    },
  );

  testWidgets(
    "Should fill CPF",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        cpf: cpf,
        showCPF: true,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.textFormFieldCPF.initialValue, cpf);
    },
  );

  testWidgets(
    "Should clear CPF",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        cpf: null,
        showCPF: true,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.textFormFieldCPF.initialValue, isEmpty);
    },
  );

  testWidgets(
    "Should fill CNPJ",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        cnpj: cnpj,
        showCNPJ: true,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.textFormFieldCNPJ.initialValue, cnpj);
    },
  );

  testWidgets(
    "Should clear CNPJ",
    (WidgetTester tester) async {

      loadUserData.mockResponse(
        cnpj: null,
        showCNPJ: true,
      );

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(tester.textFormFieldCNPJ.initialValue, isEmpty);
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

  Finder get finderCPF => find.text('CPF');
  TextFormField get textFormFieldCPF => widget(find.ancestor(of: finderCPF, matching: find.byType(TextFormField)));

  Finder get finderCNPJ => find.text('CNPJ');
  TextFormField get textFormFieldCNPJ => widget(find.ancestor(of: finderCNPJ, matching: find.byType(TextFormField)));
}