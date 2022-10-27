import 'dart:convert';

class SaveProductRequest {
  String path;
  String oBS;
  String iDPRODUTO;
  String qTDE;
  String vLPRODUTO;
  String nrPedido;
  String iDUSU;
  String iDLoja;
  String nrMesa;
  String aCOMPANHAMENTOS;

  SaveProductRequest(
      {this.path, this.oBS, this.iDPRODUTO, this.qTDE, this.vLPRODUTO, this.nrPedido, this.iDUSU, this.iDLoja, this.nrMesa, this.aCOMPANHAMENTOS});

  SaveProductRequest.fromJson(Map<String, dynamic> json) {
    path = json['Path'];
    oBS = json['OBS'];
    iDPRODUTO = json['ID_PRODUTO'];
    qTDE = json['QTDE'];
    vLPRODUTO = json['VL_PRODUTO'];
    nrPedido = json['Nr_Pedido'];
    iDUSU = json['ID_USU'];
    iDLoja = json['id_loja'];
    nrMesa = json['Nr_Mesa'];
    aCOMPANHAMENTOS = json['ACOMPANHAMENTOS'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Path'] = this.path;
    data['OBS'] = this.oBS;
    data['ID_PRODUTO'] = this.iDPRODUTO;
    data['QTDE'] = this.qTDE;
    data['VL_PRODUTO'] = this.vLPRODUTO;
    data['Nr_Pedido'] = this.nrPedido;
    data['ID_USU'] = this.iDUSU;
    data['id_loja'] = this.iDLoja;
    data['Nr_Mesa'] = this.nrMesa;
    data['ACOMPANHAMENTOS'] = this.aCOMPANHAMENTOS;
    return data;
  }

  String toJson() => json.encode(toMap());
}
