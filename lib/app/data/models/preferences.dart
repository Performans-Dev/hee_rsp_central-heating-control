// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';

class PreferencesDefinition {
  String language;
  String timezone;
  String dateFormat;
  int themeIndex;
  int themeModeIndex;
  ScreenSaverType screensaverType;
  int lockDurationIdleTimeout;
  int slideShowTimer;
  bool didSelectedLanguage;
  bool didSelectedTimezone;
  bool didSelectedDateFormat;
  bool didSelectedTheme;
  bool didWelcomeShown;
  bool didThankyouShown;
  PreferencesDefinition({
    required this.language,
    required this.timezone,
    required this.dateFormat,
    required this.themeIndex,
    required this.themeModeIndex,
    required this.screensaverType,
    required this.lockDurationIdleTimeout,
    required this.slideShowTimer,
    required this.didSelectedLanguage,
    required this.didSelectedTimezone,
    required this.didSelectedDateFormat,
    required this.didSelectedTheme,
    this.didWelcomeShown = false,
    this.didThankyouShown = false,
  });
//TODO: kullanıcı saati değiştirmişse aradaki farkı burada bir int ile tutmamız lazım. timeget gibi bir değişken
//default değeri o

  bool get allSelected =>
      didWelcomeShown &&
      didThankyouShown &&
      didSelectedLanguage &&
      didSelectedTimezone &&
      didSelectedDateFormat &&
      didSelectedTheme;

  bool get isDark => themeModeIndex == ThemeMode.dark.index;

  factory PreferencesDefinition.empty() => PreferencesDefinition(
        language: StaticProvider.getLanguageList.first['languageCode'],
        timezone: StaticProvider.getTimezoneList
            .firstWhere((e) => e["name"]?.contains("Istanbul"))['name'],
        dateFormat: StaticProvider.getDateFormatList.first,
        themeIndex: 0,
        themeModeIndex: ThemeMode.dark.index,
        screensaverType: ScreenSaverType.slidePictures,
        lockDurationIdleTimeout: StaticProvider.lockDurationIdleTimeout,
        slideShowTimer: StaticProvider.slideShowTimer,
        didSelectedLanguage: false,
        didSelectedTimezone: false,
        didSelectedDateFormat: false,
        didSelectedTheme: false,
        didWelcomeShown: false,
        didThankyouShown: false,
      );

  String toJson() => json.encode(toMap());

  factory PreferencesDefinition.fromJson(String source) =>
      PreferencesDefinition.fromMap(json.decode(source));

  PreferencesDefinition copyWith({
    String? language,
    String? timezone,
    String? dateFormat,
    int? themeIndex,
    int? themeModeIndex,
    ScreenSaverType? screensaverType,
    int? lockDurationIdleTimeout,
    int? slideShowTimer,
    bool? didSelectedLanguage,
    bool? didSelectedTimezone,
    bool? didSelectedDateFormat,
    bool? didSelectedTheme,
    bool? didWelcomeShown,
    bool? didThankyouShown,
  }) {
    return PreferencesDefinition(
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      dateFormat: dateFormat ?? this.dateFormat,
      themeIndex: themeIndex ?? this.themeIndex,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      screensaverType: screensaverType ?? this.screensaverType,
      lockDurationIdleTimeout:
          lockDurationIdleTimeout ?? this.lockDurationIdleTimeout,
      slideShowTimer: slideShowTimer ?? this.slideShowTimer,
      didSelectedLanguage: didSelectedLanguage ?? this.didSelectedLanguage,
      didSelectedTimezone: didSelectedTimezone ?? this.didSelectedTimezone,
      didSelectedDateFormat:
          didSelectedDateFormat ?? this.didSelectedDateFormat,
      didSelectedTheme: didSelectedTheme ?? this.didSelectedTheme,
      didWelcomeShown: didWelcomeShown ?? this.didWelcomeShown,
      didThankyouShown: didThankyouShown ?? this.didThankyouShown,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'timezone': timezone,
      'dateFormat': dateFormat,
      'themeIndex': themeIndex,
      'themeModeIndex': themeModeIndex,
      'screensaverType': screensaverType.index,
      'lockDurationIdleTimeout': lockDurationIdleTimeout,
      'slideShowTimer': slideShowTimer,
      'didSelectedLanguage': didSelectedLanguage,
      'didSelectedTimezone': didSelectedTimezone,
      'didSelectedDateFormat': didSelectedDateFormat,
      'didSelectedTheme': didSelectedTheme,
      'didWelcomeShown': didWelcomeShown,
      'didThankyouShown': didThankyouShown,
    };
  }

  factory PreferencesDefinition.fromMap(Map<String, dynamic> map) {
    return PreferencesDefinition(
      language: map['language'] ?? '',
      timezone: map['timezone'] ?? '',
      dateFormat: map['dateFormat'] ?? '',
      themeIndex: map['themeIndex']?.toInt() ?? 0,
      themeModeIndex: map['themeModeIndex']?.toInt() ?? 0,
      screensaverType: ScreenSaverType.values[map['screensaverType'] ?? 0],
      lockDurationIdleTimeout: map['lockDurationIdleTimeout']?.toInt() ?? 0,
      slideShowTimer: map['slideShowTimer']?.toInt() ?? 0,
      didSelectedLanguage: map['didSelectedLanguage'] ?? false,
      didSelectedTimezone: map['didSelectedTimezone'] ?? false,
      didSelectedDateFormat: map['didSelectedDateFormat'] ?? false,
      didSelectedTheme: map['didSelectedTheme'] ?? false,
      didWelcomeShown: map['didWelcomeShown'] ?? false,
      didThankyouShown: map['didThankyouShown'] ?? false,
    );
  }
}
