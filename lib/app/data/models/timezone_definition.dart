import 'dart:convert';

import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:get/get.dart';

class TimezoneDefinition {
  String zone;
  String gmt;
  String name;
  TimezoneDefinition({
    required this.zone,
    required this.gmt,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'zone': zone,
      'gmt': gmt,
      'name': name,
    };
  }

  Duration offset() {
    final timeOffset =
        gmt.replaceAll('(', '').replaceAll(')', '').replaceAll('GMT', '');
    final regex = RegExp(r'^([-+]?\d+):(\d{2})$');
    final match = regex.firstMatch(timeOffset);
    if (match == null) return Duration.zero;
    final String hourPart = match.group(1)!;
    final String minutePart = match.group(2)!;
    final int hours = int.parse(hourPart);
    final int minutes = int.parse(minutePart);
    return Duration(hours: hours, minutes: minutes);
  }

  factory TimezoneDefinition.utc() {
    return TimezoneDefinition(
      zone: 'UTC',
      gmt: '+00:00',
      name: 'UTC',
    );
  }

  factory TimezoneDefinition.fromApp() {
    try {
      final AppController app = Get.find();
      final timezoneName = app.preferencesDefinition.timezone;
      final map = StaticProvider.getTimezoneList
          .firstWhere((e) => e["name"] == timezoneName);
      return TimezoneDefinition.fromMap(map);
    } on Exception catch (_) {
      return TimezoneDefinition.utc();
    }
  }

  factory TimezoneDefinition.fromMap(Map<String, dynamic> map) {
    return TimezoneDefinition(
      zone: map['zone'] ?? '',
      gmt: map['gmt'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TimezoneDefinition.fromJson(String source) =>
      TimezoneDefinition.fromMap(json.decode(source));
}
