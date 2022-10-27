import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zera_fila/core/data/local/db/web_db_card.dart';
import '../../../core/data/local/db/local_db_helper.dart';
import '../../../core/data/local/shared_preferences.dart';
import '../../../core/data/model/base_card_data.dart';
import '../../../core/data/request/creditcard_request.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/enum.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../firebase_options.dart';
import '../../../generated/l10n.dart';

class CardChooserScreen extends StatefulWidget {
  final String currentSelectedCreditCardId;
  final bool enablePicPay;
  final bool enablePix;
  final bool enableSodexo;
  final bool enableAlelo;
  final bool enableVr;
  final Function creditCardSelected;
  final Function createNewCard;

  const CardChooserScreen({
    Key key,
    this.currentSelectedCreditCardId,
    this.creditCardSelected,
    this.createNewCard,
    this.enablePicPay,
    this.enablePix,
    this.enableAlelo,
    this.enableSodexo,
    this.enableVr,
  }) : super(key: key);

  @override
  _CardChooserScreenState createState() => _CardChooserScreenState();
}

class _CardChooserScreenState extends State<CardChooserScreen> {
  var _currentSelectedCard = "";
  var emptyList = false;
  List<BaseCardData> _savedCardList = <BaseCardData>[];

  @override
  void initState() {
    super.initState();
    for(var i = 0; i < WebDBCard.listCards.length; i++){

    }
    _currentSelectedCard = widget.currentSelectedCreditCardId;
    _loadSavedCards();
  }

