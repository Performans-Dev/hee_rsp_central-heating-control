import 'dart:convert';

class ForgotPasswordRequest {
  String email;
  String? code;
  ForgotPasswordRequest({
    required this.email,
    this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'code': code,
    };
  }

  factory ForgotPasswordRequest.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordRequest(
      email: map['email'] ?? '',
      code: map['code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ForgotPasswordRequest.fromJson(String source) => ForgotPasswordRequest.fromMap(json.decode(source));
}
