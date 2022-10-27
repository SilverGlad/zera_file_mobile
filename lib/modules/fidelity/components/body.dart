import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zera_fila/modules/fidelity/components/fidelity_tile.dart';
import 'package:zera_fila/modules/fidelity/fidelity.dart';
import '../../../core/data/model/fidelity_data.dart';
import '../../../core/data/model/user_data.dart';
import '../../../core/data/request/request_sms_update_request.dart';
import '../../../core/utils/utils.dart';
import '../../login/login_after_register.dart';

import '../../../core/data/connection/connection.dart';
import '../../../core/data/local/shared_preferences.dart';
import '../../../core/data/request/get_user_data.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../generated/l10n.dart';
import '../../update/valida_update_pin.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Body({Key key, this.scaffoldKey, this.fidelityList}) : super(key: key);
  final List<Fidelity_data> fidelityList;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var _nameTyped = "";
  var _documentTyped = "";
  var _mailTyped = "";
  var _confirmMailTyped = "";
  var _phoneTyped = "";
  var _passwordTyped = "";
  var _confirmPasswordTyped = "";
  var _passwordVisible = false;
  var _buttonEnabled = false;
  var _invalidPin = false;

  var _validationPin = "";

  var _nameController = new TextEditingController();
  var _documentController = new TextEditingController();
  var _mailController = new TextEditingController();
  var _confirmMailController = new TextEditingController();
  var _phoneController = new TextEditingController();
  var _passwordController = new TextEditingController();
  var _confirmPasswordController = new TextEditingController();
  var _pinController = new TextEditingController();

  var _documentMaskFormatter = new MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  var _phoneMaskFormatter = new MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 88.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorPrimary),
              ),
              child: ListView.builder(
                itemCount: widget.fidelityList.length,
                itemBuilder: (__, index){
                  return FidelityTile(fidelity_data: widget.fidelityList[index]);
                }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 42,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: colorPrimary)),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Voltar",
                  style: TextStyle(
                    color: colorPrimary,
                    fontSize: 14,
                    fontWeight: fontWeightMedium,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _validateFieldAndEnableButton() {
    var mailMatch = _mailTyped.isNotEmpty && _confirmMailTyped.isNotEmpty && _mailTyped == _confirmMailTyped;

    var passwordMatch = _passwordTyped.isNotEmpty && _confirmPasswordTyped.isNotEmpty && _passwordTyped == _confirmPasswordTyped;

    if (_nameTyped.isNotEmpty &&
        _documentTyped.isNotEmpty &&
        _phoneTyped.isNotEmpty &&
        _mailTyped.isNotEmpty &&
        _confirmMailTyped.isNotEmpty &&
        mailMatch &&
        _passwordTyped.isNotEmpty &&
        _confirmPasswordTyped.isNotEmpty &&
        passwordMatch) {
      setState(() {
        _buttonEnabled = true;
      });
    } else {
      setState(() {
        _buttonEnabled = false;
      });
    }
  }

  void _getUserInfo() async {
    DialogsUtil.showLoaderDialog(context);

    try {
      var id = await SharedPreferencesUtils.getLoggedUserId();

      var response = await ConnectionUtils.getUserData(
        UserDataRequest(id: id),
      );

      if (response.isSucessful()) {
        setState(() {
          _nameTyped = response.dadosCadastrais.nome + " " + response.dadosCadastrais.snome;
          _documentTyped = response.dadosCadastrais.cpf;
          _phoneTyped = response.dadosCadastrais.fone;
          _confirmMailTyped = response.dadosCadastrais.email;
          _mailTyped = response.dadosCadastrais.email;
          _passwordTyped = response.dadosCadastrais.senha;
          _confirmPasswordTyped = response.dadosCadastrais.senha;

          _nameController.text = response.dadosCadastrais.nome + " " + response.dadosCadastrais.snome;
          _documentController.text = response.dadosCadastrais.cpf;
          _phoneController.text = response.dadosCadastrais.fone;
          _confirmMailController.text = response.dadosCadastrais.email;
          _mailController.text = response.dadosCadastrais.email;
          _passwordController.text = response.dadosCadastrais.senha;
          _confirmPasswordController.text = response.dadosCadastrais.senha;

          Navigator.pop(context);
          _validateFieldAndEnableButton();
        });
      } else {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(context: context, message: response.mensagem);
      }
    } catch (error) {
      log("$error");
      var reason = "Erro ao receber os dados do seu cadastro.\nVerifique sua conexão e tente novamente.";

      Navigator.pop(context);
      DialogsUtil.showAlertDialog(context: context, message: reason);
    }
  }

  _sendUpdatePin() async {
    if (Utils.validateMailAddresFormat(_mailTyped)) {
      DialogsUtil.showLoaderDialog(context);
      try {
        var response = await ConnectionUtils.sendSmsUpdateAccount(RequestSmsUpdateAccountRequest(
          fone: _phoneTyped.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "").trim(),
        ));

        if (response.isSucessful()) {
          _validationPin = response.validationPin;

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: ValidateUpdatePinScreen(
                scaffoldKey: widget.scaffoldKey,
                validPin: response.validationPin,
                onComplete: (result) {
                  Navigator.pop(context);
                  _updateData();
                },
              ),
            ),
          );
        } else {
          Navigator.pop(context);
          DialogsUtil.showAlertDialog(context: context, message: response.message);
        }
      } catch (_) {
        log("Error");
        var reason = "Erro ao receber o pin de autenticação\nVerifique sua conexão e tente novamente.";

        Navigator.pop(context);
        DialogsUtil.showAlertDialog(context: context, message: reason);
      }
    } else {
      DialogsUtil.showAlertDialog(context: context, message: S.of(context).register_invalidMail);
    }
  }

  _updateData() async {
    DialogsUtil.showLoaderDialog(context);

    try {
      var userID = await SharedPreferencesUtils.getLoggedUserId();

      var response = await ConnectionUtils.updateUser(UserData(
        fullName: _nameTyped,
        phone: _phoneTyped.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "").trim(),
        password: _passwordTyped,
        mailAddress: _mailTyped,
        document: _documentTyped.replaceAll(".", "").replaceAll("-", "").replaceAll(" ", "").trim(),
        id: userID,
      ));

      if (response.isSucessful()) {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
            context: context,
            message: "Cadastro atualizado com sucesso!",
            onPositiveClick: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
      } else {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(
            context: context,
            message: response.message,
            onPositiveClick: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao tentar criar nova conta\nVerifique sua conexão e tente novamente.";

      Navigator.pop(context);
      DialogsUtil.showAlertDialog(context: context, message: reason);
    }
  }
}
