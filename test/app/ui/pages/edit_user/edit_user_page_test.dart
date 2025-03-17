import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({
    super.key,
    required this.loadUserData,
  });

  final Future<void> Function() loadUserData;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {

  @override
  void initState() {

    widget.loadUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

final class LoadUserDataMock {

  bool isCalled = false;

  Future<void> call() async {
    isCalled = true;
  }
}

void main() {

  testWidgets(
    "should load user data on page init",
    (WidgetTester tester) async {

      final loadUserData = LoadUserDataMock();

      final sut = EditUserPage(
        loadUserData: loadUserData.call,
      );
      await tester.pumpWidget(sut);

      expect(loadUserData.isCalled, true);
    },
  );
}