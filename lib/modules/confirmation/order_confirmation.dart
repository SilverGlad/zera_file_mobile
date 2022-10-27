import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/data/connection/connection.dart';
import '../../core/data/local/shared_preferences.dart';
import '../../core/data/request/base_request.dart';
import '../../core/data/request/rating_request.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/enum.dart';
import '../../core/widgets/dialogs.dart';
import '../../generated/l10n.dart';
import '../home/home.dart';
import '../order_detail/order_detail.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String establishmentName;
  final String orderNumber;
  final String confirmationMessage;
  final OrderType orderType;

  const OrderConfirmationScreen({Key key, this.orderNumber, this.establishmentName, this.orderType, this.confirmationMessage}) : super(key: key);

  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  var _ratingController = new TextEditingController();
  var _ratingTyped = "";
  var _ratingInformed = false;
  var _ratingValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: colorBackground,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: _onBackPressed,
      ),
      brightness: Brightness.light,
      backgroundColor: colorBackground,
      elevation: 0,
      title: Text(
        "",
        style: appBarTextStyle,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 30, left: 16, right: 16),
            width: double.infinity,
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.orderType == OrderType.mobile ? "Pedido confirmado!" : "Pagamento efetuado!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        widget.orderType == OrderType.mobile
                            ? S.of(context).orderConfirmed_message(widget.establishmentName)
                            : S.of(context).orderConfirmed_comandaMessage(widget.establishmentName),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 153,
                          height: 153,
                          child: SvgPicture.asset("assets/icons/ic_order_confirmed.svg"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.orderType == OrderType.mobile ? S.of(context).orderConfirmed_message2 : "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              widget.orderType == OrderType.mobile ? widget.orderNumber : "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Wrap(
            children: [
              widget.confirmationMessage != null && widget.confirmationMessage.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          widget.confirmationMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  S.of(context).orderConfirmed_rating,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: EdgeInsets.all(8),
                child: RatingBar.builder(
                  initialRating: _ratingValue,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: colorPrimary,
                  ),
                  minRating: 1.0,
                  unratedColor: colorPrimary.withAlpha(50),
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  glow: false,
                  onRatingUpdate: (rating) {
                    setState(() {
                      _ratingInformed = true;
                      _ratingValue = rating;
                    });
                  },
                  updateOnDrag: true,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextFormField(
                  controller: _ratingController,
                  onChanged: (value) async {
                    setState(() {
                      _ratingTyped = value;
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
                    hintText: S.of(context).orderConfirmed_obs,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Container(
                height: 42,
                margin: EdgeInsets.all(8),
                width: double.infinity,
                child: RaisedButton(
                  color: colorPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: Colors.transparent),
                  ),
                  onPressed: () {
                    _onBackPressed();
                  },
                  textColor: Colors.white,
                  child: Text(
                    widget.orderType == OrderType.mobile ? S.of(context).orderConfirmed_seeDetails : S.of(context).orderConfirmed_comandaButton,
                    style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _reloadOrder() async {
    DialogsUtil.showLoaderDialog(context, title: S.of(context).dialog_loading);
    try {
      var userId = await SharedPreferencesUtils.getLoggedUserId();
      var orderDetail = await ConnectionUtils.provideHappeningOrdersList(
        BaseRequest(userId: userId, idPedido: widget.orderNumber),
      );

      log(BaseRequest(userId: userId, idPedido: widget.orderNumber).toJson());

      if (orderDetail != null && orderDetail.listaPedidos.isNotEmpty && orderDetail.listaPedidos[0] != null) {
        Navigator.of(context).pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              moveTo: 1,
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              order: orderDetail.listaPedidos[0],
            ),
          ),
        );
      } else {
        Navigator.of(context).pop();
        _onBackPressed();
      }
    } catch (error) {
      Navigator.of(context).pop();
      _onBackPressed();
    }
  }

  _sendRating() async {
    DialogsUtil.showLoaderDialog(context, title: S.of(context).dialog_loading);
    try {
      var userId = await SharedPreferencesUtils.getLoggedUserId();
      var response = await ConnectionUtils.rateApp(
        RatingRequest(id_usu: userId, observacao: _ratingTyped, nr_avaliacao: "${_ratingValue.toInt()}"),
      );
      if (widget.orderType == OrderType.mobile) {
        _reloadOrder();
      } else {
        _returnToHome();
      }
    } catch (error) {
      if (widget.orderType == OrderType.mobile) {
        _reloadOrder();
      } else {
        _returnToHome();
      }
    }
  }

  Future<bool> _onBackPressed() async {
    if (_ratingInformed) {
      _sendRating();
    } else {
      if (widget.orderType == OrderType.mobile) {
        _reloadOrder();
      } else {
        _returnToHome();
      }
    }
  }

  _returnToHome() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          moveTo: widget.orderType == OrderType.comanda ? 0 : 1,
        ),
      ),
    );
    return true;
  }
}
