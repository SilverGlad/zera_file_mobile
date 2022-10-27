import 'dart:convert';

class UserDataRequest {
  String id;

  UserDataRequest({this.id});

  UserDataRequest.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    return data;
  }

  String toJson() => json.encode(toMap());
}
