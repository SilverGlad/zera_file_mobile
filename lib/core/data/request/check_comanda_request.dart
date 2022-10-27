import 'dart:convert';

class CheckComandaRequest {
  String hostLojaFenix;
  String nrComanda;

  CheckComandaRequest({this.hostLojaFenix, this.nrComanda});

  CheckComandaRequest.fromJson(Map<String, dynamic> json) {
    hostLojaFenix = json['host_loja_fenix'];
    nrComanda = json['nr_comanda'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['host_loja_fenix'] = this.hostLojaFenix;
    data['nr_comanda'] = this.nrComanda;
    return data;
  }

  String toJson() => json.encode(toMap());
}
