import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/colors.dart';
import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        duration: Duration(milliseconds: 400),
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
    // Utils.setupStatusAndNavigationBar(
    //   colorPrimary, //statusBar color
    //   Brightness.light, //statusBar brightness
    //   colorPrimary, //navBar color
    //   Brightness.light, //navBar brightness
    // );
  }

  void _initAnimation() {
    Timer(Duration(seconds: 3), () {
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
