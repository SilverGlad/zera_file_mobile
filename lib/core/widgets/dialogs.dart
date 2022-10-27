import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'confirmation_dialog.dart';
import 'loading_dialog_content.dart';
import 'pix_dialog_content.dart';
import '../../generated/l10n.dart';

class DialogsUtil {
  static showLoaderDialog(BuildContext context,
      {String title,
      String message,
      bool withButton = false,
      bool addCountDownTimer = false,
      Duration countDownTimer,
      String buttonText = "",
      String negativeText = "",
      Function buttonAction,
      Function negativeAction,
      Function onCoundDownFinished,
      Function onDismiss}) {
    if (title == null) title = S.of(context).dialog_loading;

    var negativeButton = TextButton(
      child: Text(
        negativeText != null ? negativeText : "",
        style: TextStyle(
          fontWeight: fontWeightMedium,
          color: colorPrimary,
        ),
      ),
      onPressed: negativeAction != null
          ? negativeAction
          : () {
              Navigator.pop(context);
            },
    );

    var positiveButton = TextButton(
      child: Text(
        buttonText != null ? buttonText : "",
        style: TextStyle(
          fontWeight: fontWeightMedium,
          color: colorPrimary,
        ),
      ),
      onPressed: buttonAction != null
          ? buttonAction
          : () {
              Navigator.pop(context);
            },
    );

    AlertDialog alert = AlertDialog(
      content: LoadingDialogContent(
        title: title,
        message: message,
        addCountdown: addCountDownTimer,
        countDownDuration: countDownTimer,
        onCountDownEnd: onCoundDownFinished,
      ),
      actions: [
        withButton ? negativeButton : Container(),
        withButton ? positiveButton : Container(),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then(onDismiss != null ? onDismiss() : (value) {});
  }

  static showConfirmationDialog(BuildContext context,
      {String establishmentName, String establishmentPicture, Function cancelClick, Function onContinue, Function onDismiss}) {
    var continueButton = TextButton(
        child: Text(
          "Prosseguir",
          style: TextStyle(
            fontWeight: fontWeightMedium,
            color: colorPrimary,
          ),
        ),
        onPressed: onContinue);

    var negativeButton = TextButton(
        child: Text(
          "Voltar",
          style: TextStyle(
            fontWeight: fontWeightMedium,
            color: colorPrimary,
          ),
        ),
        onPressed: cancelClick);

    AlertDialog alert = AlertDialog(
      content: ConfirmationDialogContent(
        establishmentName: establishmentName,
        establishmentPic: establishmentPicture,
      ),
      actions: [negativeButton, continueButton],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: alert,
        );
      },
    ).then(onDismiss != null ? onDismiss() : (value) {});
  }

  static showPixDialog(BuildContext context, {String qrCodeData, Function cancelClick, Function copyClick, Function onCoundDownFinished, Function onDismiss}) {
    var copyButton = TextButton(
        child: Text(
          "Copiar código",
          style: TextStyle(
            fontWeight: fontWeightMedium,
            color: colorPrimary,
          ),
        ),
        onPressed: copyClick);

    var positiveButton = TextButton(
        child: Text(
          "Cancelar",
          style: TextStyle(
            fontWeight: fontWeightMedium,
            color: colorPrimary,
          ),
        ),
        onPressed: cancelClick);

    AlertDialog alert = AlertDialog(
      content: PixDialogContent(
        qrCodeData: qrCodeData,
        countDownDuration: Duration(minutes: 3),
        onCountDownEnd: onCoundDownFinished,
      ),
      actions: [copyButton, positiveButton],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: alert,
        );
      },
    ).then(onDismiss != null ? onDismiss() : (value) {});
  }

  static showAlertDialog(
      {BuildContext context,
      String title,
      String message,
      String positiveButtonText,
      String negativeButtonText,
      Function onPositiveClick,
      Function onNegativeClick,
      Function onDismiss}) {
    // set up the button
    var positiveButton = TextButton(
      child: Text(
        positiveButtonText != null ? positiveButtonText : "OK",
        style: TextStyle(
          fontWeight: fontWeightMedium,
          color: colorPrimary,
        ),
      ),
      onPressed: onPositiveClick != null
          ? onPositiveClick
          : () {
              Navigator.pop(context);
            },
    );

    var negativeButton = TextButton(
      child: Text(
        negativeButtonText != null ? negativeButtonText : S.of(context).dialog_cancel,
        style: TextStyle(
          color: colorPrimary,
        ),
      ),
      onPressed: onNegativeClick != null
          ? onNegativeClick
          : () {
              Navigator.pop(context);
            },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: title != null ? Text(title) : Container(),
      content: message != null ? Text(message) : Container(),
      actions: [
        negativeButtonText != null ? negativeButton : Container(),
        positiveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) {
      if (onDismiss != null) {
        onDismiss.call();
      }
    });
  }
}
