import 'package:flutter/material.dart';
import 'package:zera_fila/core/data/model/fidelity_data.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';

class FidelityTile extends StatelessWidget {
  const FidelityTile({Key key, this.fidelity_data}) : super(key: key);
  final Fidelity_data fidelity_data;
  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Container(
      child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: Text(fidelity_data.estabilishment_name,
                  style: appBarTextStyle),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fidelity_data.details.length,
              itemBuilder: (_, index){
                count = count == 10? 0:count+1;
                print(count);
                return Column(
                  children: [
                    Container(
                      color: index.isEven? Colors.grey.shade200:Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Container(
                            width: 160,
                            child: Text(fidelity_data.details[index].data_hora)
                          ),
                          Container(
                            child: fidelity_data.details[index].discount? Icon(Icons.star, color: Colors.amber,): Container()
                          ),
                          Container(
                            width: 120,
                            child: fidelity_data.details[index].discount? Text('Desconto ${fidelity_data.details[index].discountValue}', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)): Container()
                          ),
                        ]),
                      ),
                    ),

                    if(index == fidelity_data.details.length-1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text('${count == 9? 'Falta':'Faltam'} ${10-count} ${count == 9? 'refeição':'refeições'} para o seu desconto!',
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500)),
                      )
                  ],
                );
              }
            )
          ]
      ),
    );
  }
}
