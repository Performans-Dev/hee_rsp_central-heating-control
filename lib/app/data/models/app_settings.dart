import 'dart:convert';

class AppSettings {
  String modifiedOn;
  int minAppVersion;
  Map<String, String> privacyPolicy;
  Map<String, String> termsOfUse;
  AppSettings({
    required this.modifiedOn,
    required this.minAppVersion,
    required this.privacyPolicy,
    required this.termsOfUse,
  });

  Map<String, dynamic> toMap() {
    return {
      'modifiedOn': modifiedOn,
      'minAppVersion': minAppVersion,
      'privacyPolicy': privacyPolicy,
      'termsOfUse': termsOfUse,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      modifiedOn: map['modifiedOn'] ?? '',
      minAppVersion: map['minAppVersion']?.toInt() ?? 0,
      privacyPolicy: Map<String, String>.from(map['privacyPolicy']),
      termsOfUse: Map<String, String>.from(map['termsOfUse']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) =>
      AppSettings.fromMap(json.decode(source));
}
