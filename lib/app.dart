import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zera_fila/core/data/model/establishment.dart';
import 'package:zera_fila/firebase_options.dart';
import 'package:zera_fila/modules/establishment_detail/establishment_detail.dart';
import 'package:zera_fila/modules/home/home.dart';
import 'package:zera_fila/modules/screen_url/screen_url.dart';
import 'core/data/connection/connection.dart';
import 'core/data/request/establishment_request.dart';
import 'modules/splash/splash.dart';
import 'generated/l10n.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Check if app is running on Android devices and set transparent statusBar
    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.android) _setupTransparentStatusBar();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
        canvasColor: Colors.transparent,
      ),
      onGenerateRoute: (settings) {
        if(settings.name == '/home'){
          print('Home Screen 4');
          return MaterialPageRoute(
              builder: (_) => HomeScreen(), settings: settings);
        }else if(settings.name.contains('/restaurante/')){
          return MaterialPageRoute(
              builder: (_) => ScreenUrl(uniqueID: settings.name,));
        }else{
          return MaterialPageRoute(
              builder: (_) => DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web? HomeScreen(): SplashScreen());
        }
      },
    );
  }

  void _setupTransparentStatusBar() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
}
