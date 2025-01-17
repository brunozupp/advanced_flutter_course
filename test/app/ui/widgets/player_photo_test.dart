import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

/// To widgets like this that are used in more than one page/module
/// it is not recommended to put the viewmodel as a paramters, because
/// doing this I am binding the viewmodel with the component and restricting
/// its using to a specific page/module.
/// So, it's recommended to put just the parameters needed separeted.

class PlayerPhoto extends StatelessWidget {

  final String initials;
  final String? photo;

  const PlayerPhoto({
    super.key,
    required this.initials,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundImage: photo != null
        ? NetworkImage(photo!)
        : null,
      child: photo == null
        ? Text(initials)
        : null,
    );
  }
}

void main() {

  const urlImage = "https://conteudo.imguol.com.br/c/entretenimento/af/2024/02/21/cena-de-naruto-shippuden-1708550179304_v2_900x506.jpg";

  testWidgets(
    "should present initials when there is no photo",
    (WidgetTester tester) async {

      const sut = MaterialApp(
        home: PlayerPhoto(
          initials: "BN",
          photo: null,
        ),
      );

      await tester.pumpWidget(sut);

      expect(find.text("BN"), findsOneWidget);
    },
  );

  testWidgets(
    "should hide initials when there is photo",
    (WidgetTester tester) async {

      /// When I have to deal with network calls to get images I need
      /// to use this mockNetworkImagesFor from the plugin network_image_mock
      /// If I don't use it I will get an error when running the test
      mockNetworkImagesFor(() async {
        const sut = MaterialApp(
          home: PlayerPhoto(
            initials: "BN",
            photo: "https://any-url.com",
          ),
        );

        await tester.pumpWidget(sut);

        final circleAvatar = tester.firstWidget<CircleAvatar>(find.byType(CircleAvatar));

        expect(find.text("BN"), findsNothing);
        expect(circleAvatar.foregroundImage, isNotNull);
      });
    },
  );
}