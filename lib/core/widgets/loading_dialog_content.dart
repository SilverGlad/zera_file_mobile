import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import '../utils/colors.dart';

class LoadingDialogContent extends StatefulWidget {
  final String title;
  final String message;
  final bool addCountdown;
  final Function onCountDownEnd;
  final Duration countDownDuration;

  LoadingDialogContent({Key key, this.title, this.message, this.addCountdown, this.countDownDuration, this.onCountDownEnd}) : super(key: key);

  @override
  _LoadingDialogContentState createState() => _LoadingDialogContentState();
}

class _LoadingDialogContentState extends State<LoadingDialogContent> {
  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    if (widget.addCountdown) {
      endTime += widget.countDownDuration.inMilliseconds;
      controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    }
  }

  void onEnd() {
    widget.onCountDownEnd.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
              ),
              (widget.addCountdown)
                  ? Container(
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
                  : Container(
                      height: 40,
                      width: 40,
                    ),
            ],
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 24),
                child: Wrap(
                  children: [
                    (widget.title != null && widget.title.isNotEmpty)
                        ? Text(
                            widget.title,
                            style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                          )
                        : Container(),
                    //
                    Container(height: 4),
                    //
                    (widget.message != null && widget.message.isNotEmpty)
                        ? Text(
                            widget.message,
                            style: TextStyle(fontSize: 11, color: Colors.black),
                          )
                        : Container(),
                  ],
                )),
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
