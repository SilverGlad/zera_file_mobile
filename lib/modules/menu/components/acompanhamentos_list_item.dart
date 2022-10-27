import 'package:flutter/material.dart';

import '../../../core/data/model/acompanhamentos.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../generated/l10n.dart';

class AcompanhamentoWidget extends StatefulWidget {
  final Acompanhamentos acompanhamentos;
  final Function onRequiredSelected;
  final Function onAcompanhamentoSelected;

  const AcompanhamentoWidget({Key key, this.acompanhamentos, this.onRequiredSelected, this.onAcompanhamentoSelected}) : super(key: key);

  @override
  _AcompanhamentoWidgetState createState() => _AcompanhamentoWidgetState();
}

class _AcompanhamentoWidgetState extends State<AcompanhamentoWidget> {
  var numberOfRequiredItens = 0;
  var numberOfRequiredSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.black45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 40,
            color: colorBackground,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    widget.acompanhamentos.tITULO,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: fontWeightMedium,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                widget.acompanhamentos.fLObrigar == "1"
                    ? Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 16),
                        child: Text(
                          S.of(context).menu_required,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: fontWeightMedium,
                            color: Colors.blueGrey,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                widget.acompanhamentos.fLObrigar == "1" ? _buildRequiredList(widget.acompanhamentos, index) : _buildOptionalList(widget.acompanhamentos, index),
            itemCount: widget.acompanhamentos.opEs.length,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredList(Acompanhamentos item, int index) {
    numberOfRequiredItens++;
    return Column(
      children: [
        RadioListTile(
          title: Text(
            item.opEs[index].dS,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          groupValue: item.selection,
          value: index,
          onChanged: (val) {
            setState(() {
              item.selected = true;
              item.selection = val;
            });
            widget.onAcompanhamentoSelected.call();
          },
        ),
        index < item.opEs.length - 1
            ? Padding(
                padding: EdgeInsets.only(left: 28),
                child: Divider(
                  color: Colors.black26,
                  height: 1,
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildOptionalList(Acompanhamentos item, int index) {
    return Column(
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            item.opEs[index].dS,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          value: item.opEs[index].checked,
          onChanged: (value) {
            setState(() {
              item.opEs[index].checked = value;
            });
          },
        ),
        index < item.opEs.length - 1
            ? Padding(
                padding: EdgeInsets.only(left: 28),
                child: Divider(
                  color: Colors.black26,
                  height: 1,
                ),
              )
            : Container(),
      ],
    );
  }
}
