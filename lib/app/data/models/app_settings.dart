import 'dart:convert';

class AppSettings {
  String modifiedOn;
  int minAppVersion;
  AppSettings({
    required this.modifiedOn,
    required this.minAppVersion,
  });

  Map<String, dynamic> toMap() {
    return {
      'modifiedOn': modifiedOn,
      'minAppVersion': minAppVersion,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      modifiedOn: map['modifiedOn'] ?? '',
      minAppVersion: map['minAppVersion']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) =>
      AppSettings.fromMap(json.decode(source));
}
