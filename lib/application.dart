import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';
import 'core/themes/dark.theme.dart';
import 'core/themes/light.theme.dart';

class Application extends StatefulWidget {
  const Application({
    Key? key
  }) : super(key: key);

  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  ThemeMode _currentTheme = ThemeMode.system;

  void setCurrentTheme(ThemeMode themeMode) => setState(() => _currentTheme = themeMode);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: this),
        Provider.value(value: _currentTheme),
      ],
      child: MaterialApp(
        title: 'Default themes',
        themeMode: _currentTheme,
        theme: getLightTheme(context),
        darkTheme: getDarkTheme(context),
        home: const Home(),
      ),
    );
  }
}