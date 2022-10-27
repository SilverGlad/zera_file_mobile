import 'dart:convert';

class CheckCupomRequest {
  String vl_total_comanda;
  String id_loja;
  String id_usu;
  String txt_cupom_promocional;

  CheckCupomRequest({this.vl_total_comanda, this.id_loja, this.id_usu, this.txt_cupom_promocional});

  CheckCupomRequest.fromJson(Map<String, dynamic> json) {
    vl_total_comanda = json['vl_total_comanda'];
    id_loja = json['id_loja'];
    id_usu = json['id_usu'];
    txt_cupom_promocional = json['txt_cupom_promocional'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vl_total_comanda'] = this.vl_total_comanda;
    data['id_loja'] = this.id_loja;
    data['id_usu'] = this.id_usu;
    data['txt_cupom_promocional'] = this.txt_cupom_promocional;
    return data;
  }

  String toJson() => json.encode(toMap());
}
