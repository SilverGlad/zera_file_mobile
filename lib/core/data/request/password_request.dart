import 'dart:convert';

class PasswordRequest {
  String email;

  PasswordRequest({this.email});

  PasswordRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }

  String toJson() => json.encode(toMap());
}
