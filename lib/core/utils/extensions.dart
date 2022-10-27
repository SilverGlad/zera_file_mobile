import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../generated/l10n.dart';

import 'enum.dart';

extension Crypto on String {
  String encryptData(int key) {
    var rawValue = this;
    var keyInString = key.toString();
    var cryptKey = int.parse(keyInString.substring(keyInString.length - 1));

    if (rawValue != null) {
      log("Valores iniciais");
      log(rawValue);
      log("$cryptKey");
      log("==========");

      var valor = cryptKey % 10;

      log("id mod 10 = $valor");
      var result = "";

      log("==== Entrando no for");
      for (var i = 0; i < rawValue.length; i++) {
        log("i = $i | character atual: ${rawValue[i]}");
        var resto = (i + 1) % 10;
        log("resto = i mod 10 = $resto");
        result = result + String.fromCharCode(rawValue[i].codeUnitAt(0) ^ (resto + valor));
      }

      log("result: $result");
      return result;
    } else {
      return "";
    }
  }
}

extension Status on String {
  String getOrderStatus(BuildContext context) {
    var currentStatus = this;
    if (currentStatus.toUpperCase() == OrderStatus.paid.id) {
      return S.of(context).order_status_paid;
    } else if (currentStatus.toUpperCase() == OrderStatus.confirmed.id) {
      return S.of(context).order_status_confirmed;
    } else if (currentStatus.toUpperCase() == OrderStatus.finished.id) {
      return S.of(context).order_status_finished;
    } else {
      return S.of(context).order_status_canceled;
    }
  }
}
