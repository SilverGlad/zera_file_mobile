import '../../utils/extensions.dart';

class BaseCardData {
  String cardId = "";
  String ownerUserId = "";
  String number = "";
  String holderName = "";
  String expirationDate = "";
  String securityCode = "";
  String brand = "";
  String validationNumber = "";
  String lastDigits = "";
  String document = "";
  bool saveCard = false;
  bool isPicPay = false;
  bool isPix = false;

  BaseCardData(
      {this.cardId,
      this.ownerUserId,
      this.number,
      this.holderName,
      this.expirationDate,
      this.securityCode,
      this.brand,
      this.validationNumber,
      this.lastDigits,
      this.document,
      this.saveCard,
      this.isPicPay,
      this.isPix});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['user_id'] = this.ownerUserId;
    data['holderName'] = this.holderName;
    data['expirationDate'] = this.expirationDate;
    data['last_digits'] = this.lastDigits;
    data['document'] = this.document;
    data['securityCode'] = this.securityCode;
    return data;
  }

  Map<String, dynamic> toDb() {
    return {
      'card_id': cardId,
      'user_id': ownerUserId,
      'number': number,
      'holder_name': holderName,
      'expiration_date': expirationDate,
      'security_code': securityCode,
      'brand': brand,
      'last_digits': lastDigits,
      'document': document,
      'validation_number': validationNumber,
    };
  }

  BaseCardData.fromDb(Map data) {
    cardId = data['card_id'];
    ownerUserId = data['user_id'];
    number = data['number'];
    holderName = data['holder_name'];
    expirationDate = data['expiration_date'];
    securityCode = data['security_code'];
    brand = data['brand'];
    lastDigits = data['last_digits'];
    document = data['document'];
    validationNumber = data['validation_number'];
    isPicPay = false;
    isPix = false;
  }

  String compileToString(){
    String compiledString;
    compiledString = '$cardId,$ownerUserId,$number,$holderName,$expirationDate,$securityCode,$brand,$lastDigits,$document,$validationNumber,$isPicPay,$isPix';
    return compiledString;
  }
  
  BaseCardData.extractCard(String compiledString){
    cardId = compiledString.split(',')[0];
    ownerUserId = compiledString.split(',')[1];
    number = compiledString.split(',')[2];
    holderName= compiledString.split(',')[3];
    expirationDate = compiledString.split(',')[4];
    securityCode = compiledString.split(',')[5];
    brand = compiledString.split(',')[6];
    lastDigits = compiledString.split(',')[7];
    document = compiledString.split(',')[8];
    validationNumber = compiledString.split(',')[9];
    isPicPay = false;
    isPix = false;
  }

  BaseCardData encryptData(int key) {
    var formattedNumber = number.trim().replaceAll(" ", "");
    var formattedExpitationDate = expirationDate.trim().replaceAll("/", "");
    var formattedDocument = document.trim().replaceAll(".", "").replaceAll("-", "").replaceAll(" ", "");

    var encryptedObject = BaseCardData(
      brand: brand.encryptData(key),
      cardId: cardId,
      expirationDate: formattedExpitationDate.encryptData(key),
      holderName: holderName.encryptData(key),
      number: formattedNumber.encryptData(key),
      saveCard: saveCard,
      lastDigits: lastDigits,
      document: formattedDocument.encryptData(key),
      securityCode: securityCode.encryptData(key),
      validationNumber: validationNumber.encryptData(key),
    );

    return encryptedObject;
  }
}
