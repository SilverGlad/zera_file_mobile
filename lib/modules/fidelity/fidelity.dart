import 'package:flutter/material.dart';
import '../../core/data/model/fidelity_data.dart';
import 'components/body.dart';

import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';

class Fidelity extends StatefulWidget {
  Fidelity({Key key}) : super(key: key);

  @override
  State<Fidelity> createState() => _FidelityState();
}

class _FidelityState extends State<Fidelity> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Fidelity_data> exampleFidelity =[
    Fidelity_data(
      estabilishment_name: 'Paulinhos Grill Nações Unidas',
      details: [
        Fidelity_detail(data_hora: '01/09/22 - 14:12', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '02/09/22 - 13:46', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '03/09/22 - 13:31', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '04/09/22 - 12:50', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '05/09/22 - 13:17', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '06/09/22 - 14:07', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '07/09/22 - 13:52', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '08/09/22 - 13:28', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '09/09/22 - 13:40', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '10/09/22 - 12:57', discountValue: '', discount: false),
        Fidelity_detail(data_hora: '11/09/22 - 13:45', discountValue: '20%', discount: true),
      ]
    ),

    Fidelity_data(
        estabilishment_name: 'Juli - Comida de Verdade',
        details: [
          Fidelity_detail(data_hora: '01/09/22 - 14:12', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '02/09/22 - 13:46', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '03/09/22 - 13:31', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '04/09/22 - 12:50', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '05/09/22 - 13:17', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '06/09/22 - 14:07', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '07/09/22 - 13:52', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '08/09/22 - 13:28', discountValue: '', discount: false),
          Fidelity_detail(data_hora: '09/09/22 - 13:40', discountValue: '', discount: false),
        ]
    )
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(context),
      backgroundColor: colorBackground,
      body: Body(scaffoldKey: scaffoldKey, fidelityList: exampleFidelity),
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
              "Programas de fidelidade",
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
