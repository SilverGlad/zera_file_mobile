import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zera_fila/core/data/local/db/local_db_helper.dart';
import 'package:zera_fila/core/data/model/hist_pgto.dart';
import 'package:zera_fila/modules/fidelity/fidelity.dart';
import '../../../historico_pgto/hist_pgto.dart';
import '../../../../core/data/connection/connection.dart';
import '../../../../core/data/local/shared_preferences.dart';
import '../../../../core/data/request/rating_request.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../generated/l10n.dart';
import '../../../update/update.dart';

import '../../home.dart';

class ProfilePageView extends StatefulWidget {
  @override
  _ProfilePageViewState createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  var talkToUsController = TextEditingController();
  var talkToUsMessage = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 42, right: 42),
      child: ListView(
        padding: EdgeInsets.only(top: 24, bottom: 60),
        children: [
          Visibility(
            visible: true,
            child: RaisedButton(
              color: colorPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(),
                  ),
                );
              },
              textColor: Colors.white,
              child: Text(
                S.of(context).profile_changeData,
                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: RaisedButton(
              color: colorPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {},
              textColor: Colors.white,
              child: Text(
                S.of(context).profile_indicate,
                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
          ),
          RaisedButton(
            color: colorPrimary,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.transparent),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HistoricoPagamento(),
                ),
              );
            },
            textColor: Colors.white,
            child: Text(
              "Comandas pagas",
              style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
            ),
          ),
          RaisedButton(
            color: colorPrimary,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.transparent),
            ),
            onPressed: () {
              LauncherUtils.openTerms();
            },
            onLongPress: () async {
              var userID = await SharedPreferencesUtils.getLoggedUserId();
              await LocalDBHelper.instance.deleteAllPayments(userID);
            },
            textColor: Colors.white,
            child: Text(
              S.of(context).profile_terms,
              style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 16.0),
          //   child: RaisedButton(
          //     color: colorPrimary,
          //     elevation: 2,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //       side: BorderSide(color: Colors.transparent),
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (context) => Fidelity(),
          //         ),
          //       );
          //     },
          //     textColor: Colors.white,
          //     child: Row(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(right: 16.0),
          //           child: Icon(Icons.card_giftcard),
          //         ),
          //         Text(
          //           "Programas de fidelidade",
          //           textAlign: TextAlign.center,
          //           style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Visibility(
            visible: false,
            child: RaisedButton(
              color: colorPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.transparent),
              ),
              onPressed: () {
                DialogsUtil.showAlertDialog(
                    context: context,
                    title: "Recurso em desenvolvimento...",
                    message: "Este recurso ainda está em desenvolvimento, fique de olho nas atualizações do app!",
                    positiveButtonText: "Entendi!",
                    onPositiveClick: () async {
                      Navigator.of(context).pop();
                    });
              },
              textColor: Colors.white,
              child: Text(
                S.of(context).profile_faq,
                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Wrap(
                children: [
                  Text(
                    S.of(context).profile_talkToUs,
                    style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium, color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: TextFormField(
                      controller: talkToUsController,
                      onChanged: (value) async {
                        talkToUsMessage = value;
                      },
                      minLines: 1,
                      maxLines: 6,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).unfocus();
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: colorEditText,
                        hintText: S.of(context).profile_talkToUs_hint,
                        hintStyle: TextStyle(fontSize: 12, color: Colors.black38),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 36,
                      padding: EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          alignment: Alignment.centerRight,
                        ),
                        onPressed: () {
                          _sendRating();
                        },
                        child: Text(
                          S.of(context).profile_talkToUs_button,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: fontWeightMedium,
                            color: colorPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RaisedButton(
            color: colorBackground,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.red),
            ),
            onPressed: () {
              _logout();
            },
            textColor: Colors.red,
            child: Text(
              S.of(context).profile_logout,
              style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
            ),
          ),
        ],
      ),
    );
  }

  _sendRating() async {
    DialogsUtil.showLoaderDialog(context, title: S.of(context).dialog_loading);
    try {
      var userId = await SharedPreferencesUtils.getLoggedUserId();
      var response = await ConnectionUtils.rateApp(
        RatingRequest(id_usu: userId, observacao: talkToUsMessage, nr_avaliacao: "${3}"),
      );
      DialogsUtil.showAlertDialog(
          context: context,
          title: "Enviado!",
          message: "Recebemos sua manifestação. Caso necessário entraremos em contato o mais breve possível.",
          positiveButtonText: "OK!",
          onPositiveClick: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            talkToUsController.clear();
          });
    } catch (error) {
      DialogsUtil.showAlertDialog(
          context: context,
          title: "Problema ao enviar manifestação",
          message: "Tivemos um problema ao receber sua manifestação, tente novamente em alguns instantes.",
          positiveButtonText: "OK!",
          onPositiveClick: () async {
            Navigator.of(context).pop();
          });
    }
  }

  _logout() async {
    DialogsUtil.showAlertDialog(
        context: context,
        title: S.of(context).profile_logoutDialog_title,
        message: S.of(context).profile_logoutDialog_message,
        positiveButtonText: S.of(context).profile_logoutDialog_button,
        negativeButtonText: S.of(context).dialog_cancel,
        onPositiveClick: () async {
          await SharedPreferencesUtils.removeUserLoginStatus();
          await SharedPreferencesUtils.removerOrderHistory();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                moveTo: 0,
              ),
            ),
          );
        });
  }
}
