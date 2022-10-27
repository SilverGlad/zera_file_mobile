import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../generated/l10n.dart';

class ScheduleChooserScreen extends StatefulWidget {
  final String currentSelectedSchedule;
  final List<String> availableSchedules;
  final Function scheduleSelected;

  const ScheduleChooserScreen({Key key, this.currentSelectedSchedule, this.availableSchedules, this.scheduleSelected}) : super(key: key);

  @override
  _ScheduleChooserScreenState createState() => _ScheduleChooserScreenState();
}

class _ScheduleChooserScreenState extends State<ScheduleChooserScreen> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: bottomSheetMaxSize,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.horizontal_rule_rounded,
                    color: Colors.black38,
                    size: 40,
                  ),
                  Divider(
                    color: Colors.black38,
                    height: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16, bottom: 40),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            S.of(context).checkout_withdrawScheduleTitle,
                            style: TextStyle(fontSize: 16, fontWeight: fontWeightMedium, color: Colors.black),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.only(top: 16, bottom: 40),
                        itemBuilder: (context, index) => _buildScheduleListItem(context, widget.availableSchedules[index]),
                        itemCount: widget.availableSchedules.length,
                        scrollDirection: Axis.vertical,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScheduleListItem(BuildContext context, String item) {
    return Material(
      child: Container(
        height: 32,
        width: double.infinity,
        child: InkWell(
          highlightColor: Colors.black12,
          onTap: () {
            Navigator.of(context).pop();
            widget.scheduleSelected.call(item);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Text(
              item,
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: item == widget.currentSelectedSchedule ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
