// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart'
    show ScreenSaverType;
import 'package:central_heating_control/app/data/models/preferences/language.dart';
import 'package:central_heating_control/app/data/models/preferences/timezone.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:get/get.dart';

class Preferences {
  Language language;
  Timezone timezone;
  String dateFormat;
  String timeFormat;
  String appTheme;
  bool isDark;
  ScreenSaverType screenSaverType;
  int lockDurationIdleTimeout;
  int slideShowDuration;
  int? selectedImageIndex;
  Preferences({
    required this.language,
    required this.timezone,
    required this.dateFormat,
    required this.timeFormat,
    required this.appTheme,
    this.isDark = false,
    required this.screenSaverType,
    required this.lockDurationIdleTimeout,
    required this.slideShowDuration,
    this.selectedImageIndex,
  });

  Preferences copyWith({
    Language? language,
    Timezone? timezone,
    String? dateFormat,
    String? timeFormat,
    String? appTheme,
    bool? isDark,
    ScreenSaverType? screenSaverType,
    int? lockDurationIdleTimeout,
    int? slideShowDuration,
    int? selectedImageIndex,
  }) {
    return Preferences(
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      appTheme: appTheme ?? this.appTheme,
      isDark: isDark ?? this.isDark,
      screenSaverType: screenSaverType ?? this.screenSaverType,
      lockDurationIdleTimeout:
          lockDurationIdleTimeout ?? this.lockDurationIdleTimeout,
      slideShowDuration: slideShowDuration ?? this.slideShowDuration,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language.toMap(),
      'timezone': timezone.toMap(),
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'appTheme': appTheme,
      'isDark': isDark,
      'screenSaverType': screenSaverType.index,
      'lockDurationIdleTimeout': lockDurationIdleTimeout,
      'slideShowDuration': slideShowDuration,
      'selectedImageIndex': selectedImageIndex,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    try {
      // Safely extract language
      Language language;
      try {
        language = map['language'] is Map<String, dynamic>
            ? Language.fromMap(map['language'])
            : StaticProvider.getLanguageList.first;
      } catch (e) {
        language = StaticProvider.getLanguageList.first;
      }

      // Safely extract timezone
      Timezone timezone;
      try {
        timezone = map['timezone'] is Map<String, dynamic>
            ? Timezone.fromMap(map['timezone'])
            : StaticProvider.getTimezoneList.firstWhereOrNull((e) => e.name == 'Istanbul') ??
                StaticProvider.getTimezoneList.first;
      } catch (e) {
        timezone = StaticProvider.getTimezoneList.firstWhereOrNull((e) => e.name == 'Istanbul') ??
            StaticProvider.getTimezoneList.first;
      }

      // Safely extract screen saver type
      ScreenSaverType screenSaverType;
      try {
        final screenSaverTypeIndex = map['screenSaverType'] is int ? map['screenSaverType'] : 1;
        screenSaverType = ScreenSaverType.values[screenSaverTypeIndex < ScreenSaverType.values.length 
            ? screenSaverTypeIndex 
            : 1];
      } catch (e) {
        screenSaverType = ScreenSaverType.slidePictures;
      }

      return Preferences(
        language: language,
        timezone: timezone,
        dateFormat: map['dateFormat'] is String ? map['dateFormat'] : StaticProvider.getDateFormatList.first,
        timeFormat: map['timeFormat'] is String ? map['timeFormat'] : StaticProvider.getTimeFormatList.first,
        appTheme: map['appTheme'] is String ? map['appTheme'] : StaticProvider.getThemeList.first,
        isDark: map['isDark'] is bool ? map['isDark'] : false,
        screenSaverType: screenSaverType,
        lockDurationIdleTimeout: map['lockDurationIdleTimeout'] is int ? map['lockDurationIdleTimeout'] : 60,
        slideShowDuration: map['slideShowDuration'] is int ? map['slideShowDuration'] : 9,
        selectedImageIndex: map['selectedImageIndex'] is int ? map['selectedImageIndex'] : null,
      );
    } catch (e) {
      print('Error parsing preferences: $e');
      return Preferences.empty();
    }
  }

  factory Preferences.empty() => Preferences(
        language: StaticProvider.getLanguageList.first,
        timezone: StaticProvider.getTimezoneList
                .firstWhereOrNull((e) => e.name == 'Istanbul') ??
            StaticProvider.getTimezoneList.first,
        dateFormat: StaticProvider.getDateFormatList.first,
        timeFormat: StaticProvider.getTimeFormatList.first,
        appTheme: StaticProvider.getThemeList.first,
        isDark: false,
        screenSaverType: ScreenSaverType.slidePictures,
        lockDurationIdleTimeout: 60,
        slideShowDuration: 9,
        selectedImageIndex: null,
      );

  String toJson() => json.encode(toMap());

  factory Preferences.fromJson(String source) {
    try {
      final decoded = json.decode(source);
      if (decoded is Map<String, dynamic>) {
        return Preferences.fromMap(decoded);
      } else {
        print('Invalid preferences format: not a map');
        return Preferences.empty();
      }
    } catch (e) {
      print('Error decoding preferences JSON: $e');
      return Preferences.empty();
    }
  }
}
