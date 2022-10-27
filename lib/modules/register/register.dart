import 'package:flutter/material.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../generated/l10n.dart';
import 'components/body.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(context),
      backgroundColor: colorBackground,
      body: Body(scaffoldKey: scaffoldKey),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        S.of(context).register_toolbar,
        style: appBarTextStyle,
      ),
    );
  }
}