  @override
  Widget build(BuildContext context) {
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
                          S.of(context).checkout_choosePaymentForm,
                          style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium, color: Colors.black),
                        ),
                      ),
                      _buildUserSavedCardList(context),
                      Divider(),
                      widget.enablePicPay
                          ? _savedCardCell(
                              context,
                              BaseCardData(
                                brand: PICPAY,
                                cardId: "9999",
                                isPicPay: true,
                                isPix: false,
                              ),
                              0)
                          : Container(),
                      widget.enablePix
                          ? _savedCardCell(
                              context,
                              BaseCardData(
                                brand: PIX,
                                cardId: "8888",
                                isPicPay: false,
                                isPix: true,
                              ),
                              1)
                          : Container(),
                      _buildCreateNewCardLayout(context),
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

  Widget _buildUserSavedCardList(BuildContext context) {
    return emptyList
        ? Container(
            height: 40,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              S.of(context).checkout_choosePaymentForm_empty,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(top: 8),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index){
              print('index: $index');
              print('Ultimos digitos: ${_savedCardList[index].cardId}');
              return _savedCardCell(context, _savedCardList[index], index);
            },
            itemCount: _savedCardList.length,
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
          );
  }

  Widget _savedCardCell(BuildContext context, BaseCardData item, int index) {
    var cardItem = "";
    switch (item.brand) {
      case MASTER:
        cardItem = "assets/icons/ic_card_master.png";
        break;
      case MASTER2:
        cardItem = "assets/icons/ic_card_master.png";
        break;
      case VISA:
        cardItem = "assets/icons/ic_card_visa.png";
        break;
      case ELO:
        cardItem = "assets/icons/ic_card_elo.png";
        break;
      case HIPER:
        cardItem = "assets/icons/ic_card_hiper.png";
        break;
      case AMEX:
        cardItem = "assets/icons/ic_card_amex.png";
        break;
      case PICPAY:
        cardItem = "assets/icons/ic_card_picpay.png";
        break;
      case PIX:
        cardItem = "assets/icons/ic_card_pix.png";
        break;
      default:
        cardItem = "assets/icons/ic_card_empty.png";
        break;
    }

    var elegibleToUse = true;

    if ((item.brand.toLowerCase() == SODEXO_ALI.toLowerCase() || item.brand.toLowerCase() == SODEXO_REF.toLowerCase()) && !widget.enableSodexo)
      elegibleToUse = false;
    if ((item.brand.toLowerCase() == ALELO_ALI.toLowerCase() || item.brand.toLowerCase() == ALELO_REF.toLowerCase()) && !widget.enableAlelo)
      elegibleToUse = false;
    if ((item.brand.toLowerCase() == VR_ALI.toLowerCase() || item.brand.toLowerCase() == VR_REF.toLowerCase()) && !widget.enableVr) elegibleToUse = false;

    return Material(
      child: Row(
        children: [
          Expanded(
            child: Opacity(
              opacity: elegibleToUse ? 1 : 0.45,
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(item.cardId == _currentSelectedCard ? 0.16 : 0.08),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                  border: Border.all(
                    color: item.cardId == _currentSelectedCard ? colorPrimary : Colors.transparent,
                    width: 1,
                  ),
                ),
                margin: EdgeInsets.only(bottom: 4),
                child: InkWell(
                  highlightColor: Colors.black12,
                  onTap: elegibleToUse
                      ? () {
                          setState(() {
                            _currentSelectedCard = item.cardId;
                          });

                          Timer(Duration(milliseconds: 100), () {
                            widget.creditCardSelected.call(item);
                            Navigator.of(context).pop();
                          });
                        }
                      : null,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12, top: 4, bottom: 4),
                        child: SizedBox(width: 31, child: Image.asset(cardItem)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            item.isPicPay
                                ? "Pagar utilizando PicPay"
                                : item.isPix
                                    ? "Pagar com Pix"
                                    : S.of(context).checkout_choosePaymentForm_text(item.brand, item.lastDigits),
                            style: TextStyle(fontSize: 12, fontWeight: fontWeightMedium, color: Colors.black),
                          ),
                        ),
                      ),
                      !elegibleToUse
                          ? Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Text(
                                "Não aceito",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          !item.isPicPay && !item.isPix
              ? Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      highlightColor: Colors.black12,
                      onTap: () {
                        _deleteCardDialog(item.cardId, index);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _deleteCardDialog(String cardId, int index) async {
    DialogsUtil.showAlertDialog(
        context: context,
        title: S.of(context).checkout_deleteCardDialog_title,
        message: S.of(context).checkout_deleteCardDialog_message,
        positiveButtonText: S.of(context).checkout_deleteCardDialog_button,
        onPositiveClick: () async {
          Navigator.pop(context);
          _deleteCard(cardId, index);
        },
        negativeButtonText: S.of(context).dialog_cancel,
        onNegativeClick: () {
          Navigator.pop(context);
        });
  }

  Widget _buildCreateNewCardLayout(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).checkout_createNewPayment_selectType,
              style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium, color: Colors.black),
            ),
          ),
          Container(
            width: double.infinity,
            height: 36,
            margin: EdgeInsets.only(top: 8),
            child: _buildNewCardButton(
              S.of(context).checkout_createNewPayment_credit,
              () {
                Navigator.of(context).pop();
                widget.createNewCard.call(PaymentType.credito);
              },
            ),
          ),
          widget.enableSodexo
              ? Container(
                  height: 36,
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNewCardButton(
                          S.of(context).checkout_createNewPayment_sodexoRef,
                          () {
                            Navigator.of(context).pop();
                            widget.createNewCard.call(PaymentType.sodexo_ref);
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildNewCardButton(
                          S.of(context).checkout_createNewPayment_sodexoAli,
                          () {
                            Navigator.of(context).pop();
                            widget.createNewCard.call(PaymentType.sodexo_ali);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          widget.enableAlelo
              ? Container(
                  height: 36,
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNewCardButton(
                          S.of(context).checkout_createNewPayment_aleloRef,
                          () {
                            Navigator.of(context).pop();
                            widget.createNewCard.call(PaymentType.alelo_ref);
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildNewCardButton(
                          S.of(context).checkout_createNewPayment_aleloAli,
                          () {
                            Navigator.of(context).pop();
                            widget.createNewCard.call(PaymentType.alelo_ali);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          widget.enableVr
              ? Container(
                  height: 36,
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNewCardButton(
                          S.of(context).checkout_createNewPayment_vrRef,
                          () {
                            Navigator.of(context).pop();
                            widget.createNewCard.call(PaymentType.vr_ref);
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildNewCardButton(
                          S.of(context).checkout_createNewPayment_vrAli,
                          () {
                            Navigator.of(context).pop();
                            widget.createNewCard.call(PaymentType.vr_ali);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget _buildNewCardButton(String title, Function onClick) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
        border: Border.all(
          color: colorAccent,
          width: 1,
        ),
      ),
      margin: EdgeInsets.only(left: 4),
      child: Material(
        child: InkWell(
          highlightColor: Colors.black12,
          onTap: onClick,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: fontWeightMedium, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  _loadSavedCards() async {
    log("loading cards");
    if(DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web){
      log('web');
      await SharedPreferencesUtils.getListCards();
      var listOfCards = listCard;
      setState(() {
        if (listOfCards.isNotEmpty) {
          emptyList = false;
          print('Tem cartão');
          listOfCards.forEach((element) {
            print(BaseCardData.extractCard(element));
            _savedCardList.add(BaseCardData.extractCard(element));
          });
        } else {
          emptyList = true;
        }
      });
    }else {
      log('not web');
      var dbHelper = LocalDBHelper.instance;
      var currentUserId = await SharedPreferencesUtils.getLoggedUserId();
      var listOfCards = await dbHelper.queryAllRows(
          LocalDBHelper.table_creditCards, currentUserId);
      setState(() {
        if (listOfCards.isNotEmpty) {
          emptyList = false;
          listOfCards.forEach((element) {
            _savedCardList.add(BaseCardData.fromDb(element));
          });
        } else {
          emptyList = true;
        }
      });
    }
  }

  _deleteCard(String cardId, int index) async {
    log("loading cards");
    var dbHelper = LocalDBHelper.instance;
    await dbHelper.deleteCreditCard(cardId);
    setState(() {
      _savedCardList.removeAt(index);
      emptyList = _savedCardList.isEmpty;
    });
  }
}
