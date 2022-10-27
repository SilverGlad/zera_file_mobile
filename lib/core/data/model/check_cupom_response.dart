class CheckCupomResponse {
  String erro;
  String mensagem = "";
  String valor_Desconto_concedido = "";

  CheckCupomResponse({this.erro, this.mensagem, this.valor_Desconto_concedido});

  CheckCupomResponse.fromJson(Map<String, dynamic> json) {
    erro = json["Erro"];
    mensagem = json["Mensagem"];
    valor_Desconto_concedido = json["Valor_Desconto_concedido"];
  }
}
