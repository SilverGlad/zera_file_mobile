import 'dart:convert';

class ScheduleResponse {
  String error;
  String message;
  List<String> schedules;

  ScheduleResponse({this.error, this.message});

  ScheduleResponse.fromJson(Map<String, dynamic> json) {
    error = json['Erro'];
    message = json['Resultado'];
    schedules = json['Agenda'].cast<String>();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Erro'] = this.error;
    data['Resultado'] = this.message;
    data['Agenda'] = this.schedules;
    return data;
  }

  String toJson() => json.encode(toMap());

  bool isSucessful() {
    var errorLowerCased = this.error.toLowerCase();
    return errorLowerCased == "false";
  }
}
