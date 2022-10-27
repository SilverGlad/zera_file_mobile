import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../core/data/connection/connection.dart';
import '../../../core/data/local/shared_preferences.dart';
import '../../../core/data/model/user_data.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../generated/l10n.dart';
import '../../home/home.dart';
import '../../login/login_after_register.dart';

class Body extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Body({Key key, this.scaffoldKey}) : super(key: key);

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

  final _firebaseMessaging = FirebaseMessaging.instance;
  var _pushToken = "";

  @override
  void initState() {
    super.initState();
    _setupNotification();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 50),
          child: ListView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 40),
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  S.of(context).register_personalData,
                  style: TextStyle(
                    fontWeight: fontWeightMedium,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                height: 42,
                child: TextFormField(
                  controller: _nameController,
                  onChanged: (value) async {
                    _nameTyped = value;
                    _validateFieldAndEnableButton();
                  },
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
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
                    hintText: S.of(context).register_fullName,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                height: 42,
                child: TextFormField(
                  controller: _documentController,
                  onChanged: (value) async {
                    _documentTyped = value;
                    _validateFieldAndEnableButton();
                  },
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.number,
                  inputFormatters: [_documentMaskFormatter],
                  textInputAction: TextInputAction.next,
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
                    hintText: S.of(context).register_document,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  S.of(context).register_contactData,
                  style: TextStyle(
                    fontWeight: fontWeightMedium,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                height: 42,
                child: TextFormField(
                  controller: _phoneController,
                  onChanged: (value) async {
                    _phoneTyped = value;
                    _validateFieldAndEnableButton();
                  },
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.number,
                  inputFormatters: [_phoneMaskFormatter],
                  textInputAction: TextInputAction.next,
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
                    hintText: S.of(context).register_phone,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  S.of(context).register_phoneInfo,
                  style: TextStyle(
                    fontWeight: fontWeightMedium,
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  controller: _mailController,
                  onChanged: (value) async {
                    setState(() {
                      _mailTyped = value;
                      _validateFieldAndEnableButton();
                    });
                  },
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                    errorText: _mailTyped == _confirmMailTyped ? null : S.of(context).register_mailNotEquals,
                    hintText: S.of(context).register_mail,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  controller: _confirmMailController,
                  onChanged: (value) async {
                    setState(() {
                      _confirmMailTyped = value;
                      _validateFieldAndEnableButton();
                    });
                  },
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                    errorText: _mailTyped == _confirmMailTyped ? null : S.of(context).register_mailNotEquals,
                    hintText: S.of(context).register_confirmMail,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(
                  S.of(context).register_loginData,
                  style: TextStyle(
                    fontWeight: fontWeightMedium,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  controller: _passwordController,
                  onChanged: (value) {
                    setState(() {
                      _passwordTyped = value;
                      _validateFieldAndEnableButton();
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
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
                    hintText: S.of(context).register_password,
                    errorText: _passwordTyped == _confirmPasswordTyped ? null : S.of(context).register_passwordsNotEquals,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility_off : Icons.visibility,
                        color: colorPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  onChanged: (value) {
                    setState(() {
                      _confirmPasswordTyped = value;
                      _validateFieldAndEnableButton();
                    });
                  },
                  onEditingComplete: () => node.unfocus(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
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
                    hintText: S.of(context).register_confirmPassword,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                    errorText: _passwordTyped == _confirmPasswordTyped ? null : S.of(context).register_passwordsNotEquals,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility_off : Icons.visibility,
                        color: colorPrimary,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 42,
            width: double.infinity,
            margin: EdgeInsets.all(8),
            child: RaisedButton(
              color: colorPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.transparent)),
              onPressed: !_buttonEnabled
                  ? null
                  : () {
                      _sendRegisterRequest(context);
                    },
              child: Text(
                S.of(context).register_button,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: fontWeightMedium,
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

  void _setupNotification() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _pushToken = token;
      });
    });
  }

  _callLogin() async {
    DialogsUtil.showLoaderDialog(context);

    try {
      var response = await ConnectionUtils.loginUser(
        UserData(mailAddress: _mailTyped, password: _passwordTyped, pin: _validationPin, pushToken: _pushToken),
      );

      if (response.isSucessful()) {
        await SharedPreferencesUtils.saveUserLoginStatus(response.userId);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              moveTo: 0,
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        DialogsUtil.showAlertDialog(context: context, message: response.message);
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao realizar login.\nVerifique sua conexão e tente novamente.";

      Navigator.pop(context);
      DialogsUtil.showAlertDialog(context: context, message: reason);
    }
  }

  _sendRegisterRequest(BuildContext context) async {
    if (Utils.validateMailAddresFormat(_mailTyped)) {
      DialogsUtil.showLoaderDialog(context);
      try {
        var response = await ConnectionUtils.registerNewUser(UserData(
          fullName: _nameTyped,
          phone: _phoneTyped.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "").trim(),
          password: _passwordTyped,
          mailAddress: _mailTyped,
          document: _documentTyped.replaceAll(".", "").replaceAll("-", "").replaceAll(" ", "").trim(),
        ));

        if (response.isSucessful()) {
          _validationPin = response.pin;

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: LoginAfterRegisterScreen(
                scaffoldKey: widget.scaffoldKey,
                validPin: response.pin,
                onComplete: (result) {
                  Navigator.pop(context);
                  _callLogin();
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
        var reason = "Erro ao tentar criar nova conta\nVerifique sua conexão e tente novamente.";

        Navigator.pop(context);
        DialogsUtil.showAlertDialog(context: context, message: reason);
      }
    } else {
      DialogsUtil.showAlertDialog(context: context, message: S.of(context).register_invalidMail);
    }
  }
}
