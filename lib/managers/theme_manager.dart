import 'package:flutter/material.dart';
import 'package:flutter_best_practices/utils/deferred_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends DeferredChangeNotifier {
  static const String _themePreferenceKey = 'com.example.flutter_best_practices.theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePreferenceKey);

    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
          break;
      }
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    String themeValue;

    switch (mode) {
      case ThemeMode.light:
        themeValue = 'light';
        break;
      case ThemeMode.dark:
        themeValue = 'dark';
        break;
      default:
        themeValue = ThemeMode.system.name;
        break;
    }

    await prefs.setString(_themePreferenceKey, themeValue);
    notifyListeners();
  }
}
