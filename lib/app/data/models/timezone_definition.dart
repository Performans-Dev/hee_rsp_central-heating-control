import 'dart:convert';

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
