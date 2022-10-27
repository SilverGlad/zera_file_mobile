import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/connection/connection.dart';
import '../../core/data/local/db/local_db_helper.dart';
import '../../core/data/local/shared_preferences.dart';
import '../../core/data/model/base_card_data.dart';
import '../../core/data/model/carrinho_item.dart';
import '../../core/data/request/check_cupom_request.dart';
import '../../core/data/request/creditcard_request.dart';
import '../../core/data/request/remove_product.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/enum.dart';
import '../../core/utils/extensions.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/network_image_cached.dart';
import '../../generated/l10n.dart';
import '../confirmation/order_confirmation.dart';
import 'components/card_chooser.dart';
import 'components/card_creator.dart';
import 'components/schedule_chooser.dart';

class OrderCartScreen extends StatefulWidget {
  final List<CarrinhoItens> itemList;
  final String bdPath;
  final Function cartUpdated;
  final List<String> scheduleOptions;
  final String establishmentId;
  final String establishmentName;
  final String establishmentPicture;
  final bool enablePicPay;
  final bool enablePix;
  final bool enableSodexo;
  final bool enableVr;
  final bool enableAlelo;
  final OrderType orderType;
  final String comanda;
  final String orderNumber;

  const OrderCartScreen(
      {Key key,
      this.itemList,
      this.bdPath,
      this.cartUpdated,
      this.scheduleOptions,
      this.establishmentId,
      this.establishmentName,
      this.establishmentPicture,
      this.orderType,
      this.comanda,
      this.orderNumber,
      this.enablePicPay,
      this.enablePix,
      this.enableSodexo,
      this.enableAlelo,
      this.enableVr})
      : super(key: key);

  @override
  _OrderCartScreenState createState() => _OrderCartScreenState();
}

class _OrderCartScreenState extends State<OrderCartScreen> with TickerProviderStateMixin {
  var _totalPrice = 0.0;

  var _couponController = new TextEditingController();
  var _couponTyped = "";
  bool _couponCodeInvalid = true;
  var _couponValue = 0.0;

  var _obsController = new TextEditingController();
  var _closeOrder = false;

  BaseCardData _selectedPaymentMethod;
  var _paymentMethodSelected = false;
  var _paymentMethodValid = true;

  var _hasScheduleAvailable = false;
  var _selectedScheduleOption = "";
  var _withdrawNow = true;

  var _obs = "";

  bool isShowingTransactionDialog = false;
  bool cancelLoop = false;
  String superReferenceId;
  String superReferenceData;
  bool isCancelling = false;
  Timer refreshTimer;

