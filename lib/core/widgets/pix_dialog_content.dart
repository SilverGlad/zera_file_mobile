import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/colors.dart';

class PixDialogContent extends StatefulWidget {
  final String qrCodeData;
  final Function onCountDownEnd;
  final Duration countDownDuration;

  PixDialogContent({Key key, this.countDownDuration, this.onCountDownEnd, this.qrCodeData}) : super(key: key);

  @override
  _PixDialogContentState createState() => _PixDialogContentState();
}

class _PixDialogContentState extends State<PixDialogContent> {
  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    endTime += widget.countDownDuration.inMilliseconds;
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  void onEnd() {
    widget.onCountDownEnd.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CountdownTimer(
                      controller: controller,
                      widgetBuilder: (_, CurrentRemainingTime time) {
                        var min = time?.min ?? 0;
                        var sec = time?.sec ?? 0;

                        var text = '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';

                        return Text(
                          text,
                          style: TextStyle(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                  )
                ],
              ),
              Container(
                  width: 180,
                  margin: EdgeInsets.only(left: 24),
                  child: Wrap(
                    children: [
                      Text(
                        "Aguardando pagamento...",
                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          "Escaneie o QRCode ou copie o código pix e pague em seu aplicativo bancário",
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      )
                    ],
                  )),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 240,
            width: 240,
            child: QrImage(
              data: widget.qrCodeData,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
