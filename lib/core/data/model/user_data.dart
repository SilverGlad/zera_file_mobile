import 'dart:convert';

class UserData {
  String phone;
  String fullName;
  String password;
  String document;
  String pin;
  String id;
  String mailAddress;
  String pushToken;

  UserData(
      {this.phone,
      this.fullName,
      this.password,
      this.document,
      this.pin,
      this.id,
      this.mailAddress, 
      this.pushToken});

  UserData.fromJson(Map<String, dynamic> json) {
    phone = json['FONE'];
    fullName = json['NOME'];
    password = json['SENHA'];
    document = json['CPF'];
    id = json['ID'];
    mailAddress = json['EMAIL'];
    pushToken = json["PUSH_TOKEN"];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FONE'] = this.phone;
    data['NOME'] = this.fullName;
    data['EMAIL'] = this.mailAddress;
    data['SENHA'] = this.password;
    data['CPF'] = this.document;
    data['ID'] = this.id;
    data['NR_PIN'] = this.pin;
    data['PUSH_TOKEN'] = this.pushToken;
    return data;
  }

  String toJson() => json.encode(toMap());
}
