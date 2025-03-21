// ignore_for_file: avoid_print

import 'package:central_heating_control/app/core/localization/langs/en_us.dart';
import 'package:central_heating_control/app/core/localization/langs/tr_tr.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService {
  static final locale = _readLocale();

  static Locale _readLocale() {
    final AppController appController = Get.find();
    final language = appController.preferences.language;
    return Locale(language.code, language.country);
  }

  static const fallbackLocale = Locale('tr', 'TR');

  static final langs =
      StaticProvider.getLanguageList.map((e) => e.name).toList();

  static final locales = StaticProvider.getLanguageList
      .map((e) => Locale(e.code, e.country))
      .toList();

  static Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'tr_TR': trTR,
      };

  Future<Locale> applySavedLocale() async {
    final AppController appController = Get.find();

    String localeLang = appController.preferences.language.code;
    String localeCountry = appController.preferences.language.country;
    Locale l;
    if (localeLang.isEmpty || localeCountry.isEmpty) {
      l = Get.deviceLocale ?? const Locale('tr', 'TR');
    } else {
      l = Locale(localeLang, localeCountry);
    }

    print('Locale: $l');

    await Get.updateLocale(l);
    return l;
  }

  Future<void> changeLocale(String lang) async {
    var locale = _getLocaleFromLanguage(lang);
    if (!locales.contains(locale)) {
      locale = const Locale('en', 'US');
    }
    await Get.updateLocale(locale);
    final AppController appController = Get.find();
    appController.setPreferences(appController.preferences.copyWith(
        language: StaticProvider.getLanguageList
            .firstWhere((e) => e.code == locale.languageCode)));
  }

  Locale _getLocaleFromLanguage(String lang) {
    if (lang.length == 2) {
      for (var l in locales) {
        if (l.languageCode == lang) return l;
      }
    } else {
      for (int i = 0; i < langs.length; i++) {
        if (lang == langs[i]) return locales[i];
      }
    }
    return locales[0];
  }
}
