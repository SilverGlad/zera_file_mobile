import 'dart:convert';

import 'products.dart';

class MenuResponse {
  List<Cardapio> cardapio;

  MenuResponse({this.cardapio});

  MenuResponse.fromJson(Map<String, dynamic> json) {
    if (json['Cardapio'] != null) {
      cardapio = new List<Cardapio>();
      json['Cardapio'].forEach((v) {
        cardapio.add(new Cardapio.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cardapio != null) {
      data['Cardapio'] = this.cardapio.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cardapio {
  String iDFamilia;
  String dSFamilia;
  List<Products> produtos;

  Cardapio({this.iDFamilia, this.dSFamilia, this.produtos});

  Cardapio.fromJson(Map<String, dynamic> json) {
    iDFamilia = json['ID_Familia'];
    dSFamilia = json['DS_Familia'];
    if (json['produtos'] != null) {
      produtos = new List<Products>();
      json['produtos'].forEach((v) {
        produtos.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_Familia'] = this.iDFamilia;
    data['DS_Familia'] = this.dSFamilia;
    if (this.produtos != null) {
      data['produtos'] = this.produtos.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toJson() => json.encode(toMap());
}
