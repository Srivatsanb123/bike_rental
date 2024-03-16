import 'package:bike_rental/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleData {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
  ];

  static void changeLocale(BuildContext context, Locale newLocale) {
    AppLocalizations.delegate.load(newLocale);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MyApp(),
    ));
  }

  // Other localization data can be defined here
  static const Map<String, dynamic> EN = {
    'title': 'TrackED',
    // Other English language translations
  };

  static const Map<String, dynamic> HI = {
    'title': 'ट्रैक',
    // Other Hindi language translations
  };

  static const Map<String, dynamic> TA = {
    'title': 'டிராக்ஈடி',
    // Other Tamil language translations
  };
}
