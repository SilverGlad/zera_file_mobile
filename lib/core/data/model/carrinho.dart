import 'carrinho_item.dart';

class Carrinho {
  String erro;
  String mensagem;
  String iD;
  String nrPedido;
  List<CarrinhoItens> itens;

  Carrinho({this.erro, this.mensagem, this.iD, this.nrPedido, this.itens});

  Carrinho.fromJson(Map<String, dynamic> json) {
    erro = json['Erro'];
    mensagem = json['Mensagem'];
    iD = json['ID'];
    nrPedido = json['Nr_Pedido'];
    if (json['itens'] != null) {
      itens = new List<CarrinhoItens>();
      json['itens'].forEach((v) {
        itens.add(new CarrinhoItens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Erro'] = this.erro;
    data['Mensagem'] = this.mensagem;
    data['ID'] = this.iD;
    data['Nr_Pedido'] = this.nrPedido;
    if (this.itens != null) {
      data['itens'] = this.itens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
