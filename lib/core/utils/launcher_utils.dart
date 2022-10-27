import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  LauncherUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      return Future.error('Could not open the map.');
    }
  }

  static Future<void> openTerms() async {
    String googleUrl = 'http://zerafila.com.br/termo/';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open terms.';
    }
  }

  static Future<void> callTo(String phone) async {
    if (await canLaunch('tel:$phone')) {
      await launch('tel:$phone');
    } else {
      throw 'Could not open the phone.';
    }
  }

  static Future<void> openWhatsapp(String phone) async {
    var whatsappUrl = "whatsapp://send?phone=$phone";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not open whatsapp.';
    }
  }
}
