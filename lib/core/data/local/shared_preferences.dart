import 'package:shared_preferences/shared_preferences.dart';

const SHARED_PREFERENCES_USER_LOGGED = "SHARED_PREFERENCES_USER_LOGGED";
const SHARED_PREFERENCES_USER_ID = "SHARED_PREFERENCES_USER_ID";

const SHARED_PREFERENCES_CURRENT_ORDER_NUMBER =
    "SHARED_PREFERENCES_CURRENT_ORDER_NUMBER";
const SHARED_PREFERENCES_CURRENT_ORDER_ESTABLISHMENT_ID =
    "SHARED_PREFERENCES_CURRENT_ORDER_ESTABLISHMENT_ID";
const SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS =
    "SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS";
const SHARED_PREFERENCES_CURRENT_ORDER_CREATION_TIME =
    "SHARED_PREFERENCES_CURRENT_ORDER_CREATION_TIME";
const SHARED_PREFERENCES_PREFERED_CARD_ID =
    "SHARED_PREFERENCES_PREFERED_CARD_ID";
const SHARED_PREFERENCES_LIST_CARDS =
    "SHARED_PREFERENCES_LIST_CARDS";

List<String> listCard = [];

class SharedPreferencesUtils {

  //login
  static Future<bool> hasUserLogged() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var hasLogin = prefs.getBool(SHARED_PREFERENCES_USER_LOGGED);
    if (hasLogin == null) hasLogin = false;
    return hasLogin;
  }

  static Future<String> getLoggedUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SHARED_PREFERENCES_USER_ID);
  }

  static saveUserLoginStatus(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await removeUserLoginStatus();
    await prefs.setString(SHARED_PREFERENCES_USER_ID, userId);
    await prefs.setBool(SHARED_PREFERENCES_USER_LOGGED, true);
  }

  static removeUserLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SHARED_PREFERENCES_USER_ID);
    await prefs.remove(SHARED_PREFERENCES_USER_LOGGED);
  }

  //order
  static Future<bool> hasOrderCreatedAndValid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var orderNumber = prefs.getString(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER);
    if (orderNumber != null && orderNumber.isNotEmpty) {
      var orderStillValid = await orderIsStillValid();
      if (orderStillValid) {
        return true;
      } else {
        await removerOrderHistory();
        return false;
      }
    } else {
      await removerOrderHistory();
      return false;
    }
  }

  static Future<String> getOrderNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER);
  }

  static Future<int> getOrderCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS);
  }

  static saveOrderNumber(
      String orderNumber, int numberOfItens, String establishmentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await removerOrderHistory();
    await prefs.setString(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER, orderNumber);
    await prefs.setString(
        SHARED_PREFERENCES_CURRENT_ORDER_ESTABLISHMENT_ID, establishmentId);
    await prefs.setInt(
        SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS, numberOfItens);
    await prefs.setInt(SHARED_PREFERENCES_CURRENT_ORDER_CREATION_TIME,
        DateTime.now().microsecondsSinceEpoch);
  }

  static Future<bool> removeOneItemFromOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var count = prefs.getInt(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS);
    var newCount = count - 1;
    await prefs.remove(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS);
    await prefs.setInt(
        SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS, newCount);
    return true;
  }

  static Future<String> getOrderEstablishmentId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(SHARED_PREFERENCES_CURRENT_ORDER_ESTABLISHMENT_ID);
    return id;
  }

  static Future<bool> orderIsStillValid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var creationTimeInMillis =
        prefs.getInt(SHARED_PREFERENCES_CURRENT_ORDER_CREATION_TIME);
    if (creationTimeInMillis != null) {
      var creationDate =
          DateTime.fromMicrosecondsSinceEpoch(creationTimeInMillis);
      var currentDate = DateTime.now();
      var difference = currentDate.difference(creationDate);
      return difference.inHours < 2;
    } else {
      return false;
    }
  }

  static removerOrderHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER);
    await prefs.remove(SHARED_PREFERENCES_CURRENT_ORDER_NUMBER_OF_ITENS);
    await prefs.remove(SHARED_PREFERENCES_CURRENT_ORDER_ESTABLISHMENT_ID);
    await prefs.remove(SHARED_PREFERENCES_CURRENT_ORDER_CREATION_TIME);
  }

  //prefered card
  static Future<String> getPreferedCardId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(SHARED_PREFERENCES_PREFERED_CARD_ID);
    if (id == null || id.isEmpty) {
      removePreferedCardId();
      return null;
    } else
      return id;
  }

  static savePreferedCardId(String cardId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await removePreferedCardId();
    await prefs.setString(SHARED_PREFERENCES_PREFERED_CARD_ID, cardId);
  }

  static removePreferedCardId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SHARED_PREFERENCES_PREFERED_CARD_ID);
  }

  //salvar lista de cartões
  static saveListCards(List<String> cardList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await removeListCards();
    await prefs.setStringList(SHARED_PREFERENCES_USER_ID+SHARED_PREFERENCES_LIST_CARDS, cardList);
  }

  static removeListCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SHARED_PREFERENCES_USER_ID+SHARED_PREFERENCES_LIST_CARDS);
  }

  static getListCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Aquiiiiiiiiiiiiiiii');
    print('ListCard: $listCard');
    if(await prefs.getStringList(SHARED_PREFERENCES_USER_ID+SHARED_PREFERENCES_LIST_CARDS) != null) {
      listCard = await prefs.getStringList(SHARED_PREFERENCES_USER_ID+SHARED_PREFERENCES_LIST_CARDS);
    }
    print('ListCard passou');
    print(listCard);
  }
}
