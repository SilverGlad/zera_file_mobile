import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zera_fila/core/data/local/db/local_db_helper.dart';
import 'package:zera_fila/core/data/model/hist_pgto.dart';

import '../../../core/data/local/shared_preferences.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../core/widgets/network_image_cached.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Body({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<PaymentHistoric> _paymentList = [];
  var _loading = false;
  var _error = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getPaymentHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text(
            "Os históricos de pagamentos são salvos localmente no dispositivo e utilizados apenas para consulta e comprovação, caso desinstale ou limpe o cache do aplicativo o histórico será apagado.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: colorDefaultText.withOpacity(0.5),
            ),
          ),
        ),
        _loading ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)) : SizedBox(),
        _paymentList.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
                child: Text(
                  _error.isNotEmpty ? _error : "Sem pagamento de comandas\nregistrados neste dispositivo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorDefaultText,
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _listItem(context, _paymentList[index]),
                  itemCount: _paymentList.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
      ],
    );
  }

  Widget _listItem(BuildContext context, PaymentHistoric item) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
        margin: EdgeInsets.only(left: 0, right: 12, top: 8, bottom: 4),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: NetworkImageCached(
                        imageUrl: item.establishmentCapa,
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
                            item.establishmentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: fontWeightMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "COMANDA: ${item.comanda}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: fontWeightMedium,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      item.status.toUpperCase(),
                      style: TextStyle(
                        color: colorConfirmation,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: LinearProgressIndicator(backgroundColor: Colors.black26, valueColor: AlwaysStoppedAnimation<Color>(colorPrimary))),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                primary: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "Pagamento confirmado em:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Text(
                            item.paymentDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: fontWeightMedium,
                            ),
                          ),
                          Text(
                            " às ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item.paymentTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: fontWeightMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "Resumo da comanda:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Container(
                        width: double.infinity,
                        child: _itemsList(item.itens),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Total da comanda:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        "R\$ ${item.total}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: fontWeightMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "Forma de pagamento:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        item.paymentForm,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: fontWeightMedium,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "ID da transação:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        item.transactionID,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: fontWeightMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemsList(List<String> items) {
    if (items != null && items.isNotEmpty) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            items[index],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: fontWeightMedium,
            ),
          ),
        ),
        itemCount: items.length,
        scrollDirection: Axis.vertical,
      );
    } else {
      return Text(
        "Nenhum item encontrado",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
          fontWeight: fontWeightMedium,
        ),
      );
    }
  }

  void _getPaymentHistory() async {
    setState(() {
      _loading = true;
    });

    try {
      var id = await SharedPreferencesUtils.getLoggedUserId();

      var paymentList = await LocalDBHelper.instance.queryAllPayments(id);

      if (paymentList.isNotEmpty) {
        var convertedList = paymentList.map((e) => PaymentHistoric.fromDb(e)).toList();

        setState(() {
          _paymentList = convertedList.reversed.toList();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (error) {
      log("$error");
      setState(() {
        _loading = false;
        _error = "Tivemos um problema ao resgatar os históricos de pagamentos salvos, o arquivo de histórico pode ter sido apagado ou corrompido.";
      });
    }
  }
}
