import 'dart:convert';

class RatingRequest {
  String observacao;
  String nr_avaliacao;
  String id_usu;

  RatingRequest({this.observacao, this.nr_avaliacao, this.id_usu});

  RatingRequest.fromJson(Map<String, dynamic> json) {
    observacao = json['observacao'];
    nr_avaliacao = json['nr_avaliacao'];
    id_usu = json['id_usu'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['observacao'] = this.observacao;
    data['nr_avaliacao'] = this.nr_avaliacao;
    data['id_usu'] = this.id_usu;
    return data;
  }

  String toJson() => json.encode(toMap());
}
