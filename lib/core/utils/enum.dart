enum PaymentType {
  credito,
  sodexo_ref,
  sodexo_ali,
  alelo_ref,
  alelo_ali,
  vr_ref,
  vr_ali
}

extension PaymentTypeExtension on PaymentType {
  String get validationNumber {
    switch (this) {
      case PaymentType.sodexo_ref:
        return "281";
      case PaymentType.sodexo_ali:
        return "280";
      case PaymentType.alelo_ref:
        return "224";
      case PaymentType.alelo_ali:
        return "225";
      case PaymentType.vr_ref:
        return "209";
      case PaymentType.vr_ali:
        return "207";
      default:
        return null;
    }
  }

  String get brand {
    switch (this) {
      case PaymentType.sodexo_ref:
        return "Sodexo Ref";
      case PaymentType.sodexo_ali:
        return "Sodexo Ali";
      case PaymentType.alelo_ref:
        return "Alelo Ref";
      case PaymentType.alelo_ali:
        return "Alelo Ali";
      case PaymentType.vr_ref:
        return "VR ref";
      case PaymentType.vr_ali:
        return "VR ali";
      default:
        return null;
    }
  }
}

enum OrderStatus {
  paid,
  confirmed,
  finished,
}

extension OrderStatusExtension on OrderStatus {
  String get id {
    switch (this) {
      case OrderStatus.paid:
        return "A";
      case OrderStatus.confirmed:
        return "C";
      case OrderStatus.finished:
        return "F";
      default:
        return null;
    }
  }

  
}

enum HomeTab {
  home,
  orders,
  profile,
}

enum OrderType {
  mobile,
  comanda,
}

