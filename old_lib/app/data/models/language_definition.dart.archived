import 'dart:convert';

class LanguageDefinition {
  String languageCode;
  String countryCode;
  String name;
  LanguageDefinition({
    required this.languageCode,
    required this.countryCode,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'languageCode': languageCode,
      'countryCode': countryCode,
      'name': name,
    };
  }

  factory LanguageDefinition.fromMap(Map<String, dynamic> map) {
    return LanguageDefinition(
      languageCode: map['languageCode'] ?? '',
      countryCode: map['countryCode'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageDefinition.fromJson(String source) =>
      LanguageDefinition.fromMap(json.decode(source));
}
