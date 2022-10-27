import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/data/connection/connection.dart';
import '../../core/data/local/shared_preferences.dart';
import '../../core/data/model/establishment.dart';
import '../../core/data/request/check_comanda_request.dart';
import '../../core/data/request/menu_request.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/enum.dart';
import '../../core/utils/extensions.dart';
import '../../core/widgets/dialogs.dart';
import '../../core/widgets/network_image_cached.dart';
import '../../generated/l10n.dart';
import '../login/login.dart';
import '../menu/menu.dart';
import '../order_cart/order_cart_pay_comanda.dart';
import '../register/register.dart';
import 'components/body.dart';
import 'components/order_type.dart';
import 'components/scan_comanda.dart';

class EstablishmentDetailScreen extends StatefulWidget {
  final Establishment establishment;
  final Function openEnterDialog;

  const EstablishmentDetailScreen({Key key, this.establishment, this.openEnterDialog}) : super(key: key);

  @override
  _EstablishmentDetailScreenState createState() => _EstablishmentDetailScreenState();
}

class _EstablishmentDetailScreenState extends State<EstablishmentDetailScreen> {
  var userLogged = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _checkUserStatus();
    var screenSize = MediaQuery.of(context).size;
    var appBarHeigth = screenSize.height * 0.3;
    if(widget.establishment.idLj != null){
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorBackground,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildAppBar(context, appBarHeigth),
          ];
        },
        body: Body(
          establishment: widget.establishment,
          scaffoldKey: _scaffoldKey,
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }else{
      return Container();
    }
  }

  Widget _buildFAB(BuildContext context) {
    var openStore = widget.establishment.statusLJ == "1";
    return openStore
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.establishment.flGeraPedidoLJ == "1"
                  ? SizedBox(
                      height: 36,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          if (userLogged) {
                            _checkCurrentOrder(context);
                          } else {
                            _openLoginDialog();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        label: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            "Pedido online",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        icon: Icon(
                          Icons.menu_book,
                          size: 16,
                          color: Colors.black,
                        ),
                        backgroundColor: colorAccent,
                      ),
                    )
                  : Container(),
              widget.establishment.FlLancarNaComandaLJ == "1"
                  ? Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        height: 36,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            if (userLogged) {
                              _openOrderTypeBS();
                            } else {
                              _openLoginDialog();
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Text(
                              "Pedido na comanda",
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          icon: Transform.rotate(
                              angle: 90 * math.pi / 180,
                              child: Icon(
                                Icons.document_scanner_outlined,
                                color: Colors.black,
                              )),
                          backgroundColor: colorAccent,
                        ),
                      ),
                    )
                  : Container(),
              widget.establishment.flLerComandaLJ == "1"
                  ? Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        height: 36,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            if (userLogged) {
                              _openReadComandaBS();
                            } else {
                              _openLoginDialog();
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          label: Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Text(
                              "Pagar uma comanda",
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          icon: Transform.rotate(
                              angle: 90 * math.pi / 180,
                              child: Icon(
                                Icons.document_scanner_outlined,
                                color: Colors.black,
                              )),
                          backgroundColor: colorAccent,
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        : FloatingActionButton.extended(
            onPressed: null,
            label: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                S.of(context).detail_establishment_close,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            backgroundColor: colorEditText,
          );
  }

  _openLoginDialog() async {
    DialogsUtil.showAlertDialog(
        context: context,
        message: "Esta funcionalidade é exclusiva para usuários conectados. Volte e conecte-se ou crie uma conta.",
        positiveButtonText: "CRIAR CONTA",
        negativeButtonText: "CONECTAR",
        onPositiveClick: () async {
          setState(() async {
            await Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => RegisterScreen()));
          });
        },
        onNegativeClick: () async {
          Navigator.pop(context);
          _startLoginFlow();
        });
  }

  _startLoginFlow() {
    Future.delayed(Duration.zero, ()
    {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: LoginScreen(
                loginCompleted: () {
                  setState(() {
                    log('Login Completed');
                    _checkUserStatus();
                    (context as Element).reassemble();
                  });
                },
                registerNewAccount: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                  _checkUserStatus();
                },
              ),
            ),
      );
    });
  }


  _openReadComandaBS() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return ScanComandaScreen(
          validateTypedScan: (codeTyped) {
            log("Code typed $codeTyped");

            if (codeTyped != null && codeTyped.isNotEmpty && codeTyped != "-1") {
              _checkComanda(codeTyped.padLeft(6, '0'));
            }
          },
          scanError: () {
            DialogsUtil.showAlertDialog(
                context: context,
                message: "Tivemos um problema com a leitura do código de barras, tente novamente e caso o erro persista tente digita-lo manualmente.",
                positiveButtonText: S.of(context).dialog_ok,
                onPositiveClick: () async {
                  Navigator.pop(context);
                });
          },
        );
      },
    );
  }

  _checkComanda(String comanda) async {
    DialogsUtil.showLoaderDialog(context, title: S
        .of(context)
        .detail_scanBS_loading);

    var comandaFormatted = comanda.padLeft(6, '0');

    try {
      var response = await ConnectionUtils.checkComanda(
        CheckComandaRequest(hostLojaFenix: widget.establishment.HOSTLJ, nrComanda: comandaFormatted),
      );

      if (response.error.toLowerCase() == "false" && response.itens.isNotEmpty) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderCartPayComandaScreen(
                response: response,
                bdPath: widget.establishment.pATHBDLJ,
                establishmentId: widget.establishment.idLj,
                establishmentName: widget.establishment.nmLj,
                enablePicPay: widget.establishment.flPicPayLJ == "1",
                enablePix: widget.establishment.flPixLJ == "1",
                enableSodexo: widget.establishment.FlSodexoLJ == "1",
                enableAlelo: widget.establishment.FlAleloLJ == "1",
                enableVr: widget.establishment.FlVrLJ == "1",
                establishmentPicture: widget.establishment.uRLCAPALJ,
                orderType: OrderType.comanda,
                comanda: comandaFormatted,
                orderNumber: response.nrPedido),
          ),
        );
        Navigator.pop(context);
      } else {
        _showNotFoundDialog(response.message);
      }
    } catch (error) {
      log("Error: $error");
      _showNotFoundDialog(null);
    }
  }

  _showNotFoundDialog(String errorMessage) async {
    Navigator.pop(context);
    DialogsUtil.showAlertDialog(
        context: context,
        message: errorMessage != null ? errorMessage : S.of(context).detail_scanBS_notFound,
        positiveButtonText: S.of(context).dialog_ok,
        onPositiveClick: () async {
          Navigator.pop(context);
        });
  }

  _checkUserStatus() async {
    var logged = await SharedPreferencesUtils.hasUserLogged();
    print(logged);
    if (logged != userLogged) {
      setState(() {
        userLogged = logged;
      });
    }
  }

  _checkCurrentOrder(BuildContext context) async {
    var hasOpenedOrder = await SharedPreferencesUtils.hasOrderCreatedAndValid();
    if (hasOpenedOrder) {
      var currentOrderEstablishmentId = await SharedPreferencesUtils.getOrderEstablishmentId();
      if (widget.establishment.idLj == currentOrderEstablishmentId) {
        _loadMenu(context, null, null, true);
      } else {
        DialogsUtil.showAlertDialog(
            context: context,
            message: S.of(context).detail_orderInAnotherLj_message,
            positiveButtonText: S.of(context).detail_orderInAnotherLj_button,
            onPositiveClick: () async {
              Navigator.pop(context);
              await SharedPreferencesUtils.removerOrderHistory();
              _loadMenu(context, null, null, true);
            },
            negativeButtonText: S.of(context).dialog_cancel,
            onNegativeClick: () {
              Navigator.pop(context);
            });
      }
    } else {
      _loadMenu(context, null, null, true);
    }
  }

  _openOrderTypeBS() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) {
        return OrderTypeScreen(
          startComandaOrder: (comanda, mesa) {
            _loadMenu(context, comanda, mesa, false);
          },
          scanError: () {
            DialogsUtil.showAlertDialog(
                context: context,
                message: "Tivemos um problema com a leitura do código de barras, tente novamente e caso o erro persista realize o pedido com o garçom.",
                positiveButtonText: S.of(context).dialog_ok,
                onPositiveClick: () async {
                  Navigator.pop(context);
                });
          },
        );
      },
    );

    // _loadMenu(context, "2035", "10", false);
  }

  _loadMenu(BuildContext context, String desiredComanda, String desiredMesa, bool onlineOrder) async {
    var pathBd = widget.establishment.pATHBDLJ;

    var ljId = int.parse(widget.establishment.idLj);
    var userId = await SharedPreferencesUtils.getLoggedUserId();

    var result = pathBd.encryptData(ljId);
    DialogsUtil.showLoaderDialog(context);
    try {
      var response = await ConnectionUtils.provideEstablishmentMenu(
        MenuRequest(path: result, id: "0", pegaDadosOnline: onlineOrder ? "1" : "0"),
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(
            establishmentId: widget.establishment.idLj,
            enablePicPay: widget.establishment.flPicPayLJ == "1",
            enablePix: widget.establishment.flPixLJ == "1",
            enableSodexo: widget.establishment.FlSodexoLJ == "1",
            enableAlelo: widget.establishment.FlAleloLJ == "1",
            enableVr: widget.establishment.FlVrLJ == "1",
            menu: response.cardapio,
            establishmentName: widget.establishment.nmLj,
            bdPath: result,
            hostLJ: widget.establishment.HOSTLJ,
            comanda: desiredComanda != null ? desiredComanda.padLeft(6, '0') : null,
            mesa: desiredMesa,
            onlineOrder: onlineOrder,
          ),
        ),
      );
    } catch (_) {
      Navigator.pop(context);
      DialogsUtil.showAlertDialog(context: context, message: S.of(context).detail_error_loading_menu);
    }
      Navigator.pop(context);
  }

  Widget _buildAppBar(BuildContext context, double appBarHeigth) {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      expandedHeight: appBarHeigth,
      backgroundColor: colorPrimary,
      floating: false,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var statusBarHeigth = MediaQuery.of(context).padding.top;
          var currentHeigth = constraints.maxHeight - kToolbarHeight - statusBarHeigth;
          var maxHeigth = appBarHeigth - kToolbarHeight - statusBarHeigth;

          var appBarScrollPercent = 1 - (currentHeigth / maxHeigth);
          if (appBarScrollPercent > 1.0) appBarScrollPercent = 1.0;
          if (appBarScrollPercent < 0.0) appBarScrollPercent = 0.0;

          var appBarPadding = (appBarScrollPercent * 38) + 16;

          return _buildFlexSpaceBar(appBarPadding);
        },
      ),
    );
  }

  Widget _buildFlexSpaceBar(double appBarPadding) {
    return FlexibleSpaceBar(
      centerTitle: false,
      titlePadding: EdgeInsets.only(bottom: 14, left: appBarPadding),
      collapseMode: CollapseMode.parallax,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.establishment.nmLj,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.establishment.dsAtividadeLj,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10.0, fontWeight: fontWeightMedium),
          ),
        ],
      ),
      background: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver),
        child: NetworkImageCached(imageUrl: widget.establishment.uRLCAPALJ),
      ),
    );
  }
}
