class OrderItem {
  String ordem;
  String idProduto;
  String ds;
  String qtde;
  String vlTotal;
  String obs;
  String acompanhamento;

  OrderItem(
      {this.ordem,
      this.idProduto,
      this.ds,
      this.qtde,
      this.vlTotal,
      this.obs,
      this.acompanhamento,});

  OrderItem.fromJson(Map<String, dynamic> json) {
    ordem = json['ordem'];
    idProduto = json['id_pro'];
    ds = json['ds_pro'];
    vlTotal = json['vl_total_pro'];
    obs = json['observacao'];
    acompanhamento = json['acompanhamentos'];
    qtde = json['qtde'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ordem'] = this.ordem;
    data['id_pro'] = this.idProduto;
    data['ds_pro'] = this.ds;
    data['qtde'] = this.qtde;
    data['vl_total_pro'] = this.vlTotal;
    data['observacao'] = this.obs;
    data['acompanhamentos'] = this.acompanhamento;
    return data;
  }
}