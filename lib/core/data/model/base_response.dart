import 'dart:convert';

class BaseResponse {
  String error;
  String message;
  String pin;
  String loginPin;
  String validationPin;
  String missingEnderPin;
  String userId;

  BaseResponse({this.error, this.message});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    error = json['Erro'];
    message = json['Resultado'];
    pin = json['NR_PIN_VALIDACAO'];
    validationPin = json['Pin para validacao'];
    loginPin = json['NR_PIN'];
    missingEnderPin = json['FL_Pendente_Validacao'];
    userId = json['Id_Usuario'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Erro'] = this.error;
    data['Resultado'] = this.message;
    data['NR_PIN_VALIDACAO'] = this.pin;
    data['Pin para validacao'] = this.validationPin;
    data['FL_Pendente_Validacao'] = this.missingEnderPin;
    data['NR_PIN'] = this.loginPin;
    data['Id_Usuario'] = this.userId;
    return data;
  }

  String toJson() => json.encode(toMap());

  bool isSucessful() {
    var errorLowerCased = this.error.toLowerCase();
    return errorLowerCased == "false";
  }
}
