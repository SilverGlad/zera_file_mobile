import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core/data/connection/connection.dart';
import '../../core/data/local/shared_preferences.dart';
import '../../core/data/model/menu_response.dart';
import '../../core/data/model/products.dart';
import '../../core/data/request/check_comanda_request.dart';
import '../../core/data/request/save_product.dart';
import '../../core/data/request/schedule_request.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/enum.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/dialogs.dart';
import '../../generated/l10n.dart';
import '../order_cart/order_cart.dart';
import '../order_cart/order_cart_confirm_comanda.dart';
import 'components/tab_body.dart';

class MenuScreen extends StatefulWidget {
  final List<Cardapio> menu;
  final String bdPath;
  final String hostLJ;
  final bool enablePicPay;
  final bool enablePix;
  final bool enableSodexo;
  final bool enableVr;
  final bool enableAlelo;
  final String establishmentId;
  final String establishmentName;
  final String establishmentPicture;
  final String comanda;
  final String mesa;
  final bool onlineOrder;

  const MenuScreen({
    Key key,
    this.menu,
    this.bdPath,
    this.hostLJ,
    this.establishmentId,
    this.establishmentName,
    this.establishmentPicture,
    this.enablePicPay,
    this.enablePix,
    this.enableSodexo,
    this.enableVr,
    this.enableAlelo,
    this.comanda,
    this.mesa,
    this.onlineOrder,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _searchController = new TextEditingController();
  var _typedSearch = "";
  Cardapio produtosGeral = Cardapio(
    iDFamilia: '9999',
    dSFamilia: '9999',
    produtos: []
  );
  var _cartId = "";
  int _cartItensCount = 0;
  bool _hasOrderCreated = false;

  //list of tabs and widgets
  List<Tab> _tabs = List<Tab>();
  List<Widget> _tabScreenList = List<Widget>();

  @override
  void initState() {
    super.initState();
    for(var i = 0; i < widget.menu.length; i ++){
      produtosGeral.produtos.addAll(widget.menu[i].produtos);
    }
    print(produtosGeral.produtos.length);
    _tabs = _provideTabList(widget.menu.length);
    _tabController = _provideTabController();
    if (widget.onlineOrder) {
      Timer(Duration(milliseconds: 600), () {
        _checkOrderCreated();
      });
    }
  }

  //provide tab list
  List<Tab> _provideTabList(int numberOfTabs) {
    _tabs.clear();
    for (int i = 0; i < numberOfTabs; i++) {
      _tabs.add(_generateTab(widget.menu[i].dSFamilia));
    }
    return _tabs;
  }

  //generate new tab formatted and using the list of tab titles
  Tab _generateTab(String title) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Text(title),
      ),
    );
  }

  //provide tab controller
  TabController _provideTabController() {
    return TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      backgroundColor: colorBackground,
      body: _typedSearch.isNotEmpty?
      TabBody(
        menu: produtosGeral,
        bdPath: widget.bdPath,
        establishmentId: widget.establishmentId,
        onlineOrder: widget.onlineOrder,
        comanda: widget.comanda,
        mesa: widget.mesa,
        typedSearch: _typedSearch,
        onProductAdded: () {
          _checkOrderCreated();
          Timer(Duration(milliseconds: 400), () {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              Utils.provideSnackbar(widget.onlineOrder
                  ? "Item adicionado ao carrinho!"
                  : "Item adicionado ao carrinho da comanda! Confirme o item para ser encaminhado para cozinha."),
            );
          });
        },
      ):
        TabBarView(
          controller: _tabController,
          children: _provideTabScreenList(),
        ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildFab() {
    if (widget.onlineOrder) {
      if (_hasOrderCreated && _cartItensCount > 0) {
        return FloatingActionButton.extended(
          onPressed: () {
            _getCompleteListAndGoToCart();
          },
          label: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              S.of(context).checkout_confirmDialog_title,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          backgroundColor: colorAccent,
        );
      } else {
        return null;
      }
    } else {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              height: 36,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _getComandaItens();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                label: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    "Confirmar itens pendentes",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
                backgroundColor: colorAccent,
              ),
            ),
          ),
        ],
      );
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Menu",
            style: appBarTextStyle,
          ),
          widget.onlineOrder != true
              ? Text(
                  "Comanda: ${widget.comanda}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                )
              : SizedBox(),

        ],
      ),
      actions: [
        Stack(
          children: [
            _hasOrderCreated && _cartItensCount > 0
                ? IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _getCompleteListAndGoToCart();
                    },
                  )
                : Container(),
            _hasOrderCreated && _cartItensCount > 0
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(top: 3, right: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _cartItensCount.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Column(
          children: [
            _buildSearchContaier(context),
          _typedSearch.isNotEmpty?
            Container(
              height: 40,
            ):
            SizedBox(
              height: 40,
              child: TabBar(
                labelColor: Colors.black,
                labelPadding: EdgeInsets.only(left: 4, right: 4),
                labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                unselectedLabelColor: Colors.black45,
                unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                indicatorWeight: 3,
                indicatorColor: colorAccent,
                controller: _tabController,
                tabs: _tabs,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _provideTabScreenList() {
    _tabScreenList.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _tabScreenList.add(
        TabBody(
          typedSearch: _typedSearch,
          menu: widget.menu[i],
          bdPath: widget.bdPath,
          establishmentId: widget.establishmentId,
          onlineOrder: widget.onlineOrder,
          comanda: widget.comanda,
          mesa: widget.mesa,
          onProductAdded: () {
            _checkOrderCreated();
            Timer(Duration(milliseconds: 400), () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
              _scaffoldKey.currentState.showSnackBar(
                Utils.provideSnackbar(widget.onlineOrder
                    ? "Item adicionado ao carrinho!"
                    : "Item adicionado ao carrinho da comanda! Confirme o item para ser encaminhado para cozinha."),
              );
            });
          },
        ),
      );
    }
    return _tabScreenList;
  }

  _checkOrderCreated() async {
    var orderCreated = await SharedPreferencesUtils.hasOrderCreatedAndValid();
    setState(() {
      _hasOrderCreated = orderCreated;
    });
    if (orderCreated) {
      var orderNumber = await SharedPreferencesUtils.getOrderNumber();
      var numberOfItens = await SharedPreferencesUtils.getOrderCount();

      setState(() {
        _cartId = orderNumber;
        _cartItensCount = numberOfItens;
      });
    }
  }

  _getComandaItens() async {
    try {
      DialogsUtil.showLoaderDialog(context, title: "Carregando itens da comanda");
      log("teste");
      var response = await ConnectionUtils.checkComanda(CheckComandaRequest(hostLojaFenix: widget.hostLJ, nrComanda: widget.comanda));

      if (response.error.toLowerCase() == "false") {
        _scaffoldKey.currentState.hideCurrentSnackBar();
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderCartConfirmComandaScreen(
              itemList: response.itens,
              bdPath: widget.bdPath,
              establishmentId: widget.establishmentId,
              establishmentName: widget.establishmentName,
              establishmentPicture: widget.establishmentPicture,
              comanda: widget.comanda,
            ),
          ),
        );
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
      var reason = "Erro ao receber itens da comandas.\nVerifique sua conexão e tente novamente.";
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

  _getCompleteListAndGoToCart() async {
    var userId = await SharedPreferencesUtils.getLoggedUserId();
    var hasOrder = await SharedPreferencesUtils.hasOrderCreatedAndValid();
    var orderNumber = "0";
    if (hasOrder) {
      orderNumber = await SharedPreferencesUtils.getOrderNumber();
    }

    log("Acompanhamentos selecionados: ");
    log("Id Produto: ");
    log("Id Usuario: $userId");
    log("Observacao: ");
    log("Numero pedido: $orderNumber");
    log("Path bd: ${widget.bdPath}");
    log("Quantidade: ");
    log("Valor total: ");

    var itemToAdd = SaveProductRequest(
      aCOMPANHAMENTOS: "",
      iDPRODUTO: "",
      iDUSU: userId,
      oBS: "",
      nrPedido: orderNumber,
      path: widget.bdPath,
      qTDE: "1",
      vLPRODUTO: "0,0",
    );

    try {
      DialogsUtil.showLoaderDialog(context, title: S.of(context).menu_loader);

      var response = await ConnectionUtils.saveProductOnCarrinho(itemToAdd);

      if (response.erro.toLowerCase() == "false") {
        var scheduleResponse = await ConnectionUtils.getScheduleOptions(ScheduleRequest(id: widget.establishmentId));
        var scheduleOptions = scheduleResponse.isSucessful() ? scheduleResponse.schedules : null;

        _scaffoldKey.currentState.hideCurrentSnackBar();
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderCartScreen(
              itemList: response.itens,
              bdPath: widget.bdPath,
              enablePicPay: widget.enablePicPay,
              enablePix: widget.enablePix,
              enableAlelo: widget.enableAlelo,
              enableSodexo: widget.enableSodexo,
              enableVr: widget.enableVr,
              scheduleOptions: scheduleOptions,
              establishmentId: widget.establishmentId,
              establishmentName: widget.establishmentName,
              establishmentPicture: widget.establishmentPicture,
              orderType: OrderType.mobile,
              comanda: null,
              cartUpdated: () {
                _checkOrderCreated();
              },
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
          context: context,
          message: response.mensagem,
          positiveButtonText: "OK",
          onPositiveClick: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao atualizar o carrinho.\nVerifique sua conexão e tente novamente.";
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

  Widget _buildSearchContaier(BuildContext context) {
    return Container(
      height: 36,
      width: double.infinity,
      margin: EdgeInsets.only(left: 8, top: 8, right: 8),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _typedSearch = value;
          });
        },
        style: TextStyle(fontSize: 14, color: Colors.black),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
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
          hintText: "Buscar produto",
          hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
          suffixIcon: IconButton(
            icon: Icon(
              _typedSearch.isEmpty ? Icons.search : Icons.highlight_off_rounded,
              color: colorPrimary,
            ),
            onPressed: _typedSearch.isNotEmpty
                ? () {
              setState(() {
                _searchController.text = "";
                _typedSearch = "";
              });
            }
            : null,
          ),
        ),
      ),
    );
  }
}
