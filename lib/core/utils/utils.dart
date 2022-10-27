import 'package:flutter/material.dart';

import 'colors.dart';

class Utils {
  static bool validateMailAddresFormat(String mailAddress) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mailAddress);
  }

  static SnackBar provideSnackbar(
    String content, {
    Duration duration,
    SnackBarAction actions,
  }) {
    return SnackBar(
      elevation: 6.0,
      duration: duration != null ? duration : Duration(seconds: 5),
      backgroundColor: colorAccent,
      behavior: SnackBarBehavior.floating,
      content: Text(
        content,
        style: TextStyle(color: Colors.black),
      ),
      action: actions,
    );
  }
}
