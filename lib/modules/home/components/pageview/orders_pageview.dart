import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/enum.dart';

import '../../../../core/data/connection/connection.dart';
import '../../../../core/data/local/shared_preferences.dart';
import '../../../../core/data/model/order.dart';
import '../../../../core/data/request/base_request.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/network_image_cached.dart';
import '../../../../generated/l10n.dart';
import '../../../order_detail/order_detail.dart';

// ignore: must_be_immutable
class OrdersPageView extends StatefulWidget {
  Function _updateList;
  Function _disposeCounter;

  @override
  _OrdersPageViewState createState() => _OrdersPageViewState();

  void refreshLists() {
    _updateList.call();
  }

  void disposeCounter() {
    _disposeCounter.call();
  }
}

class _OrdersPageViewState extends State<OrdersPageView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isLoadingData = true;
  var _listOfHappeningOrders = List<Order>.empty();
  var _listOfPastOrders = List<Order>.empty();
  var _errorMessage = "";

  Timer _timer;
  int _timerToRefresh = 15;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _setupListeners();

    _loadHappeningOrders();

    super.initState();
  }

  void _setupListeners() {
    widget._updateList = () {
      if (!_isLoadingData) _loadHappeningOrders();
    };

    widget._disposeCounter = () {
      _timer.cancel();
    };
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      color: colorBackground,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 24, bottom: 60),
        scrollDirection: Axis.vertical,
        child: _setupScreen(),
      ),
    );
  }

  Widget _setupScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _circularProgressBar(),
        _header("Em andamento", _listOfHappeningOrders),
        Container(height: 16),
        _happeningOrdersList(),
        Container(height: 24),
        _header("Histórico", _listOfPastOrders),
        Container(height: 16),
        _pastOrdersList(),
        _buildErrorMessage()
      ],
    );
  }

  Widget _circularProgressBar() {
    return _isLoadingData
        ? Align(
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
            ),
          )
        : Container();
  }

  Widget _header(String text, List<Order> detectionList) {
    return !_isLoadingData && detectionList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: fontWeightMedium,
              ),
            ),
          )
        : Container();
  }

  Widget _happeningOrdersList() {
    return !_isLoadingData && _listOfHappeningOrders.isNotEmpty
        ? Container(
            height: 130,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16),
              physics: BouncingScrollPhysics(),
              primary: false,
              itemBuilder: (context, index) => _buildListItem(
                context: context,
                item: _listOfHappeningOrders[index],
                horizontalScroll: true,
                isCurrentList: true,
              ),
              itemCount: _listOfHappeningOrders.length,
              scrollDirection: Axis.horizontal,
            ),
          )
        : Container();
  }

  Widget _pastOrdersList() {
    return !_isLoadingData && _listOfPastOrders.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
            physics: BouncingScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) => _buildListItem(
              context: context,
              item: _listOfPastOrders[index],
              horizontalScroll: false,
              isCurrentList: false,
            ),
            itemCount: _listOfPastOrders.length,
            scrollDirection: Axis.vertical,
          )
        : Container();
  }

  Widget _buildListItem({BuildContext context, Order item, bool horizontalScroll, bool isCurrentList}) {
    var currentStatus = item.cod_Status_Pedido;
    var currentStatusName = currentStatus.getOrderStatus(context);

    if ((currentStatus != OrderStatus.finished.id) || !isCurrentList) {
      var dataHora = item.data_hora;
      var convertedDate = new DateFormat("dd/MM/yyyy HH:mm:ss").parse(dataHora);

      return Container(
        width: horizontalScroll ? MediaQuery.of(context).size.width * 0.9 : double.infinity,
        child: Card(
          margin: EdgeInsets.only(left: 0, right: horizontalScroll ? 12 : 0, top: 8, bottom: 4),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          elevation: 3,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            highlightColor: Colors.white12,
            onTap: () {
              _openOrderDetail(item);
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: NetworkImageCached(
                            imageUrl: item.url_capa_lj,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nm_loja,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: fontWeightMedium,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Pedido:",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      item.nr_pedido,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        width: 100,
                        child: Text(
                          currentStatusName,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Divider(
                      color: Colors.black26,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("dd/MM/yyyy").format(convertedDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          S.of(context).order_time(DateFormat("HH:mm").format(convertedDate)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      S.of(context).order_totalOfItens(item.itens.length != null ? item.itens.length : 0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildErrorMessage() {
    return !_isLoadingData && _listOfHappeningOrders.isEmpty && _listOfPastOrders.isEmpty
        ? Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            child: Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : "Ocorreu um problema desconhecido ao tentar carregar seus pedidos\nVerifique sua conexão e tente novamente.",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          )
        : Container();
  }

  _openOrderDetail(Order item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(
          order: item,
        ),
      ),
    );
  }

  _startTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      setState(() {
        _timerToRefresh = 15;
      });
    }

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timerToRefresh == 0) {
          setState(() {
            _timer.cancel();
            _timerToRefresh = 15;
            _loadHappeningOrders();
          });
        } else {
          setState(() {
            log("$_timerToRefresh");
            _timerToRefresh--;
          });
        }
      },
    );
  }

  _loadHappeningOrders() async {
    try {
      var userId = await SharedPreferencesUtils.getLoggedUserId();

      var happeningOrders = await ConnectionUtils.provideHappeningOrdersList(
        BaseRequest(
          userId: userId,
        ),
      );

      if (happeningOrders.isSucessful()) {
        var _tempHappeningOrders = happeningOrders.listaPedidos;
        var toRemove = [];

        _tempHappeningOrders.forEach((element) {
          if (element.cod_Status_Pedido == OrderStatus.finished.id) {
            toRemove.add(element);
          }
        });

        _tempHappeningOrders.removeWhere((e) => toRemove.contains(e));

        setState(() {
          _errorMessage = "";
          _listOfHappeningOrders = _tempHappeningOrders;
        });
      } else {
        setState(() {
          _errorMessage = happeningOrders.message.isNotEmpty ? happeningOrders.message : "Nenhum pedido encontrado.";
        });
      }
    } catch (error) {}

    _startTimer();

    _loadPastOrders();
  }

  _loadPastOrders() async {
    try {
      var userId = await SharedPreferencesUtils.getLoggedUserId();
      var pastOrders = await ConnectionUtils.providePastOrdersList(
        BaseRequest(
          userId: userId,
        ),
      );

      setState(() {
        if (pastOrders.isSucessful()) {
          _errorMessage = "";
          _listOfPastOrders = pastOrders.listaPedidos;
        } else {
          _errorMessage = pastOrders.message.isNotEmpty ? pastOrders.message : "Nenhum pedido encontrado.";
        }

        _isLoadingData = false;
      });
    } catch (error) {
      log("Error");

      setState(() {
        _isLoadingData = false;
      });
    }
  }
}
