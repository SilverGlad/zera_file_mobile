import 'dart:convert';

class BaseRequest {
  String userId;
  String idPedido;

  BaseRequest({this.userId, this.idPedido});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    userId = json['id_usu'];
    idPedido = json['id_pedido'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_usu'] = this.userId;
    data['id_pedido'] = this.idPedido;
    return data;
  }

  String toJson() => json.encode(toMap());
}
