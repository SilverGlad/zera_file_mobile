import 'dart:developer';

import 'package:flutter/material.dart';
import '../../core/data/request/confirm_comanda_request.dart';

import '../../core/data/connection/connection.dart';
import '../../core/data/local/shared_preferences.dart';
import '../../core/data/model/carrinho_item.dart';
import '../../core/data/request/remove_product.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/network_image_cached.dart';
import '../../generated/l10n.dart';

class OrderCartConfirmComandaScreen extends StatefulWidget {
  final List<CarrinhoItens> itemList;
  final String bdPath;
  final String establishmentId;
  final String establishmentName;
  final String establishmentPicture;
  final String comanda;

  const OrderCartConfirmComandaScreen({
    Key key,
    this.itemList,
    this.bdPath,
    this.establishmentId,
    this.establishmentName,
    this.establishmentPicture,
    this.comanda,
  }) : super(key: key);

  @override
  _OrderCartConfirmComandaScreenState createState() => _OrderCartConfirmComandaScreenState();
}

class _OrderCartConfirmComandaScreenState extends State<OrderCartConfirmComandaScreen> with TickerProviderStateMixin {
  var _totalApprovedPrice = 0.0;
  var _totalPendingPrice = 0.0;
  List<CarrinhoItens> _pendingList = [];
  List<CarrinhoItens> _approvedList = [];

  @override
  void initState() {
    _pendingList = widget.itemList.where((element) => element.pendingItem == "1").toList();
    _approvedList = widget.itemList.where((element) => element.pendingItem == "0").toList();
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
    var numberOfItemApproved = _approvedList.length ?? 0;
    var numberOfItemPending = _pendingList.length ?? 0;

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
        S.of(context).carrinho_comanda_title(widget.comanda),
        style: appBarTextStyle,
      ),
      actions: [
        _pendingList.length > 0
            ? IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  DialogsUtil.showAlertDialog(
                      context: context,
                      message: "Apagar todos os itens pendentes?",
                      positiveButtonText: S.of(context).carrinho_clear,
                      onPositiveClick: () {
                        Navigator.pop(context);
                        _removeAllItens();
                      },
                      negativeButtonText: S.of(context).dialog_cancel,
                      onNegativeClick: () {
                        Navigator.pop(context);
                      });
                },
              )
            : SizedBox(width: 40),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(top: 10, bottom: 300),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Itens pendente de confirmação (${_pendingList.length})",
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
            ListView.builder(
              physics: BouncingScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) => _buildItemList(context, _pendingList[index]),
              itemCount: _pendingList.length,
              scrollDirection: Axis.vertical,
            ),
            Padding(
              padding: EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
              child: Divider(
                color: Colors.black38.withAlpha(80),
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Itens consumidos (${_approvedList.length})",
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
            ListView.builder(
              physics: BouncingScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) => _buildConfirmedItemList(context, _approvedList[index]),
              itemCount: _approvedList.length,
              scrollDirection: Axis.vertical,
            ),
          ],
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

  Widget _buildConfirmedItemList(BuildContext context, CarrinhoItens item) {
    var itemPrice = double.parse(item.vlTotal.replaceAll(",", "."));

    var un = item.unidade;
    var isFloatUnit = un.toLowerCase() == "kg";

    var qtd = isFloatUnit ? "${item.qtde} kg" : "${(double.parse(item.qtde.replaceAll(",", ".")).toInt())} un";

    return Card(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$qtd - ${item.ds}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: fontWeightMedium,
                        color: Colors.black,
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "R\$ ${currencyFormatter.format(itemPrice)}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
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
      child: Wrap(
        children: [
          _buildCloseOrderPanel(context),
        ],
      ),
    );
  }

  Widget _buildCloseOrderPanel(BuildContext context) {
    var totalPrice = 0.0;
    var approvedPrice = 0.0;
    var pendingPrice = 0.0;

    _pendingList.forEach((element) {
      var itemPrice = double.parse(element.vlTotal.replaceAll(",", "."));
      pendingPrice += itemPrice;
    });

    _approvedList.forEach((element) {
      var itemPrice = double.parse(element.vlTotal.replaceAll(",", "."));
      approvedPrice += itemPrice;
    });

    totalPrice = approvedPrice + pendingPrice;

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
                    "Total dos itens pendentes:",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text(
                    "R\$ ${currencyFormatter.format(pendingPrice)}",
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
                      "Total dos itens confirmados:",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      "R\$ ${currencyFormatter.format(approvedPrice)}",
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
                      "Total da comanda:",
                      style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: fontWeightMedium),
                    ),
                    Text(
                      "R\$ ${currencyFormatter.format(totalPrice)}",
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
          Container(
            width: double.infinity,
            child: RaisedButton(
              color: colorAccent,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: _pendingList.length > 0
                  ? () {
                      DialogsUtil.showAlertDialog(
                        context: context,
                        title: "Confirmar itens?",
                        message: "Ao confirmar os itens serão enviados para cozinha e não poderão ser cancelados pelo aplicativo",
                        positiveButtonText: "Confirmar",
                        negativeButtonText: "Cancelar",
                        onPositiveClick: () {
                          Navigator.pop(context);
                          _confirmOrder();
                        },
                      );
                    }
                  : null,
              textColor: Colors.black,
              child: Text(
                _pendingList.length > 0 ? "Confirmar itens pendentes" : "Nenhum item pendente",
                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeItem(String itemOrder) async {
    try {
      DialogsUtil.showLoaderDialog(context, title: S.of(context).carrinho_removing);

      var itemToRemove = RemoveProductRequest(nrComanda: widget.comanda, nrOrdem: itemOrder, idLoja: widget.establishmentId);
      var response = await ConnectionUtils.removeProductOnComanda(itemToRemove);

      if (response.isSucessful()) {
        Navigator.pop(context);
        for (var i = 0; i < _pendingList.length; i++) {
          var currentItem = _pendingList[i];
          if (currentItem.ordem == itemOrder) {
            setState(() {
              _pendingList.removeAt(i);
            });
            break;
          }
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
    } catch (error) {
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

  void _removeAllItens() async {
    try {
      DialogsUtil.showLoaderDialog(context, title: S.of(context).carrinho_removing);
      var error = false;
      await Future.forEach(_pendingList, (item) async {
        var itemToRemove = RemoveProductRequest(nrComanda: widget.comanda, nrOrdem: item.ordem, idLoja: widget.establishmentId);
        var response = await ConnectionUtils.removeProductOnComanda(itemToRemove);
        if (!response.isSucessful()) error = true;
      });

      if (!error) {
        setState(() {
          _pendingList.clear();
        });
      }

      Navigator.pop(context);
    } catch (error) {
      log("Error: $error");
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

  void _confirmOrder() async {
    try {
      DialogsUtil.showLoaderDialog(
        context,
        title: "Enviando itens para cozinha",
      );

      var userId = await SharedPreferencesUtils.getLoggedUserId();
      var response =
          await ConnectionUtils.confirmComandaCart(ConfirmComandaRequest(nr_pedido: widget.comanda, id_loja: widget.establishmentId, id_usuario: userId));

      if (response.isSucessful()) {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
            context: context,
            title: "Pedido confirmado!",
            message: "Os itens foram enviados para cozinha e estão em preparação.",
            positiveButtonText: "OK",
            onDismiss: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
      } else {
        var reason = response.message ?? "Tivemos um problema ao confirmar os itens. Tente novamente ou chame a um garçom para te ajudar.";
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: reason,
          positiveButtonText: "OK",
        );
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao confirmar pedido, tente novamente.";
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
}