  @override
  void initState() {
    _hasScheduleAvailable = widget.scheduleOptions != null && widget.scheduleOptions.isNotEmpty;
    _checkPreferedCardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    var numberOfItem = widget.itemList.length;
    if (numberOfItem == null) numberOfItem = 0;

    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        S.of(context).carrinho_title,
        style: appBarTextStyle,
      ),
      actions: [
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 16),
          child: Text(
            numberOfItem != 1 ? "$numberOfItem ${S.of(context).carrinho_itens}" : "$numberOfItem ${S.of(context).carrinho_item}",
            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: fontWeightMedium),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.black,
          ),
          onPressed: () {
            DialogsUtil.showAlertDialog(
                context: context,
                message: S.of(context).carrinho_clearDialog,
                positiveButtonText: S.of(context).carrinho_clear,
                onPositiveClick: () {
                  SharedPreferencesUtils.removerOrderHistory();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                negativeButtonText: S.of(context).dialog_cancel,
                onNegativeClick: () {
                  Navigator.pop(context);
                });
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTapDown: (tapDownDetails) {
            if (_closeOrder == true) {
              setState(() {
                _closeOrder = false;
              });
            }
          },
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10, bottom: 300),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => _buildItemList(context, widget.itemList[index]),
            itemCount: widget.itemList.length,
            scrollDirection: Axis.vertical,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomPanel(context),
        ),
      ],
    );
  }

  Widget _buildItemList(BuildContext context, CarrinhoItens item) {
    var itemPrice = double.parse(item.vlTotal.replaceAll(",", "."));
    var qtd = double.parse(item.qtde.replaceAll(",", ".")).toInt();

    return Card(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black12,
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: NetworkImageCached(imageUrl: item.urlImage),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${qtd}x - ${item.ds}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: fontWeightMedium,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        "R\$ ${currencyFormatter.format(itemPrice)}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: fontWeightMedium,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    item.acompanhamento != null && item.acompanhamento.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              "Acompanhamentos: ${item.acompanhamento.replaceAll("|", ", ").substring(0, item.acompanhamento.length)}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : Container(),
                    item.obs != null && item.obs.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              "Obs: ${item.obs}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 60,
                          height: 24,
                          child: InkWell(
                            onTap: () {
                              DialogsUtil.showAlertDialog(
                                  context: context,
                                  message: S.of(context).carrinho_deleteItem_dialogTitle,
                                  positiveButtonText: S.of(context).carrinho_deleteItem_dialogButton,
                                  onPositiveClick: () {
                                    Navigator.pop(context);
                                    _removeItem(item.ordem);
                                  });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                S.of(context).carrinho_deleteItem,
                                style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: fontWeightMedium),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        child: Wrap(
          children: [
            !_closeOrder ? _buildTotalPricePanel(context) : _buildCloseOrderPanel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPricePanel(BuildContext context) {
    _totalPrice = 0.0;
    widget.itemList.forEach((element) {
      var itemPrice = double.parse(element.vlTotal.replaceAll(",", "."));
      _totalPrice += itemPrice;
    });

    return Row(
      children: [
        Column(
          children: [
            Text(
              S.of(context).carrinho_total,
              style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
            ),
            Text(
              "R\$ ${currencyFormatter.format(_totalPrice)}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 24),
            child: RaisedButton(
              color: colorAccent,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                setState(() {
                  _closeOrder = true;
                });
              },
              textColor: Colors.black,
              child: Text(
                S.of(context).carrinho_proceed,
                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseOrderPanel(BuildContext context) {
    var totalPrice = 0.0;
    widget.itemList.forEach((element) {
      var itemPrice = double.parse(element.vlTotal.replaceAll(",", "."));
      totalPrice += itemPrice;
    });

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //total group
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).checkout_order,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text(
                    "R\$ ${currencyFormatter.format(totalPrice)}",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).checkout_discount,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      "R\$ ${currencyFormatter.format(_couponValue)}",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).checkout_total,
                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: fontWeightMedium),
                    ),
                    Text(
                      "R\$ ${currencyFormatter.format(totalPrice - _couponValue)}",
                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: Divider(
              color: Colors.black38,
              height: 1,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: _couponCodeInvalid ? 1.0 : 0.5,
                  child: TextFormField(
                    controller: _couponController,
                    onChanged: (value) async {
                      setState(() {
                        _couponTyped = value;
                      });
                    },
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    keyboardType: TextInputType.text,
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
                      enabled: _couponCodeInvalid,
                      hintText: S.of(context).checkout_coupon,
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                height: 36,
                width: 60,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: _couponTyped.isNotEmpty && _couponCodeInvalid
                      ? () {
                          _checkCupom(_couponTyped);
                        }
                      : null,
                  textColor: colorPrimary,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      S.of(context).checkout_validateCoupon,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: Divider(
              color: Colors.black38,
              height: 1,
            ),
          ),
          Material(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).checkout_withdrawTitle,
                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: fontWeightMedium),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12),
                  height: 36,
                  decoration: BoxDecoration(
                    color: _withdrawNow ? colorPrimary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorPrimary),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    highlightColor: Colors.black12,
                    onTap: () {
                      setState(() {
                        _withdrawNow = true;
                        _selectedScheduleOption = "";
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      alignment: Alignment.center,
                      child: Text(
                        S.of(context).checkout_withdrawNow,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: _withdrawNow ? Colors.white : colorPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: _hasScheduleAvailable ? 1 : 0.5,
                  child: Container(
                    margin: EdgeInsets.only(left: 12),
                    height: 36,
                    width: 100,
                    decoration: BoxDecoration(
                      color: !_withdrawNow ? colorPrimary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorPrimary),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      highlightColor: Colors.black12,
                      onTap: _hasScheduleAvailable
                          ? () {
                              _openScheduleOptionsDialog();
                            }
                          : null,
                      child: Container(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        alignment: Alignment.center,
                        child: Text(
                          _hasScheduleAvailable
                              ? _selectedScheduleOption.isNotEmpty
                                  ? S.of(context).checkout_withdrawScheduleItem(_selectedScheduleOption)
                                  : S.of(context).checkout_withdrawSchedule
                              : S.of(context).checkout_withdrawScheduleNotAllowed,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: _hasScheduleAvailable ? 14 : 10, color: !_withdrawNow ? Colors.white : colorPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Divider(
              color: Colors.black38,
              height: 1,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _paymentMethodSelected
                    ? _savedCardCell(context)
                    : Container(
                        height: 36,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).checkout_paymentTitle,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: fontWeightMedium),
                        ),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4),
                height: 36,
                width: 90,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _selectCard();
                  },
                  textColor: colorPrimary,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      !_paymentMethodValid ? "Trocar".toUpperCase() : S.of(context).checkout_paymentMethodChange.toUpperCase(),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Divider(
              color: Colors.black38,
              height: 1,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _obsController,
                  onChanged: (value) async {
                    setState(() {
                      _obs = value;
                    });
                  },
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.text,
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
                    hintText: S.of(context).checkout_obs,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: Divider(
              color: Colors.black38,
              height: 1,
            ),
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
              color: colorAccent,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: _paymentMethodSelected && _paymentMethodValid
                  ? () {
                      DialogsUtil.showConfirmationDialog(
                        context,
                        establishmentName: widget.establishmentName,
                        establishmentPicture: widget.establishmentPicture,
                        cancelClick: () {
                          Navigator.pop(context);
                        },
                        onContinue: () {
                          Navigator.pop(context);
                          if (_selectedPaymentMethod.isPicPay == true) {
                            if (superReferenceId != null && superReferenceId.isNotEmpty) {
                              _checkPicPayTransaction(superReferenceId, superReferenceData);
                            } else {
                              DialogsUtil.showAlertDialog(
                                  context: context,
                                  title: "Pagamento utilizando PicPay",
                                  message:
                                      "Você receberá um e-mail e uma notificação para realizar o pagamento de seu pedido no aplicativo do PicPay. Seu pedido ficará pendente até que o pagamento seja reconhecido pela plataforma.",
                                  positiveButtonText: "Prosseguir",
                                  onPositiveClick: () {
                                    Navigator.pop(context);
                                    _pay();
                                  },
                                  negativeButtonText: S.of(context).checkout_confirmDialog_back,
                                  onNegativeClick: () {
                                    Navigator.pop(context);
                                  });
                            }
                          } else {
                            if (_selectedPaymentMethod.isPix == true && superReferenceId != null && superReferenceId.isNotEmpty) {
                              _checkPixTransaction(superReferenceId, superReferenceData);
                            } else {
                              _pay();
                            }
                          }
                        },
                      );
                    }
                  : null,
              textColor: Colors.black,
              child: Text(
                S.of(context).checkout_pay,
                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openScheduleOptionsDialog() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return ScheduleChooserScreen(
          scheduleSelected: (schedule) {
            setState(() {
              _withdrawNow = false;
              _selectedScheduleOption = schedule;
            });
          },
          currentSelectedSchedule: _selectedScheduleOption,
          availableSchedules: widget.scheduleOptions,
        );
      },
    );
  }

  Widget _savedCardCell(BuildContext context) {
    var cardItem = "";
    switch (_selectedPaymentMethod.brand) {
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

    if ((_selectedPaymentMethod.brand.toLowerCase() == SODEXO_ALI.toLowerCase() || _selectedPaymentMethod.brand.toLowerCase() == SODEXO_REF.toLowerCase()) &&
        !widget.enableSodexo) elegibleToUse = false;
    if ((_selectedPaymentMethod.brand.toLowerCase() == ALELO_ALI.toLowerCase() || _selectedPaymentMethod.brand.toLowerCase() == ALELO_REF.toLowerCase()) &&
        !widget.enableAlelo) elegibleToUse = false;
    if ((_selectedPaymentMethod.brand.toLowerCase() == VR_ALI.toLowerCase() || _selectedPaymentMethod.brand.toLowerCase() == VR_REF.toLowerCase()) &&
        !widget.enableVr) elegibleToUse = false;

    setState(() {
      _paymentMethodValid = elegibleToUse;
    });

    return Material(
      child: Opacity(
        opacity: elegibleToUse ? 1 : 0.45,
        child: Container(
          height: 36,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4, bottom: 4),
                child: SizedBox(width: 31, child: Image.asset(cardItem)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    _selectedPaymentMethod.isPicPay == true
                        ? "Pagar utilizando PicPay"
                        : _selectedPaymentMethod.isPix == true
                            ? "Pagar com Pix"
                            : S.of(context).checkout_choosePaymentForm_text(_selectedPaymentMethod.brand, _selectedPaymentMethod.lastDigits),
                    style: TextStyle(fontSize: 11, fontWeight: fontWeightMedium, color: Colors.black),
                  ),
                ),
              ),
              !elegibleToUse
                  ? Text(
                      "Não aceito",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return CardChooserScreen(
          enablePicPay: widget.enablePicPay,
          enablePix: widget.enablePix,
          enableAlelo: widget.enableAlelo,
          enableSodexo: widget.enableSodexo,
          enableVr: widget.enableVr,
          currentSelectedCreditCardId: _selectedPaymentMethod != null ? _selectedPaymentMethod.cardId : "",
          creditCardSelected: (selectedCard) {
            setState(() {
              _selectedPaymentMethod = selectedCard;
              _paymentMethodSelected = true;
            });
          },
          createNewCard: (cardType) {
            Timer(Duration(milliseconds: 300), () {
              _createNewCard(cardType);
            });
          },
        );
      },
    );
  }

  void _createNewCard(PaymentType cardType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return CardCreatorScreen(
          establishmentId: widget.establishmentId,
          selectedPaymentType: cardType,
          onContinue: (selectedCard) {
            setState(() {
              _selectedPaymentMethod = selectedCard;
              _paymentMethodSelected = true;
            });
          },
        );
      },
    );
  }

  _removeItem(String itemOrder) async {
    var orderNumber = await SharedPreferencesUtils.getOrderNumber();

    var itemToAdd = RemoveProductRequest(nrPedido: orderNumber, path: widget.bdPath, nrOrdem: itemOrder);

    try {
      DialogsUtil.showLoaderDialog(context, title: S.of(context).carrinho_removing);

      var response = await ConnectionUtils.removeProductOnCarrinho(itemToAdd);

      if (response.isSucessful()) {
        var removeItem = await SharedPreferencesUtils.removeOneItemFromOrder();
        widget.cartUpdated.call();

        Navigator.pop(context);
        for (var i = 0; i < widget.itemList.length; i++) {
          var currentItem = widget.itemList[i];
          if (currentItem.ordem == itemOrder) {
            setState(() {
              widget.itemList.removeAt(i);
            });
            break;
          }
        }
        if (widget.itemList.isEmpty) {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: response.message,
          positiveButtonText: "OK",
          onPositiveClick: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao remover item do carrinho.\nVerifique sua conexão e tente novamente.";
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

  void _checkCupom(String cupom) async {
    try {
      DialogsUtil.showLoaderDialog(
        context,
        title: "Validando cupom, aguarde um momento",
      );

      var userId = await SharedPreferencesUtils.getLoggedUserId();

      var response = await ConnectionUtils.checkCupom(
        CheckCupomRequest(
          id_loja: widget.establishmentId,
          id_usu: userId,
          vl_total_comanda: _totalPrice.toString().replaceAll(",", "."),
          txt_cupom_promocional: cupom,
        ),
      );

      if (response.erro.toLowerCase() == "false") {
        setState(() {
          _couponCodeInvalid = false;
          _couponValue = double.parse(response.valor_Desconto_concedido.replaceAll(",", "."));
        });

        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: response.mensagem ?? "Cupom validado com sucesso, seu desconto foi aplicado!",
          positiveButtonText: "Prosseguir",
        );
      } else {
        log("error");
        var reason = response.mensagem ??
            "Não conseguimos validar seu cupom, ele pode estar inválido ou o sistema de validação de cupons está instável, você pode tentar novamente se quiser";

        setState(() {
          _couponCodeInvalid = true;
          _couponValue = 0.0;
        });

        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: reason,
          positiveButtonText: "OK",
        );
      }
    } catch (_) {
      log("Error");
      var reason =
          "Não conseguimos validar seu cupom, ele pode estar inválido ou o sistema de validação de cupons está instável, você pode tentar novamente se quiser";

      setState(() {
        _couponCodeInvalid = true;
        _couponValue = 0.0;
      });

      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
      );
    }
  }

  void _pay() async {
    try {
      DialogsUtil.showLoaderDialog(context, title: S.of(context).checkout_paying_loader);

      await SharedPreferencesUtils.savePreferedCardId(_selectedPaymentMethod.cardId);

      // dado1 = valor
      // dado2 = nr cartao
      // dado3 = data expiracao
      // dado4 = codido de seguranca
      // dado5 = cpf
      // dado6 = tipo do cartao, credito ou voucher.
      // dado7 = id_usuario
      // dado8 = id do pedido
      // dado9 = dd/mm/yyyy MM:HH
      // dado10 = observacao geral
      // dado11 = 0 = imediato, 1 = agendamento
      // dado12 = pathBD
      // dado13 = idloja
      // dado14 = 1 = comanda, 0 = pedido celular
      // dado15 = comanda

      var userId = await SharedPreferencesUtils.getLoggedUserId();
      var userIdInt = int.parse(userId);
      var orderId = await SharedPreferencesUtils.getOrderNumber();

      var totalPriceFormatted = (_totalPrice * 100.0).toInt().toString();

      var now = DateTime.now();
      if (!_withdrawNow) {
        var selectedTimeSplited = _selectedScheduleOption.split(":");
        now = DateTime(
            now.year, now.month, now.day, int.parse(selectedTimeSplited[0]), int.parse(selectedTimeSplited[1]), now.second, now.millisecond, now.microsecond);
      }

      var cardData = CreditCardRequest(
          dado1: totalPriceFormatted.encryptData(userIdInt),
          dado2: _selectedPaymentMethod.number,
          dado3: _selectedPaymentMethod.expirationDate,
          dado4: _selectedPaymentMethod.securityCode,
          dado5: _selectedPaymentMethod.document,
          dado6: _selectedPaymentMethod.validationNumber,
          dado7: userId,
          dado8: orderId.encryptData(userIdInt),
          dado9: DateFormat('dd/MM/yyyy kk:mm').format(now),
          dado10: _obs,
          dado11: (_withdrawNow ? "0" : "1"),
          dado12: widget.bdPath,
          dado13: widget.establishmentId,
          dado14: widget.orderType == OrderType.comanda ? "1" : "0",
          dado15: widget.comanda);

      var response = _selectedPaymentMethod.isPicPay == true
          ? await ConnectionUtils.payWithPicPay(cardData)
          : _selectedPaymentMethod.isPix == true
              ? await ConnectionUtils.payWithPix(cardData)
              : await ConnectionUtils.pay(cardData);

      if (response.erro.toLowerCase() == "false") {
        if (_selectedPaymentMethod.isPicPay == true) {
          Navigator.pop(context);
          superReferenceId = response.picPayIdCode;
          superReferenceData = response.picPayUrl;
          _checkPicPayTransaction(superReferenceId, superReferenceData);
        } else {
          if (_selectedPaymentMethod.isPix == true) {
            Navigator.pop(context);
            superReferenceId = response.pixIdCode;
            superReferenceData = response.pixQrCode;
            _checkPixTransaction(superReferenceId, superReferenceData);
          } else {
            await SharedPreferencesUtils.removerOrderHistory();

            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderConfirmationScreen(
                  orderNumber: orderId != null ? orderId : widget.orderNumber,
                  establishmentName: widget.establishmentName,
                  confirmationMessage: response.mensagem,
                  orderType: widget.orderType,
                ),
              ),
            );
          }
        }
      } else {
        log("error");
        var reason = response.result ??
            response.mensagem ??
            "Tivemos um problema na transação, tente novamente e caso o problema persista, tente trocar o meio de pagamento.";
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
    } catch (exception) {
      log("Error: $exception");
      var reason = "Erro ao Finalizar pedido, tente novamente.";
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

  void _checkPicPayTransaction(String referenceId, String paymentUrl) async {
    if (!isShowingTransactionDialog) {
      setState(() {
        isShowingTransactionDialog = true;
      });

      DialogsUtil.showLoaderDialog(context,
          title: "Aguardando Pagamento...",
          message: "Você receberá uma notificação e um e-mail do picPay para concluir seu pagamento.",
          withButton: true,
          addCountDownTimer: true,
          countDownTimer: Duration(minutes: 5),
          onCoundDownFinished: () {
            setState(() {
              cancelLoop = true;
            });
            Navigator.pop(context);
            DialogsUtil.showAlertDialog(
              context: context,
              title: "Tempo para pagamento expirado",
              message: "O tempo para realizar o pagamento via picPay foi expirado, volte e refaça o processo de pagamento.",
              positiveButtonText: "OK",
              onPositiveClick: () async {
                setState(() {
                  isCancelling = true;
                });
                Navigator.pop(context);
                _cancelPicPayTransaction(referenceId);
              },
            );
          },
          buttonText: "Cancelar",
          buttonAction: () {
            setState(
              () {
                cancelLoop = true;
              },
            );

            DialogsUtil.showAlertDialog(
              context: context,
              title: "Cancelar intenção de compra?",
              message:
                  "Ao continuar você cancelará a intenção de compra com PicPay e poderá escolher outra forma de pagamento, caso o pagamento ja tenha sido efetuado ele será extornado.",
              positiveButtonText: "Cancelar",
              onPositiveClick: () async {
                setState(() {
                  isCancelling = true;
                });
                Navigator.pop(context);
                Navigator.pop(context);
                _cancelPicPayTransaction(referenceId);
              },
              negativeButtonText: "Voltar",
              onDismiss: () {
                setState(() {
                  if (!isCancelling) {
                    cancelLoop = false;
                    _checkPicPayTransaction(referenceId, paymentUrl);
                  }
                });
              },
            );
          },
          negativeText: "Abrir PicPay",
          negativeAction: () async {
            if (await canLaunch(paymentUrl)) {
              await launch(paymentUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Não foi possível abrir o link'),
                duration: Duration(seconds: 10),
              ));
            }
          });
    }

    try {
      var response = await ConnectionUtils.checkPicPayPayment(referenceId);

      if (response.erro.toLowerCase() == "false" || response.paymentStatus == "paid") {
        if (response.paymentStatus != "paid") {
          if (!cancelLoop) {
            refreshTimer = Timer(Duration(milliseconds: 1000), () {
              _checkPicPayTransaction(referenceId, paymentUrl);
            });
          }
        } else {
          Navigator.pop(context);
          DialogsUtil.showAlertDialog(
            context: context,
            message: "Seu pagamento foi reconhecido e seu pedido confirmado!",
            positiveButtonText: "Prosseguir",
            onPositiveClick: () async {
              setState(() {
                isCancelling = false;
                cancelLoop = true;
                isShowingTransactionDialog = false;
                superReferenceId = null;
                superReferenceData = null;
              });

              var orderId = await SharedPreferencesUtils.getOrderNumber();
              await SharedPreferencesUtils.removerOrderHistory();
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderConfirmationScreen(
                    orderNumber: orderId != null ? orderId : widget.orderNumber,
                    establishmentName: widget.establishmentName,
                    confirmationMessage: response.mensagem,
                    orderType: widget.orderType,
                  ),
                ),
              );
            },
          );
        }
      } else {
        log("error");
        var reason = response.result ??
            response.mensagem ??
            "Tivemos um problema durante o processo de pagamento do picPay. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: reason,
          positiveButtonText: "OK",
          onDismiss: () {
            setState(() {
              isCancelling = false;
              cancelLoop = false;
              isShowingTransactionDialog = false;
            });
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason =
          "Tivemos um problema durante o processo de pagamento do picPay. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
        onDismiss: () {
          setState(() {
            isCancelling = false;
            cancelLoop = false;
            isShowingTransactionDialog = false;
          });
        },
      );
    }
  }

  void _cancelPicPayTransaction(String referenceId) async {
    DialogsUtil.showLoaderDialog(
      context,
      title: "Cancelando intenção de compra...",
    );

    try {
      var response = await ConnectionUtils.cancelPicPayPayment(referenceId);

      if (response.erro.toLowerCase() == "false") {
        refreshTimer.cancel();
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
            context: context,
            message: "Intenção de compra com PicPay cancelada, agora você pode escolher outra forma de pagamento.",
            positiveButtonText: "OK",
            onDismiss: () {
              setState(() {
                isCancelling = false;
                cancelLoop = false;
                isShowingTransactionDialog = false;
                superReferenceId = null;
                superReferenceData = null;
              });
            });
      } else {
        log("error");
        var reason = response.result ??
            response.mensagem ??
            "Tivemos um problema durante o processo de pagamento do picPay. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: reason,
          positiveButtonText: "OK",
          onDismiss: () {
            setState(() {
              isCancelling = false;
              cancelLoop = false;
              isShowingTransactionDialog = false;
            });
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason =
          "Tivemos um problema durante o processo de pagamento do picPay. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
        onDismiss: () {
          setState(() {
            isCancelling = false;
            cancelLoop = false;
            isShowingTransactionDialog = false;
          });
        },
      );
    }
  }

  void _checkPixTransaction(String referenceId, String qrCodeData) async {
    if (!isShowingTransactionDialog) {
      setState(() {
        isShowingTransactionDialog = true;
      });

      DialogsUtil.showPixDialog(context, qrCodeData: qrCodeData, onCoundDownFinished: () {
        setState(() {
          cancelLoop = true;
        });
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          title: "Tempo para pagamento expirado",
          message: "O tempo para realizar o pagamento via pix foi expirado, volte e refaça o processo de pagamento.",
          positiveButtonText: "OK",
          onPositiveClick: () async {
            setState(() {
              isCancelling = true;
            });
            Navigator.pop(context);
            _cancelPixTransaction(referenceId);
          },
        );
      }, cancelClick: () {
        setState(() {
          cancelLoop = true;
        });

        DialogsUtil.showAlertDialog(
          context: context,
          title: "Cancelar intenção de compra?",
          message:
              "Ao continuar você cancelará a intenção de compra com pix e poderá escolher outra forma de pagamento, caso o pagamento ja tenha sido efetuado ele será extornado.",
          positiveButtonText: "Cancelar",
          onPositiveClick: () async {
            setState(() {
              isCancelling = true;
            });
            Navigator.pop(context);
            Navigator.pop(context);
            _cancelPixTransaction(referenceId);
          },
          negativeButtonText: "Voltar",
          onDismiss: () {
            setState(() {
              if (!isCancelling) {
                cancelLoop = false;
                _checkPixTransaction(referenceId, qrCodeData);
              }
            });
          },
        );
      }, copyClick: () {
        Clipboard.setData(new ClipboardData(text: qrCodeData)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Código pix copiado!'),
            duration: Duration(seconds: 10),
          ));
        });
      });
    }

    try {
      var response = await ConnectionUtils.checkPixPayment(referenceId);

      if (response.erro.toLowerCase() == "false" || response.paymentStatus == "con") {
        if (response.paymentStatus != "con") {
          if (!cancelLoop) {
            refreshTimer = Timer(Duration(milliseconds: 1000), () {
              _checkPixTransaction(referenceId, qrCodeData);
            });
          }
        } else {
          Navigator.pop(context);
          DialogsUtil.showAlertDialog(
            context: context,
            message: "Seu pagamento foi reconhecido e seu pedido confirmado!",
            positiveButtonText: "Prosseguir",
            onPositiveClick: () async {
              setState(() {
                isCancelling = false;
                cancelLoop = true;
                isShowingTransactionDialog = false;
                superReferenceId = null;
                superReferenceData = null;
              });

              var orderId = await SharedPreferencesUtils.getOrderNumber();
              await SharedPreferencesUtils.removerOrderHistory();
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderConfirmationScreen(
                    orderNumber: orderId != null ? orderId : widget.orderNumber,
                    establishmentName: widget.establishmentName,
                    confirmationMessage: response.mensagem,
                    orderType: widget.orderType,
                  ),
                ),
              );
            },
          );
        }
      } else {
        log("error");
        var reason = response.result ??
            response.mensagem ??
            "Tivemos um problema durante o processo de pagamento do pix. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: reason,
          positiveButtonText: "OK",
          onDismiss: () {
            setState(() {
              isCancelling = false;
              cancelLoop = false;
              isShowingTransactionDialog = false;
            });
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason =
          "Tivemos um problema durante o processo de pagamento do pix. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
        onDismiss: () {
          setState(() {
            isCancelling = false;
            cancelLoop = false;
            isShowingTransactionDialog = false;
          });
        },
      );
    }
  }

  void _cancelPixTransaction(String referenceId) async {
    DialogsUtil.showLoaderDialog(
      context,
      title: "Cancelando intenção de compra...",
    );

    try {
      var response = await ConnectionUtils.cancelPixPayment(referenceId);

      if (response.erro.toLowerCase() == "false") {
        refreshTimer.cancel();
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
            context: context,
            message: "Intenção de compra com Pix cancelada, agora você pode escolher outra forma de pagamento.",
            positiveButtonText: "OK",
            onDismiss: () {
              setState(() {
                isCancelling = false;
                cancelLoop = false;
                isShowingTransactionDialog = false;
                superReferenceId = null;
                superReferenceData = null;
              });
            });
      } else {
        log("error");
        var reason = response.result ??
            response.mensagem ??
            "Tivemos um problema durante o processo de pagamento do pix. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: reason,
          positiveButtonText: "OK",
          onDismiss: () {
            setState(() {
              isCancelling = false;
              cancelLoop = false;
              isShowingTransactionDialog = false;
            });
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason =
          "Tivemos um problema durante o processo de pagamento do pix. Tente novamente ou escolha outra forma de pagamento. Ou entre em contato com o suporte técnico e informe o id de referencia $referenceId";
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(
        context: context,
        message: reason,
        positiveButtonText: "OK",
        onDismiss: () {
          setState(() {
            isCancelling = false;
            cancelLoop = false;
            isShowingTransactionDialog = false;
          });
        },
      );
    }
  }

  void _checkPreferedCardData() async {
    var cardIdSaved = await SharedPreferencesUtils.getPreferedCardId();
    if (cardIdSaved != null && cardIdSaved.isNotEmpty) {
      var dbHelper = LocalDBHelper.instance;
      var currentUserId = await SharedPreferencesUtils.getLoggedUserId();
      var listOfCards = await dbHelper.querySingleCard(LocalDBHelper.table_creditCards, currentUserId, cardIdSaved);
      setState(() {
        if (listOfCards.isNotEmpty) {
          _selectedPaymentMethod = BaseCardData.fromDb(listOfCards[0]);
          _paymentMethodSelected = true;
        }
      });
    }
  }
}
