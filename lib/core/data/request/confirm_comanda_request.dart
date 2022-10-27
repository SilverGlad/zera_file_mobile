import 'dart:convert';

class ConfirmComandaRequest {
  String nr_pedido;
  String id_loja;
  String id_usuario;

  ConfirmComandaRequest({this.nr_pedido, this.id_loja, this.id_usuario});

  ConfirmComandaRequest.fromJson(Map<String, dynamic> json) {
    nr_pedido = json['nr_pedido'];
    id_loja = json['id_loja'];
    id_usuario = json['id_usuario'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nr_pedido'] = this.nr_pedido;
    data['id_loja'] = this.id_loja;
    data['id_usuario'] = this.id_usuario;
    return data;
  }

  String toJson() => json.encode(toMap());
}
