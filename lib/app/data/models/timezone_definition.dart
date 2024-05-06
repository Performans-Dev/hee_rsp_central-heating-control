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
