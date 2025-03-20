import 'dart:convert';

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
  Preferences({
    required this.language,
    required this.timezone,
    required this.dateFormat,
    required this.timeFormat,
    required this.appTheme,
    this.isDark = false,
  });

  Preferences copyWith({
    Language? language,
    Timezone? timezone,
    String? dateFormat,
    String? timeFormat,
    String? appTheme,
    bool? isDark,
  }) {
    return Preferences(
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      appTheme: appTheme ?? this.appTheme,
      isDark: isDark ?? this.isDark,
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
      );

  String toJson() => json.encode(toMap());

  factory Preferences.fromJson(String source) =>
      Preferences.fromMap(json.decode(source));
}
