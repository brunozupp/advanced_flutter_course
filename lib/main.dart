import 'package:advanced_flutter_course/app/app.dart';
import 'package:advanced_flutter_course/app/core/factories/common_factory.dart';
import 'package:flutter/material.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Simulating a successful login that would fetch my application
  /// with a token to authenticate the user
  await CommonFactory.makeCacheManagerAdapter().save(
    key: 'current_user',
    value: {'accessToken': 'valid_token'},
  );
  runApp(const App());
}