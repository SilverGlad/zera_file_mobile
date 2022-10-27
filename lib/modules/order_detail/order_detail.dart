import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../core/data/connection/connection.dart';
import '../../core/data/local/shared_preferences.dart';
import '../../core/data/model/order.dart';
import '../../core/data/model/order_item.dart';
import '../../core/data/request/base_request.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/enum.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/launcher_utils.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/network_image_cached.dart';
import '../../generated/l10n.dart';
import '../home/home.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Order order;
  Timer _timer;
  int _timerToRefresh = 15;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    order = widget.order;
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(context),
        backgroundColor: colorBackground,
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: _onBackPressed,
      ),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        S.of(context).orderDetail_title,
        style: appBarTextStyle,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildEstablishmentCard(context),
          _buildStatusCard(context),
          _buildTimeCard(context),
          _buildTotalCard(context),
          _buildLocationCard(context),
          _buildItemCard(context),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildEstablishmentCard(BuildContext context) {
    var dataHora = order.data_hora;
    var convertedDate = new DateFormat("dd/MM/yyyy HH:mm:ss").parse(dataHora);

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 4),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        elevation: 3,
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
                        imageUrl: order.url_capa_lj,
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
                            order.nm_loja,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
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
                                  order.nr_pedido,
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
                  Row(
                    children: [
                      (order.whatsapp_lj != null && order.whatsapp_lj.isNotEmpty)
                          ? Container(
                              height: 40,
                              width: 40,
                              child: InkWell(
                                onTap: () {
                                  LauncherUtils.openWhatsapp(order.whatsapp_lj);
                                },
                                highlightColor: Colors.black12,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SvgPicture.asset("assets/icons/whatsapp.svg"),
                                ),
                              ),
                            )
                          : Container(),
                      (order.fone_lj != null && order.fone_lj.isNotEmpty)
                          ? Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(left: 8),
                              child: InkWell(
                                onTap: () {
                                  LauncherUtils.callTo(order.fone_lj);
                                },
                                highlightColor: Colors.black12,
                                child: Icon(Icons.phone),
                              ),
                            )
                          : Container()
                    ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    var currentStatus = order.cod_Status_Pedido;
    var currentStatusName = currentStatus.getOrderStatus(context);

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 4),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).orderDetail_status,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: fontWeightMedium,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    currentStatusName.toUpperCase(),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: currentStatus != OrderStatus.finished.id
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colorAccent),
                        backgroundColor: colorBackground,
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context) {
    var currentStatus = order.cod_Status_Pedido;

    DateTime tempo_medio;
    try {
      tempo_medio = DateFormat("dd/MM/yyyy HH:mm").parse(widget.order.horario_previsto_entrega);
    } catch (Exception) {
      log("error parsing tempo medio");
      tempo_medio = null;
    }

    var needShowTimeContainer =
        (currentStatus.toUpperCase() != OrderStatus.finished.id && widget.order.horario_previsto_entrega != null && tempo_medio != null);

    if (needShowTimeContainer) {
      var horarioPedido = DateFormat("dd/MM/yyyy HH:mm").parse(widget.order.data_hora);

      var difference = tempo_medio.difference(horarioPedido).inMinutes;
      var differenceString = durationToString(difference);

      return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 0),
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 4),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).orderDetail_time,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: fontWeightMedium,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      differenceString,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}h${parts[1].padLeft(2, '0')}';
  }

  Widget _buildTotalCard(BuildContext context) {
    var orderTotal = double.parse(order.vl_total.replaceAll(",", "."));
    var discontTotal = double.parse(order.vl_desconto.replaceAll(",", "."));
    var additionTotal = double.parse(order.vl_acrescimo.replaceAll(",", "."));

    var finalTotal = orderTotal + discontTotal + additionTotal;

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 4),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).orderDetail_totalOrder,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: fontWeightMedium,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "R\$ ${currencyFormatter.format(orderTotal)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: fontWeightMedium,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).orderDetail_discont,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "R\$ ${currencyFormatter.format(discontTotal)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).orderDetail_addition,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "R\$ ${currencyFormatter.format(additionTotal)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).orderDetail_total,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "R\$ ${currencyFormatter.format(finalTotal)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    var scheduleSelected = widget.order.fl_retirar_pedido ?? "0";

    DateTime scheduleTime;

    try {
      scheduleTime = widget.order.data_hora_retirar_pedido != null && widget.order.data_hora_retirar_pedido.isNotEmpty
          ? DateFormat("dd/MM/yyyy HH:mm").parse(widget.order.data_hora_retirar_pedido)
          : "";
    } catch (Exception) {
      log("Error parsing scheduleTime");
      scheduleTime = null;
    }

    var scheduleText = scheduleSelected == "1" && scheduleTime != null
        ? S.of(context).orderDetail_locationDetailSchedule(DateFormat("HH:mm").format(scheduleTime))
        : S.of(context).orderDetail_locationDetailNow;

    var obsRetirada = order.obs_retirar_pedido;

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 4),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).orderDetail_location,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: fontWeightMedium,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      scheduleText.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              obsRetirada != null && obsRetirada.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        S.of(context).orderDetail_locationDetailObs(obsRetirada),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.order.provideFullAddress(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: 110,
                        height: 36,
                        child: InkWell(
                          highlightColor: Colors.black12,
                          onTap: () {
                            LauncherUtils.openMap(
                              double.parse(widget.order.latitude_loja.replaceAll(",", ".")),
                              double.parse(widget.order.longitude_loja.replaceAll(",", ".")),
                            ).catchError((error) {
                              _scaffoldKey.currentState.hideCurrentSnackBar();
                              _scaffoldKey.currentState.showSnackBar(
                                Utils.provideSnackbar(
                                  "Infelizmente não foi possível abrir as coordenadas do estabelecimento.",
                                  duration: Duration(seconds: 10),
                                ),
                              );
                            });
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              S.of(context).detail_openMap,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: fontWeightMedium,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 0),
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 4),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).orderDetail_item,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: fontWeightMedium,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _buildItemListItem(context, order.itens[index], index == order.itens.length),
                  itemCount: order.itens.length,
                  scrollDirection: Axis.vertical,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemListItem(BuildContext context, OrderItem item, bool isLastItem) {
    var itemPrice = double.parse(item.vlTotal.replaceAll(",", "."));
    var qtd = double.parse(item.qtde.replaceAll(",", "."));

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${item.ds}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                "${qtd.toInt()} un",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Row(
              children: [
                (item.acompanhamento != null && item.acompanhamento.isNotEmpty)
                    ? Text(
                        "${item.acompanhamento}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "R\$ ${currencyFormatter.format(itemPrice)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: (item.obs != null && item.obs.isNotEmpty)
                ? Text(
                    "obs:  ${item.obs}",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  )
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: isLastItem
                ? Divider(
                    color: Colors.black54,
                    height: 1,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timerToRefresh == 0) {
          setState(() {
            _timer.cancel();
            _timerToRefresh = 15;
            _reloadOrder();
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

  _reloadOrder() async {
    try {
      var userId = await SharedPreferencesUtils.getLoggedUserId();
      var happeningOrders = await ConnectionUtils.provideHappeningOrdersList(
        BaseRequest(userId: userId, idPedido: order.nr_pedido),
      );

      setState(() {
        if (happeningOrders.isSucessful()) {
          order = happeningOrders.listaPedidos[0];
        }
      });
    } catch (error) {
      log("Error");
    }

    _startTimer();
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    return true;
  }
}
