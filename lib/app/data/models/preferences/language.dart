import 'dart:convert';

class Language {
  final String code;
  final String country;
  final String name;

  Language({
    required this.code,
    required this.country,
    required this.name,
  });

  Language copyWith({
    String? code,
    String? country,
    String? name,
  }) {
    return Language(
      code: code ?? this.code,
      country: country ?? this.country,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'country': country,
      'name': name,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      code: map['code'] ?? '',
      country: map['country'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) =>
      Language.fromMap(json.decode(source));
      
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Language &&
        other.code == code &&
        other.country == country &&
        other.name == name;
  }

  @override
  int get hashCode => code.hashCode ^ country.hashCode ^ name.hashCode;
}
