import 'package:flutter/material.dart';
import 'package:flutter_best_practices/managers/theme_manager.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/router.dart';
import 'package:flutter_best_practices/themes/colored_themes.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';


class App extends StatefulWidget {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _themeManager = Provider.get<ThemeManager>();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final coreTheme = CoreTheme().generate();
    final lightTheme = LightTheme().generate(baseTheme: coreTheme);
    final darkTheme = DarkTheme().generate(baseTheme: coreTheme);
    return ListenableBuilder(
      listenable: _themeManager,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Flutter Best Practices',
          scaffoldMessengerKey: App.scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeManager.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
