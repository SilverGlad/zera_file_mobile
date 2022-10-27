import 'dart:convert';

import 'acompanhamentos.dart';

class Products {
  String id;
  String nome;
  String unidadeVenda;
  String preco;
  List<Acompanhamentos> acompanhamentos;
  String urlImagem;
  String detalhes;

  Products(
      {this.id,
      this.nome,
      this.unidadeVenda,
      this.preco,
      this.acompanhamentos,
      this.urlImagem,
      this.detalhes});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    nome = json['Nome'];
    unidadeVenda = json['Unidade_Venda'];
    preco = json['Preco'];
    if (json['Acompanhamentos'] != null) {
      acompanhamentos = new List<Acompanhamentos>();
      json['Acompanhamentos'].forEach((v) {
        acompanhamentos.add(new Acompanhamentos.fromJson(v));
      });
    }
    urlImagem = json['Url_Imagem'];
    detalhes = json['Detalhes'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Nome'] = this.nome;
    data['Unidade_Venda'] = this.unidadeVenda;
    data['Preco'] = this.preco;
    data['Detalhes'] = this.detalhes;
    if (this.acompanhamentos != null) {
      data['Acompanhamentos'] =
          this.acompanhamentos.map((v) => v.toJson()).toList();
    }
    data['Url_Imagem'] = this.urlImagem;
    return data;
  }

  String toJson() => json.encode(toMap());
}
