import 'package:central_heating_control/app/core/localization/langs/en_us.dart';
import 'package:central_heating_control/app/core/localization/langs/tr_tr.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService {
  static final locale = _readLocale();

  static Locale _readLocale() {
    final AppController appController = Get.find();
    final language = appController.preferencesDefinition.language;
    final countryCode = StaticProvider.getLanguageList
        .firstWhere((e) => e['languageCode'] == language)['countryCode'];
    return Locale(language, countryCode);
  }

  static const fallbackLocale = Locale('tr', 'TR');

  static final langs = [
    'English',
    'Türkçe',
  ];

  static const locales = [
    Locale('en', 'US'),
    Locale('tr', 'TR'),
  ];

  static Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'tr_TR': trTR,
      };

  Future<Locale> applySavedLocale() async {
    final AppController appController = Get.find();

    String localeLang = appController.preferencesDefinition.language;
    String localeCountry = StaticProvider.getLanguageList
        .firstWhere((e) => e['languageCode'] == localeLang)['countryCode'];
    Locale l;
    if (localeLang.isEmpty || localeCountry.isEmpty) {
      l = Get.deviceLocale ?? const Locale('tr', 'TR');
    } else {
      l = Locale(localeLang, localeCountry);
    }

    await Get.updateLocale(l);
    // await Box.setString(key: Keys.localeLang, value: l.languageCode);
    // await Box.setString(
    //     key: Keys.localeCulture, value: locale.countryCode ?? 'TR');

    return l;
  }

  Future<void> changeLocale(String lang) async {
    var locale = _getLocaleFromLanguage(lang);
    if (!locales.contains(locale)) {
      locale = const Locale('en', 'US');
    }
    await Get.updateLocale(locale);
    // await Box.setString(key: Keys.localeLang, value: locale.languageCode);
    // await Box.setString(
    //     key: Keys.localeCulture, value: locale.countryCode ?? 'US');
    final AppController appController = Get.find();
    appController.setPreferencesDefinition(appController.preferencesDefinition
        .copyWith(language: locale.languageCode));
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
