import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController extends ChangeNotifier {
  Locale? _appLocale;
  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (type == const Locale('en')) {
      await sp.setString('language_code', 'en');
    } else if (type == const Locale('ta')) {
      await sp.setString('language_code', 'ta');
    } else {
      await sp.setString('language_code', 'hi');
    }
    _appLocale = type;
    notifyListeners();
  }
}
