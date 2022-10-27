import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:zera_fila/core/data/local/db/web_db_card.dart';
import '../../../core/data/connection/connection.dart';
import '../../../core/data/local/db/local_db_helper.dart';
import '../../../core/data/local/shared_preferences.dart';
import '../../../core/data/model/base_card_data.dart';
import '../../../core/data/request/creditcard_request.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/enum.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../firebase_options.dart';
import '../../../generated/l10n.dart';

class CardCreatorScreen extends StatefulWidget {
  final PaymentType selectedPaymentType;
  final Function onContinue;
  final String establishmentId;

  const CardCreatorScreen({Key key, this.selectedPaymentType, this.onContinue, this.establishmentId}) : super(key: key);

  @override
  _CardCreatorScreenState createState() => _CardCreatorScreenState();
}

class _CardCreatorScreenState extends State<CardCreatorScreen> {
  var _cardNumberController = new TextEditingController();
  var _cardNumberMaskFormatter = new MaskTextInputFormatter(mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

  var _cardValidDueController = new TextEditingController();
  var _cardValidDueMaskFormatter = new MaskTextInputFormatter(mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

  var _documentMaskFormatter = new MaskTextInputFormatter(mask: '###.###.### - ##', filter: {"#": RegExp(r'[0-9]')});

  var _cardDocumentController = new TextEditingController();

  var _cardCodeController = new TextEditingController();

  BaseCardData _cardData = BaseCardData(
    number: "",
    brand: "",
    holderName: "",
    securityCode: "",
    expirationDate: "",
    saveCard: true,
    isPicPay: false,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bottomsheetTitle = "";
    switch (widget.selectedPaymentType) {
      case PaymentType.credito:
        bottomsheetTitle = S.of(context).checkout_createNewPayment_credit;
        break;
      case PaymentType.sodexo_ref:
        bottomsheetTitle = S.of(context).checkout_createNewPayment_sodexoRef;
        break;
      case PaymentType.sodexo_ali:
        bottomsheetTitle = S.of(context).checkout_createNewPayment_sodexoAli;
        break;
      case PaymentType.vr_ref:
        bottomsheetTitle = S.of(context).checkout_createNewPayment_vrRef;
        break;
      case PaymentType.vr_ali:
        bottomsheetTitle = S.of(context).checkout_createNewPayment_vrAli;
        break;
      case PaymentType.alelo_ref:
        bottomsheetTitle = S.of(context).checkout_createNewPayment_aleloRef;
        break;
      case PaymentType.alelo_ali:
        bottomsheetTitle = S.of(context).checkout_createNewPayment_aleloAli;
        break;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: bottomSheetMaxSize,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.horizontal_rule_rounded,
                    color: Colors.black38,
                    size: 40,
                  ),
                  Divider(
                    color: Colors.black38,
                    height: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: MediaQuery.of(context).viewInsets,
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16, bottom: 40, left: 16, right: 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          bottomsheetTitle,
                          style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium, color: Colors.black),
                        ),
                      ),
                      _buildCardDetails(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          _buildCardNumberRow(context),
          _buildCardValidDueAndCodeRow(context),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: TextFormField(
              controller: _cardDocumentController,
              onChanged: (value) async {
                setState(() {
                  _cardData.document = value;
                });
              },
              style: TextStyle(fontSize: 14, color: Colors.black),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [_documentMaskFormatter],
              maxLines: 1,
              maxLength: 16,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                isDense: true,
                counter: Container(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: colorEditText,
                hintText: S.of(context).checkout_newCard_document,
                hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            height: 36,
            child: Material(
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.black54,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  highlightColor: Colors.black12,
                  onTap: () {
                    setState(() {
                      _cardData.saveCard = !_cardData.saveCard;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: colorPrimary,
                        value: _cardData.saveCard,
                        onChanged: (value) {
                          setState(() {
                            _cardData.saveCard = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            S.of(context).checkout_newCard_save,
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 8.0),
            child: RaisedButton(
              color: colorPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                setState(() {
                  _checkCardBrand();
                });
              },
              textColor: Colors.white,
              child: Text(
                S.of(context).checkout_newCard_continue,
                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumberRow(BuildContext context) {
    var icon = "assets/icons/ic_card_empty.png";
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _cardNumberController,
            onChanged: (value) async {
              setState(() {
                _cardData.number = value;
              });
            },
            inputFormatters: [_cardNumberMaskFormatter],
            style: TextStyle(fontSize: 14, color: Colors.black),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            maxLength: 19,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              isDense: true,
              counter: Container(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: colorEditText,
              hintText: S.of(context).checkout_newCard_number,
              hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: SizedBox(width: 40, child: Image.asset(icon)),
        ),
      ],
    );
  }

  Widget _buildCardValidDueAndCodeRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _cardValidDueController,
              onChanged: (value) async {
                setState(() {
                  _cardData.expirationDate = value;
                });
              },
              inputFormatters: [_cardValidDueMaskFormatter],
              style: TextStyle(fontSize: 14, color: Colors.black),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: colorEditText,
                hintText: S.of(context).checkout_newCard_validDue,
                hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
              ),
            ),
          ),
          Container(
            width: 80,
            margin: EdgeInsets.only(left: 12),
            child: TextFormField(
              controller: _cardCodeController,
              onChanged: (value) async {
                setState(() {
                  _cardData.securityCode = value;
                });
              },
              style: TextStyle(fontSize: 14, color: Colors.black),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 4,
              maxLines: 1,
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                fillColor: colorEditText,
                hintText: S.of(context).checkout_newCard_code,
                hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkCardBrand() async {
    var userId = await SharedPreferencesUtils.getLoggedUserId();
    var userIdInt = int.parse(userId);

    _cardData.lastDigits = _cardData.number.substring(_cardData.number.length - 4, _cardData.number.length);

    var encryptedObject = _cardData.encryptData(userIdInt);
    encryptedObject.ownerUserId = userId;

    DialogsUtil.showLoaderDialog(context, title: S.of(context).checkout_newCard_loading_brand);

    try {
      if (widget.selectedPaymentType == PaymentType.credito) {
        //credit card, need to validate number to get brand

        var cardData = CreditCardRequest(dado1: userId, dado2: encryptedObject.number, dado13: widget.establishmentId);
        var response = await ConnectionUtils.checkCreditCardBrand(cardData);

        if (response.erro.toLowerCase() == "false") {
          log("success");
          log("brand: ${response.operadora}");
          log("code: ${response.authCode}");

          encryptedObject.cardId = Uuid().v1();
          encryptedObject.brand = response.operadora;
          encryptedObject.validationNumber = response.authCode.encryptData(userIdInt);

          _saveCardAndReturn(encryptedObject);
        } else {
          log("error");
          var reason = response.result;
          Navigator.pop(context);
          DialogsUtil.showAlertDialog(
            context: context,
            message: reason,
            positiveButtonText: "OK",
            onPositiveClick: () {
              Navigator.pop(context);
            },
          );
        }
      } else {
        //ticket, dont need to call api to validate brand, just continue

        encryptedObject.cardId = Uuid().v1();
        encryptedObject.brand = widget.selectedPaymentType.brand;
        encryptedObject.validationNumber = widget.selectedPaymentType.validationNumber.encryptData(userIdInt);

        _saveCardAndReturn(encryptedObject);
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao validar cartão, tente novamente.";
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
        onPositiveClick: () {
          Navigator.pop(context);
        },
      );
    }
  }

  _saveCardAndReturn(BaseCardData encryptedCardObject) async {
    if (encryptedCardObject.saveCard) {
      if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web){
        log('Cartão: ${encryptedCardObject.compileToString()}');
        SharedPreferencesUtils.getListCards();
        listCard.add(encryptedCardObject.compileToString());
        SharedPreferencesUtils.saveListCards(listCard);
        log('Quantidade de cartões: ${listCard.length}');
      }else {
        var dbHelper = LocalDBHelper.instance;
        await dbHelper.insert(encryptedCardObject.toDb(), LocalDBHelper.table_creditCards);
      }
    }
    Navigator.pop(context);
    Navigator.pop(context);
    widget.onContinue.call(encryptedCardObject);
  }
}
