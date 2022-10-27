import 'dart:convert';

class RemoveProductRequest {
  String path;
  String nrPedido;
  String nrOrdem;
  String nrComanda;
  String idLoja;

  RemoveProductRequest({
    this.path,
    this.nrPedido,
    this.nrOrdem,
    this.nrComanda,
    this.idLoja,
  });

  RemoveProductRequest.fromJson(Map<String, dynamic> json) {
    path = json['Path_BD'];
    nrPedido = json['ID_PEDIDO'];
    nrOrdem = json['nr_ordem'];
    nrComanda = json['nr_comanda'];
    idLoja = json['id_loja'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Path_BD'] = this.path;
    data['ID_PEDIDO'] = this.nrPedido;
    data['nr_ordem'] = this.nrOrdem;
    data['nr_comanda'] = this.nrComanda;
    data['id_loja'] = this.idLoja;
    return data;
  }

  String toJson() => json.encode(toMap());
}
