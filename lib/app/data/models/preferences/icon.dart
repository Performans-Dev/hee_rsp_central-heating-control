import 'dart:convert';

class IconDefinition {
  final String url;
  final String category;
  IconDefinition({
    required this.url,
    required this.category,
  });

  IconDefinition copyWith({
    String? url,
    String? category,
  }) {
    return IconDefinition(
      url: url ?? this.url,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'category': category,
    };
  }

  factory IconDefinition.fromMap(Map<String, dynamic> map) {
    return IconDefinition(
      url: map['url'] ?? '',
      category: map['category'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IconDefinition.fromJson(String source) => IconDefinition.fromMap(json.decode(source));

  @override
  String toString() => 'IconDefinition(url: $url, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is IconDefinition &&
      other.url == url &&
      other.category == category;
  }

  @override
  int get hashCode => url.hashCode ^ category.hashCode;
}
