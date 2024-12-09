// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:flutter/material.dart';

class PreferencesDefinition {
  String language;
  String timezone;
  String dateFormat;
  int theme;
  int themeMode;
  ScreenSaverType screensaverType;
  int lockDurationIdleTimeout;
  int slideShowTimer;
  bool didSelectLanguage;
  bool didSelectTimezone;
  bool didSelectDateFormat;
  bool didSelectTheme;
  bool didSelectThemeMode;
  PreferencesDefinition({
    required this.language,
    required this.timezone,
    required this.dateFormat,
    required this.theme,
    required this.themeMode,
    required this.screensaverType,
    required this.lockDurationIdleTimeout,
    required this.slideShowTimer,
    required this.didSelectLanguage,
    required this.didSelectTimezone,
    required this.didSelectDateFormat,
    required this.didSelectTheme,
    required this.didSelectThemeMode,
  });
//TODO: kullanıcı saati değiştirmişse aradaki farkı burada bir int ile tutmamız lazım. timeget gibi bir değişken
//default değeri o

  bool get allSelected =>
      didSelectLanguage &&
      didSelectTimezone &&
      didSelectDateFormat &&
      didSelectTheme &&
      didSelectThemeMode;

  bool get isDark => themeMode == ThemeMode.dark.index;

  factory PreferencesDefinition.empty() => PreferencesDefinition(
        language: StaticProvider.getLanguageList.first['languageCode'],
        timezone: StaticProvider.getTimezoneList
            .firstWhere((e) => e["name"]?.contains("Istanbul"))['name'],
        dateFormat: StaticProvider.getDateFormatList.first,
        theme: 0,
        themeMode: ThemeMode.dark.index,
        screensaverType: ScreenSaverType.slidePictures,
        lockDurationIdleTimeout: StaticProvider.lockDurationIdleTimeout,
        slideShowTimer: StaticProvider.slideShowTimer,
        didSelectLanguage: false,
        didSelectTimezone: false,
        didSelectDateFormat: false,
        didSelectTheme: false,
        didSelectThemeMode: false,
      );
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'language': language,
      'timezone': timezone,
      'dateFormat': dateFormat,
      'theme': theme,
      'themeMode': themeMode,
      'screensaverType': screensaverType,
      'lockDurationIdleTimeout': lockDurationIdleTimeout,
      'slideShowTimer': slideShowTimer,
      'didSelectLanguage': didSelectLanguage,
      'didSelectTimezone': didSelectTimezone,
      'didSelectDateFormat': didSelectDateFormat,
      'didSelectTheme': didSelectTheme,
      'didSelectThemeMode': didSelectThemeMode,
    };
  }

  factory PreferencesDefinition.fromMap(Map<String, dynamic> map) {
    return PreferencesDefinition(
      language: (map['language'] ?? '') as String,
      timezone: map['timezone'] != null
          ? map['timezone'] as String
          : PreferencesDefinition.empty().timezone,
      dateFormat: map['dateFormat'] != null
          ? map['dateFormat'] as String
          : PreferencesDefinition.empty().dateFormat,
      theme: map['theme'] != null
          ? map['theme'] as int
          : PreferencesDefinition.empty().theme,
      themeMode: map['themeMode'] != null
          ? map['themeMode'] as int
          : PreferencesDefinition.empty().themeMode,
      screensaverType: ScreenSaverType.values[map['screensaverType'] ?? 2],
      lockDurationIdleTimeout: (map['lockDurationIdleTimeout'] ?? 0) as int,
      slideShowTimer: (map['slideShowTimer'] ?? 0) as int,
      didSelectLanguage: (map['didSelectLanguage'] ?? false) as bool,
      didSelectTimezone: (map['didSelectTimezone'] ?? false) as bool,
      didSelectDateFormat: (map['didSelectDateFormat'] ?? false) as bool,
      didSelectTheme: (map['didSelectTheme'] ?? false) as bool,
      didSelectThemeMode: (map['didSelectThemeMode'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreferencesDefinition.fromJson(String source) =>
      PreferencesDefinition.fromMap(
          json.decode(source) as Map<String, dynamic>);

  PreferencesDefinition copyWith({
    String? language,
    String? timezone,
    String? dateFormat,
    int? theme,
    int? themeMode,
    ScreenSaverType? screensaverType,
    int? lockDurationIdleTimeout,
    int? slideShowTimer,
    bool? didSelectLanguage,
    bool? didSelectTimezone,
    bool? didSelectDateFormat,
    bool? didSelectTheme,
    bool? didSelectThemeMode,
  }) {
    return PreferencesDefinition(
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      dateFormat: dateFormat ?? this.dateFormat,
      theme: theme ?? this.theme,
      themeMode: themeMode ?? this.themeMode,
      screensaverType: screensaverType ?? this.screensaverType,
      lockDurationIdleTimeout:
          lockDurationIdleTimeout ?? this.lockDurationIdleTimeout,
      slideShowTimer: slideShowTimer ?? this.slideShowTimer,
      didSelectLanguage: didSelectLanguage ?? this.didSelectLanguage,
      didSelectTimezone: didSelectTimezone ?? this.didSelectTimezone,
      didSelectDateFormat: didSelectDateFormat ?? this.didSelectDateFormat,
      didSelectTheme: didSelectTheme ?? this.didSelectTheme,
      didSelectThemeMode: didSelectThemeMode ?? this.didSelectThemeMode,
    );
  }
}
