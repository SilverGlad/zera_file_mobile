import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/utils.dart';
import '../../generated/l10n.dart';

class ValidateUpdatePinScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onComplete;
  final String validPin;

  const ValidateUpdatePinScreen(
      {Key key, this.scaffoldKey, this.validPin, this.onComplete})
      : super(key: key);

  @override
  _ValidateUpdatePinScreenState createState() =>
      _ValidateUpdatePinScreenState();
}

class _ValidateUpdatePinScreenState extends State<ValidateUpdatePinScreen> {
  var pinController = new TextEditingController();
  var typedPin = "";
  var invalidPin = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          Column(
            children: [
              Text(
                "Digite o pin",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: fontWeightMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Por motivos de segurança precisamos que você digite o pin que enviamos para o telefone informado.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: TextFormField(
                  controller: pinController,
                  onChanged: (value) async {
                    setState(() {
                      typedPin = value;
                      invalidPin = false;
                    });
                  },
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                  },
                  textInputAction: TextInputAction.done,
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
                    hintText: "000000",
                    errorText:
                        invalidPin ? S.of(context).register_invalidSMS : null,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                height: 36,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.scaffoldKey.currentState.hideCurrentSnackBar();
                    widget.scaffoldKey.currentState.showSnackBar(
                      Utils.provideSnackbar(
                        "Para solicitar a troca do telefone, ligue para o suporte técnico.",
                        duration: Duration(seconds: 10),
                        actions: SnackBarAction(
                          label: "Ligar",
                          textColor: Colors.black,
                          onPressed: () {
                            launch("tel://1932320292");
                          },
                        ),
                      ),
                    );
                  },
                  textColor: colorPrimary,
                  child: Text(
                    S.of(context).register_didntReceive,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      textColor: colorPrimary,
                      child: Text(
                        S.of(context).register_sendAgain,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      width: 110,
                      child: RaisedButton(
                        color: colorAccent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.transparent),
                        ),
                        onPressed: () {
                          if (typedPin == widget.validPin) {
                            widget.onComplete(true);
                          } else {
                            setState(() {
                              invalidPin = true;
                            });
                          }
                        },
                        textColor: Colors.black,
                        child: Text(
                          "Validar",
                          style: TextStyle(
                              fontSize: 14, fontWeight: fontWeightMedium),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
