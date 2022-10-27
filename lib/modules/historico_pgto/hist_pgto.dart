import 'package:flutter/material.dart';
import 'components/body.dart';

import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';

class HistoricoPagamento extends StatefulWidget {
  HistoricoPagamento({Key key}) : super(key: key);

  @override
  State<HistoricoPagamento> createState() => _HistoricoPagamentoState();
}

class _HistoricoPagamentoState extends State<HistoricoPagamento> {
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
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "Pagamento de comandas efetuados",
              style: appBarTextStyle,
            ),
          ),
          // Container(
          //   width: 24,
          //   height: 24,
          //   margin: EdgeInsets.only(right: 16),
          //   child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
          // )
        ],
      ),
    );
  }
}
