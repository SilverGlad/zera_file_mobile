import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../core/data/connection/connection.dart';
import '../../core/data/local/shared_preferences.dart';
import '../../core/data/model/user_data.dart';
import '../../core/data/request/password_request.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../generated/l10n.dart';
import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function loginCompleted;
  final Function missingSms;
  final Function registerNewAccount;

  const LoginScreen({Key key, this.scaffoldKey, this.loginCompleted, this.registerNewAccount, this.missingSms}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = new TextEditingController();
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _focusPassword = FocusNode();
  var typedEmail = "";
  var typedPassword = "";
  var typedPin = "";
  var _pushToken = "";
  var _passwordVisible = false;
  var _missingPin = false;

  var _loadingApi = false;
  var _error = "";

  @override
  void initState() {
    super.initState();
    _setupNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          Column(
            children: [
              Text(
                S.of(context).login_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: fontWeightMedium,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                height: 36,
                child: TextFormField(
                  controller: emailController,
                  onChanged: (value) async {
                    setState(() {
                      typedEmail = value;
                    });
                  },
                  readOnly: _loadingApi ? true : false,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).unfocus();
                    FocusScope.of(context).requestFocus(_focusPassword);
                  },
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
                    hintText: S.of(context).login_email,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      margin: EdgeInsets.only(top: 6),
                      child: TextFormField(
                        readOnly: _loadingApi ? true : false,
                        onChanged: (value) {
                          setState(() {
                            typedPassword = value;
                          });
                        },
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).unfocus();
                        },
                        focusNode: _focusPassword,
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
                          hintText: S.of(context).login_password,
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
                  ),
                  Container(
                    width: 70,
                    height: 36,
                    margin: EdgeInsets.only(left: 4),
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: _loadingApi
                          ? null
                          : () {
                              if (typedEmail == null || typedEmail.isEmpty) {
                                setState(() {
                                  _loadingApi = false;
                                  _error = "Você precisa digitar o e-mail cadastrado primeiro";
                                });
                              } else {
                                _sendPasswordByMail();
                              }
                            },
                      textColor: Colors.red,
                      child: Text(
                        S.of(context).login_forgotPassword,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 10, fontWeight: fontWeightMedium),
                      ),
                    ),
                  )
                ],
              ),
              _error.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 2, left: 8), width: double.infinity, child: Text(_error, style: TextStyle(fontSize: 11, color: Colors.red)))
                  : Container(),
              _missingPin
                  ? Container(
                      margin: EdgeInsets.only(top: 16),
                      height: 36,
                      child: TextFormField(
                        onChanged: (value) async {
                          setState(() {
                            typedPin = value;
                          });
                        },
                        readOnly: _loadingApi ? true : false,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        keyboardType: TextInputType.number,
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
                          hintText: S.of(context).login_pin,
                          hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: _loadingApi ? null : widget.registerNewAccount,
                      textColor: colorPrimary,
                      child: Text(
                        S.of(context).login_createAccount,
                        style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
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
                        onPressed: _loadingApi || typedEmail.isEmpty || typedPassword.isEmpty
                            ? null
                            : () {
                                _checkCredentials();
                              },
                        textColor: Colors.black,
                        child: _loadingApi
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                                  backgroundColor: Colors.black12,
                                ),
                              )
                            : Text(
                                S.of(context).login_connect,
                                style: TextStyle(fontSize: 14, fontWeight: fontWeightMedium),
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

  void _setupNotification() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _pushToken = token;
      });
    });
  }

  _sendPasswordByMail() async {
    setState(() {
      _loadingApi = true;
      _error = "";
    });

    try {
      var response = await ConnectionUtils.sendPassword(
        PasswordRequest(email: typedEmail),
      );

      if (response.isSucessful()) {
        setState(() {
          _loadingApi = false;
          _error = "Sua senha foi enviada para o e-mail cadastrado.";
        });
      } else {
        setState(() {
          _loadingApi = false;
          _error = "Tivemos um problema ao localizar sua conta. Verifique o e-mail digitado";
        });
      }
    } catch (_) {
      setState(() {
        _loadingApi = false;
        _error = "Tivemos um problema ao localizar sua conta. Verifique o e-mail digitado";
      });
    }
  }

  _checkCredentials() async {
    setState(() {
      _loadingApi = true;
    });

    try {
      var response = await ConnectionUtils.loginUser(
        UserData(mailAddress: typedEmail, password: typedPassword, pin: typedPin, pushToken: _pushToken),
      );
      if (response.isSucessful()) {
        await SharedPreferencesUtils.saveUserLoginStatus(response.userId);
        widget.loginCompleted();
        Navigator.of(context).pop();
        //Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(
        //       moveTo: 0,
        //     ),
        //   ),
        // );
      } else {
        if (response.missingEnderPin == "1") {
          setState(() {
            _error = "";
            _loadingApi = false;
            _missingPin = true;
          });
        } else {
          setState(() {
            _loadingApi = false;
            _error = response.message;
          });
        }
      }
    } catch (_) {
      log("Error");
      var reason = "Erro ao realizar login.\nVerifique sua conexão e tente novamente.";

      setState(() {
        _loadingApi = false;
        _error = reason;
      });
    }
  }
}
