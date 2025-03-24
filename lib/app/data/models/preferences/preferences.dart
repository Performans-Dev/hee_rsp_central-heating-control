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
    return Preferences(
      language: Language.fromMap(map['language']),
      timezone: Timezone.fromMap(map['timezone']),
      dateFormat: map['dateFormat'] ?? '',
      timeFormat: map['timeFormat'] ?? '',
      appTheme: map['appTheme'] ?? '',
      isDark: map['isDark'] ?? false,
      screenSaverType: ScreenSaverType.values[map['screenSaverType'] ?? 1],
      lockDurationIdleTimeout: map['lockDurationIdleTimeout'] ?? 60,
      slideShowDuration: map['slideShowDuration'] ?? 9,
      selectedImageIndex: map['selectedImageIndex'],
    );
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

  factory Preferences.fromJson(String source) =>
      Preferences.fromMap(json.decode(source));
}
