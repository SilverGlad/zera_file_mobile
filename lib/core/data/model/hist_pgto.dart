import 'dart:convert';

class PaymentHistoric {
  String establishmentName;
  String establishmentCapa;
  String comanda;
  String status;
  String paymentDate;
  String paymentTime;
  String total;
  String paymentForm;
  String transactionID;
  List<String> itens;

  PaymentHistoric({
    this.establishmentName,
    this.establishmentCapa,
    this.comanda,
    this.status,
    this.paymentDate,
    this.paymentTime,
    this.total,
    this.paymentForm,
    this.transactionID,
    this.itens,
  });

  fromJson(Map<String, dynamic> json) {
    establishmentName = json['establishmentName'];
    establishmentCapa = json['establishmentCapa'];
    comanda = json['comanda'];
    status = json['status'];
    paymentDate = json['paymentDate'];
    paymentTime = json['paymentTime'];
    total = json['total'];
    paymentForm = json['paymentForm'];
    transactionID = json['transactionID'];
    itens = json['itens'].cast<String>();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['establishmentName'] = this.establishmentName;
    data['establishmentCapa'] = this.establishmentCapa;
    data['comanda'] = this.comanda;
    data['status'] = this.status;
    data['paymentDate'] = this.paymentDate;
    data['paymentTime'] = this.paymentTime;
    data['total'] = this.total;
    data['paymentForm'] = this.paymentForm;
    data['transactionID'] = this.transactionID;
    if (this.itens != null) {
      data['itens'] = this.itens;
    }
    return data;
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toDb(String user_id) {
    return {
      'payment_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': user_id,
      'data': toJson(),
    };
  }

  PaymentHistoric.fromDb(Map<String, dynamic> data) {
    fromJson(json.decode(data['data']));
  }
}
