import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String boxName = 'settingsBox';
  static const String keyThemeMode = 'themeMode';
  bool _useSystemTheme = true; 
  bool get useSystemTheme => _useSystemTheme;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _useSystemTheme = false;
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(boxName);
    final saved = box.get(keyThemeMode);
    if (saved != null) {
      _themeMode = ThemeMode.values[saved];
      notifyListeners();
    }
  }

  Future<void> _saveTheme() async {
    final box = await Hive.openBox(boxName);
    await box.put(keyThemeMode, _themeMode.index);
  }
}
