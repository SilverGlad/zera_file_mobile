import 'dart:convert';

class ScheduleRequest {
  String id;

  ScheduleRequest({this.id});

  ScheduleRequest.fromJson(Map<String, dynamic> json) {
    id = json['id_loja'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_loja'] = this.id;
    return data;
  }

  String toJson() => json.encode(toMap());
}
