import 'dart:convert';

class Timezone {
  final String zone;
  final String gmt;
  final String name;
  Timezone({
    required this.zone,
    required this.gmt,
    required this.name,
  });

  Timezone copyWith({
    String? zone,
    String? gmt,
    String? name,
  }) {
    return Timezone(
      zone: zone ?? this.zone,
      gmt: gmt ?? this.gmt,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zone': zone,
      'gmt': gmt,
      'name': name,
    };
  }

  factory Timezone.fromMap(Map<String, dynamic> map) {
    return Timezone(
      zone: map['zone'] ?? '',
      gmt: map['gmt'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Timezone.fromJson(String source) =>
      Timezone.fromMap(json.decode(source));
}
