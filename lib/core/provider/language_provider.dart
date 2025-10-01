import 'package:bikers_app/core/i18n/strings.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _language = Global.currentLanguage;

  String get language => _language;

  bool get isEnglish => _language == 'en';

  void toggleLanguage() {
    _language = (_language == 'es') ? 'en' : 'es';
    notifyListeners();
  }
}
