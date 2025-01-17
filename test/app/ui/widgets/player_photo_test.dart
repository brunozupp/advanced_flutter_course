import 'package:advanced_flutter_course/app/ui/pages/widgets/player_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {

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