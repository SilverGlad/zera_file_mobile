import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qrscaner/flutter_qrscaner.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../firebase_options.dart';

class OrderTypeScreen extends StatefulWidget {
  final Function startComandaOrder;
  final Function scanError;

  const OrderTypeScreen({Key key, this.startComandaOrder, this.scanError}) : super(key: key);

  @override
  _OrderTypeScreenState createState() => _OrderTypeScreenState();
}

class _OrderTypeScreenState extends State<OrderTypeScreen> with TickerProviderStateMixin {
  var _comandaController = new TextEditingController();
  var _mesaController    = new TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  var _typedMesa = "";
  var _typedComanda = "";


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: bottomSheetMaxSize,
      minChildSize: bottomSheetMaxSize,
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
                          "Adicionar item na comanda",
                          style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium, color: Colors.black),
                        ),
                      ),
                      _buildDetails(context),
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

  Widget _buildDetails(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Escaneie sua comanda e adicione o item desejado. O item será encaminhado diretamente para cozinha.",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Número da mesa:",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6),
              child: TextFormField(
                controller: _mesaController,
                onChanged: (value) async {
                  setState(() {
                    _typedMesa = value;
                  });
                },
                style: TextStyle(fontSize: 14, color: Colors.black),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                maxLength: 6,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  isDense: true,
                  counter: Container(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: colorEditText,
                  hintText: "Digite o número de sua mesa",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ),
            ),
            DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web?
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Número da comanda:",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: TextFormField(
                    controller: _comandaController,
                    onChanged: (value) async {
                      setState(() {
                        _typedComanda = value;
                      });
                    },
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    maxLength: 6,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                      isDense: true,
                      counter: Container(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: colorEditText,
                      hintText: "Digite o número da comanda",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                height: 48,
                margin: EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.black38),
                ),
                child: Material(
                  child: InkWell(
                    highlightColor: Colors.black12,
                    onTap: () async {
                      if(_comandaController.text == ""){
                        DialogsUtil.showAlertDialog(
                          context: context,
                          message: 'É necessário preencher o número da comanda',
                          positiveButtonText: "OK",
                          onDismiss: () {
                            setState(() {

                            });
                          },
                        );
                      }else if(_mesaController.text == ""){
                        DialogsUtil.showAlertDialog(
                          context: context,
                          message: 'É necessário preencher o número da comanda',
                          positiveButtonText: "OK",
                          onDismiss: () {
                            setState(() {

                            });
                          },
                        );
                      }else{
                        widget.startComandaOrder.call(_typedComanda, _typedMesa);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.check_box_outlined),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Confirmar comanda",
                              style: TextStyle(fontSize: 14, color: Colors.black)),
                          )]
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ):
            Wrap(
              children: [
                _buildOpenCamera(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenCamera(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.black38),
      ),
      child: Material(
        child: InkWell(
          highlightColor: Colors.black12,
          onTap: () async {
            if(_mesaController.text == ""){
              DialogsUtil.showAlertDialog(
                context: context,
                message: 'É necessário preencher o número da mesa',
                positiveButtonText: "OK",
                onDismiss: () {
                  setState(() {

                  });
                },
              );
            }else{
              FocusManager.instance.primaryFocus.unfocus();
              _startBarCodeScan();
            }
          },
          child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Transform.rotate(
                  angle: 90 * math.pi / 180,
                  child: Icon(Icons.document_scanner_outlined),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Ler comanda",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _startBarCodeScan() async {
    String barcodeScanRes;
    try {
      FlutterQrscaner.startScan().then((value) {
        setState(() {
          log("Barcode found: $value");
          if (value != "-1" && value.isNotEmpty && value.length <7 && int.parse(value,onError: (e) => null) != null) {
              Timer(Duration(milliseconds: 400), () {
                Navigator.pop(context);
                widget.startComandaOrder.call(value, _typedMesa);
              });
            }else{
            widget.scanError.call();
          }
        });
      });
    } on PlatformException {
      widget.scanError.call();
    }
  }
}
