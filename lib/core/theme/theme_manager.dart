import 'package:flutter/material.dart';

enum AppThemeMode { light, dark }

class ThemeManager extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.light;
  bool _useSystemTheme = true; 

  AppThemeMode get themeMode => _themeMode;
  bool get useSystemTheme => _useSystemTheme;

  bool get isDarkMode => _themeMode == AppThemeMode.dark;

  void toggleTheme() {
    _useSystemTheme = false;
    _themeMode = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    notifyListeners();
  }

  void setTheme(AppThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
