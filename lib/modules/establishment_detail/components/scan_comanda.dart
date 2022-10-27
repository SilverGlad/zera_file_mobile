import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qrscaner/flutter_qrscaner.dart';
import 'package:zera_fila/firebase_options.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../generated/l10n.dart';

class ScanComandaScreen extends StatefulWidget {
  final Function validateTypedScan;
  final Function scanError;

  const ScanComandaScreen({Key key, this.validateTypedScan, this.scanError}) : super(key: key);

  @override
  _ScanComandaScreenState createState() => _ScanComandaScreenState();
}

class _ScanComandaScreenState extends State<ScanComandaScreen> with TickerProviderStateMixin {
  var _comandaController = new TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
                          "Pagar comanda",
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
          children: [
            Text(DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web?
              'Digite manualmente o código de sua comanda para pagá-la':
              S.of(context).detail_scanBS_message,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web?
            Container():
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: Wrap(
                children: [
                  _buildOpenCamera(context),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).detail_scanBS_typeManually,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _comandaController,
                      onChanged: (value) async {
                        setState(() {
                          _typedComanda = value;
                        });
                      },
                      onFieldSubmitted: (value) {
                        Navigator.pop(context);
                        widget.validateTypedScan.call(_typedComanda);
                      },
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      autofocus: true,
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
                        hintText: "000000",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8, left: 12),
                    child: TextButton(
                      onPressed: _typedComanda.isNotEmpty
                          ? () {
                              Navigator.pop(context);
                              widget.validateTypedScan.call(_typedComanda);
                            }
                          : null,
                      child: Text(
                        S.of(context).detail_scanBS_open,
                        style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium, color: colorPrimary),
                      ),
                    ),
                  ),
                ],
              ),
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
            FocusManager.instance.primaryFocus.unfocus();
            _startBarCodeScan();
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
                    S.of(context).detail_scanBS_readCamera,
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
    try {
      FlutterQrscaner.startScan().then((value) {
        setState(() {
          log("Barcode found: $value");
          Timer(Duration(milliseconds: 400), () {
            Navigator.pop(context);
            widget.validateTypedScan.call(value);
          });
        });
      });
    } on PlatformException {
      widget.scanError.call();
    }
  }
}
