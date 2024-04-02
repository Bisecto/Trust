import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:lottie/lottie.dart';
import '../../res/app_colors.dart';
import '../../utills/enums/toast_mesage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

showToast(
    {required BuildContext context,
      required String title,
      required String subtitle,
      required ToastMessageType type}) {
  if (type == ToastMessageType.success) {
    alert(context: context, title: title, subtitle: subtitle, alertType: AlertType.success);
  } else if (type == ToastMessageType.info) {
    alert(context: context, title: title, subtitle: subtitle, alertType: AlertType.info);
  } else if (type == ToastMessageType.error) {
    Vibrate.vibrate(); //vibrate device
    alert(context: context, title: title, subtitle: subtitle, alertType: AlertType.error);
  }
}

Future<bool?> alert({
  required BuildContext context,
  required String title,
  required String subtitle,
  required AlertType alertType,
}) {
  // final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
  return Alert(
    context: context,
    title: title,
    desc: subtitle,
    image: Lottie.asset(_getImage(alertType),height: 100,width: 100),
    padding: const EdgeInsets.all(20),
    closeIcon:  Padding(
        padding:  const EdgeInsets.only(right:10.0),
        child:  Container(
          height: 40,
          width: 40,
          decoration:  BoxDecoration(
              shape: BoxShape.circle, color:  Colors.black.withOpacity(0.07)),
          child:const  Icon(
              Icons.close,
              size: 24,
              color: Colors.black
          ),
        )),

    style: AlertStyle(
      backgroundColor: Colors.white,
      overlayColor: Colors.black54,
      isButtonVisible: false,
      animationType: AnimationType.grow,
      buttonAreaPadding: const EdgeInsets.all(0),
      alertPadding: const EdgeInsets.all(20),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.7,maxWidth: MediaQuery.of(context).size.width * 0.7),
      titleStyle:  TextStyle(color: getColor(alertType), fontWeight: FontWeight.w600, fontSize: 20, fontFamily: 'CeraPro'),
      descStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15, fontFamily: 'CeraPro'),
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descTextAlign: TextAlign.center,
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      alertAlignment: Alignment.center,
    ),
    // type: alertType,
  ).show();
}

Color getColor(AlertType type) {
  if (type == AlertType.success) {
    return Colors.green;
  }
  if (type == AlertType.info) {
    return AppColors.appBarMainColor;
  }
  return Colors.red;
}

String _getImage(AlertType type) {
  if (type == AlertType.success) {
    return 'assets/animations/success.json';
  }
  if (type == AlertType.info) {
    return 'assets/animations/info.json';
  }
  return 'assets/animations/error.json';
}
