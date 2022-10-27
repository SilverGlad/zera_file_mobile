import 'order_item.dart';

class Order {
  String nr_pedido;
  String vl_desconto;
  String vl_acrescimo;
  String vl_total;
  String forma;
  String data_hora;
  String operadora_cartao;
  String NSU_cartao;
  String data_hora_transacao_cartao;
  String cod_loja;
  String nm_loja;
  String Status_Pedido;
  String cod_Status_Pedido;
  String url_capa_lj;
  String fone_lj;
  String whatsapp_lj;
  String fl_retirar_pedido;
  String data_hora_retirar_pedido;
  String obs_retirar_pedido;
  String horario_previsto_entrega;
  String latitude_loja;
  String longitude_loja;
  String endereco_loja;
  String numero_loja;
  String cidade_loja;
  String bairro_loja;
  String uf_loja;
  List<OrderItem> itens;

  Order(
      {this.nr_pedido,
      this.vl_desconto,
      this.vl_acrescimo,
      this.vl_total,
      this.forma,
      this.data_hora,
      this.operadora_cartao,
      this.NSU_cartao,
      this.data_hora_transacao_cartao,
      this.cod_loja,
      this.nm_loja,
      this.cod_Status_Pedido,
      this.url_capa_lj,
      this.fone_lj,
      this.whatsapp_lj,
      this.fl_retirar_pedido,
      this.data_hora_retirar_pedido,
      this.obs_retirar_pedido,
      this.horario_previsto_entrega,
      this.latitude_loja,
      this.longitude_loja,
      this.endereco_loja,
      this.numero_loja,
      this.cidade_loja,
      this.bairro_loja,
      this.uf_loja,
      this.itens});

  Order.fromJson(Map<String, dynamic> json) {
    nr_pedido = json['nr_pedido'];
    vl_desconto = json['vl_desconto'];
    vl_acrescimo = json['vl_acrescimo'];
    vl_total = json['vl_total'];
    forma = json['forma'];
    data_hora = json['data_hora'];
    operadora_cartao = json['operadora_cartao'];
    NSU_cartao = json['NSU_cartao'];
    data_hora_transacao_cartao = json['data_hora_transacao_cartao'];
    cod_loja = json['cod_loja'];
    nm_loja = json['nm_loja'];
    url_capa_lj = json['url_capa_lj'];
    cod_Status_Pedido = json['cod_Status_Pedido'];
    fone_lj = json['fone_lj'];
    fl_retirar_pedido = json['fl_retirar_pedido'];
    data_hora_retirar_pedido = json['data_hora_retirar_pedido'];
    whatsapp_lj = json['whatsapp_lj'];
    horario_previsto_entrega = json['horario_previsto_entrega'];
    obs_retirar_pedido = json['obs_retirar_pedido'];
    latitude_loja = json['latitude_loja'];
    longitude_loja = json['longitude_loja'];
    endereco_loja = json['endereco_loja'];
    numero_loja = json['numero_loja'];
    cidade_loja = json['cidade_loja'];
    bairro_loja = json['bairro_loja'];
    uf_loja = json['uf_loja'];

    if (json['itens'] != null) {
      itens = <OrderItem>[];
      json['itens'].forEach((v) {
        itens.add(new OrderItem.fromJson(v));
      });
    }
  }

  String provideFullAddress() {
    var fullAddress = endereco_loja;
    if (numero_loja.isNotEmpty) fullAddress = fullAddress + ", $numero_loja";
    if (bairro_loja.isNotEmpty) fullAddress = fullAddress + ", $bairro_loja";
    if (cidade_loja.isNotEmpty) fullAddress = fullAddress + " - $cidade_loja";
    if (uf_loja.isNotEmpty) fullAddress = fullAddress + " / $uf_loja";
    return fullAddress;
  }
}
