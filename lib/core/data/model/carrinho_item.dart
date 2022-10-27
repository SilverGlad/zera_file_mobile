class CarrinhoItens {
  String ordem;
  String idProduto;
  String ds;
  String un;
  String unidade;
  String vlUn;
  String qtde;
  String vlTotal;
  String obs;
  String acompanhamento;
  String urlImage;
  String pendingItem;

  CarrinhoItens(
      {this.ordem,
      this.idProduto,
      this.ds,
      this.un,
      this.unidade,
      this.vlUn,
      this.qtde,
      this.vlTotal,
      this.obs,
      this.acompanhamento,
      this.urlImage,
      this.pendingItem});

  CarrinhoItens.fromJson(Map<String, dynamic> json) {
    ordem = json['ordem'];
    idProduto = json['id_produto'];
    ds = json['ds'];
    un = json['un'];
    unidade = json['unidade'];
    vlUn = json['vl_un'];
    qtde = json['qtde'];
    vlTotal = json['vl_total'];
    obs = json['obs'];
    acompanhamento = json['acompanhamento'];
    urlImage = json['Url_Imagem'];
    pendingItem = json['Pendente_de_confirmacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ordem'] = this.ordem;
    data['id_produto'] = this.idProduto;
    data['ds'] = this.ds;
    data['un'] = this.un;
    data['unidade'] = this.unidade;
    data['vl_un'] = this.vlUn;
    data['qtde'] = this.qtde;
    data['vl_total'] = this.vlTotal;
    data['obs'] = this.obs;
    data['acompanhamento'] = this.acompanhamento;
    data['Url_Imagem'] = this.urlImage;
    data['Pendente_de_confirmacao'] = this.pendingItem;
    return data;
  }
}
