import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'en_us.dart';
import 'es_es.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('es', 'ES');
  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('es', 'ES');
  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'English',
    'Español',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS, // lang/en_us.dart
    'es_ES': esES, // lang/tr_tr.dart
  };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale!;
  }
}
