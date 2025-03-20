import 'dart:convert';

class WiFiCredentials {
  String ssid;
  String password;
  WiFiCredentials({
    required this.ssid,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'ssid': ssid,
      'password': password,
    };
  }

  factory WiFiCredentials.fromMap(Map<String, dynamic> map) {
    return WiFiCredentials(
      ssid: map['ssid'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WiFiCredentials.fromJson(String source) =>
      WiFiCredentials.fromMap(json.decode(source));
}
