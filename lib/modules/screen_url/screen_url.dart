import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/data/connection/connection.dart';
import '../../core/data/model/establishment.dart';
import '../../core/data/request/check_comanda_request.dart';
import '../../core/data/request/establishment_request.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/enum.dart';
import '../../core/widgets/dialogs.dart';
import '../../generated/l10n.dart';
import '../establishment_detail/establishment_detail.dart';
import '../home/home.dart';
import '../order_cart/order_cart_pay_comanda.dart';

class ScreenUrl extends StatefulWidget {
  final String uniqueID;
  const ScreenUrl({Key key, this.uniqueID}) : super(key: key);
  @override
  _ScreenUrlState createState() => _ScreenUrlState();
}
Establishment establishment = new Establishment();

class _ScreenUrlState extends State<ScreenUrl> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    _setupScreen();
    _initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplashLayout();
  }

  Widget _buildSplashLayout() {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        color: colorPrimary,
        alignment: Alignment.center,
        child: SizedBox(
          height: 90,
          width: 90,
          child: SvgPicture.asset("assets/icons/ic_logo_accent.svg"),
        ),
      ),
    );
  }

  void _setupScreen() {
    Firebase.initializeApp();
  }

  Future<void> _initAnimation() async {
   await Timer(Duration(seconds: 1), () async {
      await _loadEstabilishment(widget.uniqueID.split('/')[2]);
      if(establishment.idLj != null){
        if(widget.uniqueID.contains('/pay/')){
          print('pay: ${widget.uniqueID.split('/')[4]}');
          print('Home Screen 1');
          Navigator.of(context).popUntil;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()));
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EstablishmentDetailScreen(establishment: establishment)));
          await _checkComanda(widget.uniqueID.split('/')[4], establishment);
        }else {
          print('Home Screen 2');
          Navigator.of(context).popUntil;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()));
          await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EstablishmentDetailScreen(establishment: establishment)));
        }
      }else {
        print('Home Screen 3');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    HomeScreen(moveTo: 0)));
      }
    });
  }

  Future<void> _loadEstabilishment(String uniqueID) async {
    print(uniqueID);
    var response = await ConnectionUtils.provideEstablishemntsList(
      EstablishmentRequest(),
      unique: true,
      idUnique: uniqueID,
    );
    print(response.restaurantes.length);
    if(response.restaurantes.isNotEmpty) {
      establishment = response.restaurantes.first;
    }else{
      establishment = new Establishment();
    }
  }

  _checkComanda(String comanda, Establishment establishment) async {
    DialogsUtil.showLoaderDialog(context, title: S.of(context).detail_scanBS_loading);

    var comandaFormatted = comanda.padLeft(6, '0');

    try {
      var response = await ConnectionUtils.checkComanda(
        CheckComandaRequest(hostLojaFenix: establishment.HOSTLJ, nrComanda: comandaFormatted),
      );

      if (response.error.toLowerCase() == "false" && response.itens.isNotEmpty) {
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrderCartPayComandaScreen(
                response: response,
                bdPath: establishment.pATHBDLJ,
                establishmentId: establishment.idLj,
                establishmentName: establishment.nmLj,
                enablePicPay: establishment.flPicPayLJ == "1",
                enablePix: establishment.flPixLJ == "1",
                enableSodexo: establishment.FlSodexoLJ == "1",
                enableAlelo: establishment.FlAleloLJ == "1",
                enableVr: establishment.FlVrLJ == "1",
                establishmentPicture: establishment.uRLCAPALJ,
                orderType: OrderType.comanda,
                comanda: comandaFormatted,
                orderNumber: response.nrPedido),
          ),
        );
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
}
