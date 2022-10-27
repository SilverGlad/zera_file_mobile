import 'dart:convert';

class MenuRequest {
  String path;
  String id;
  String pegaDadosOnline;

  MenuRequest({this.path, this.id, this.pegaDadosOnline});

  MenuRequest.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    id = json['id_familia'];
    pegaDadosOnline = json['Pega_dados_online'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['id_familia'] = this.id;
    data['Pega_dados_online'] = this.pegaDadosOnline;
    return data;
  }

  String toJson() => json.encode(toMap());
}
