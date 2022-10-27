import 'carrinho_item.dart';

class ComandaResponse {
  String error;
  String message;
  String nrPedido;
  String subTotal;
  String totalTaxaServico;
  String totalComanda;
  List<CarrinhoItens> itens;

  ComandaResponse({this.error, this.message, this.nrPedido, this.subTotal, this.totalTaxaServico, this.totalComanda, this.itens});

  ComandaResponse.fromJson(Map<String, dynamic> json) {
    error = json['Erro'];
    message = json['Mensagem'];
    nrPedido = json['Nr_Pedido'];
    subTotal = json['subtotal'];
    totalComanda = json['total_comanda'];
    totalTaxaServico = json['total_taxa_servico'];
    if (json['itens'] != null) {
      itens = <CarrinhoItens>[];
      json['itens'].forEach((v) {
        itens.add(new CarrinhoItens.fromJson(v));
      });
    }
  }

  bool isSucessful() {
    var errorLowerCased = this.error.toLowerCase();
    return errorLowerCased == "false";
  }
}
