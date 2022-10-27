import 'order.dart';

class OrderResponse {
  String error;
  String message;
  List<Order> listaPedidos;

  OrderResponse({this.error, this.message, this.listaPedidos});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    error = json['Erro'];
    message = json['Resultado'];
    if (json['lista_pedidos'] != null) {
      listaPedidos = <Order>[];
      json['lista_pedidos'].forEach((v) {
        listaPedidos.add(new Order.fromJson(v));
      });
    }
  }

  bool isSucessful() {
    var errorLowerCased = this.error.toLowerCase();
    return errorLowerCased == "false";
  }
}