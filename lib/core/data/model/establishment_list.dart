import 'establishment.dart';

class EstablishmentListResponse {
  bool erro = false;
  String mensagem = "";
  String encontrados;
  List<Establishment> restaurantes;

  EstablishmentListResponse({this.erro, this.mensagem, this.encontrados, this.restaurantes});

  EstablishmentListResponse.fromJson(Map<String, dynamic> json, {bool unique, String idUnique}) {
    encontrados = json['Encontrados'];
    erro = json["Erro"];
    mensagem = json["Mensagem"];
    if (json['Restaurantes'] != null) {
      restaurantes = new List<Establishment>();
      json['Restaurantes'].forEach((v) {
        if(unique){
          if(v.toString().contains('Id_lj: $idUnique')){
            restaurantes.add(new Establishment.fromJson(v));
          }
        }else {
          restaurantes.add(new Establishment.fromJson(v));
        }
      });
    }
  }
}
