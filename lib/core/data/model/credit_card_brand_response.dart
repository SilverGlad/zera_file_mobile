class CreditCardBrandResponse {
  String erro;
  String mensagem = "";
  String result = "";
  String operadora;
  String authCode;
  String picPayIdCode;
  String picPayUrl;
  String paymentStatus;
  String pixIdCode;
  String pixQrCode;
  String pixPaymentStatus;
  String transaction_id;

  CreditCardBrandResponse(
      {this.erro,
      this.mensagem,
      this.operadora,
      this.authCode,
      this.picPayIdCode,
      this.picPayUrl,
      this.paymentStatus,
      this.pixIdCode,
      this.pixQrCode,
      this.pixPaymentStatus,
      this.transaction_id});

  CreditCardBrandResponse.fromJson(Map<String, dynamic> json) {
    operadora = json['Operadora'];
    erro = json["Erro"];
    mensagem = json["Mensagem"];
    result = json["Resultado"];
    authCode = json["Codigo_Autorizadora"];
    picPayIdCode = json["Reference_id"];
    picPayUrl = json["Url_para_pagamento"];
    paymentStatus = json["Status"];
    pixIdCode = json["Merchant_reference"];
    pixQrCode = json["Qr_code_para_pagto_pix"];
    transaction_id = json["transaction_id"];
  }
}
