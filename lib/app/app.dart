import 'package:advanced_flutter_course/app/core/factories/page_factory.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    final colorSchema = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(
          color: colorSchema.primaryContainer,
        ),
        dividerTheme: const DividerThemeData(
          space: 0,
        ),
        brightness: Brightness.dark,
        colorScheme: colorSchema,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: PageFactory.makeNextEventPage(),
    );
  }
}
