import 'dart:convert';

class RequestSmsUpdateAccountRequest {
  String fone;

  RequestSmsUpdateAccountRequest({this.fone});

  RequestSmsUpdateAccountRequest.fromJson(Map<String, dynamic> json) {
    fone = json['fone'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fone'] = this.fone;
    return data;
  }

  String toJson() => json.encode(toMap());
}
