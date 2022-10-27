
class Fidelity_data{
  String estabilishment_name;
  List<Fidelity_detail> details;

  Fidelity_data({
    this.estabilishment_name,
    this.details
  });
}

class Fidelity_detail{
  String data_hora;
  String discountValue;
  bool discount;

  Fidelity_detail({
    this.data_hora,
    this.discountValue,
    this.discount
  });
}