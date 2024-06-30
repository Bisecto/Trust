import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_utils.dart';
import '../../res/app_colors.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'app_custom_text.dart';

showToast(
    {required BuildContext context,
    required String title,
    required String subtitle,
    required ToastMessageType type}) {
  if (type == ToastMessageType.success) {
    alert(
        context: context,
        title: title,
        subtitle: subtitle,
        alertType: AlertType.success);
  } else if (type == ToastMessageType.info) {
    alert(
        context: context,
        title: title,
        subtitle: subtitle,
        alertType: AlertType.info);
  } else if (type == ToastMessageType.error) {
    Vibrate.vibrate(); //vibrate device
    alert(
        context: context,
        title: title,
        subtitle: subtitle,
        alertType: AlertType.error);
  }
}

Future<bool?> alert({
  required BuildContext context,
  required String title,
  required String subtitle,
  required AlertType alertType,
}) {
  final theme =
      Provider.of<CustomThemeState>(context, listen: false).adaptiveThemeMode;
  return Alert(
    context: context,
    //title: title,
    //desc: subtitle,
    content: Container(
      width: double.infinity,
      height: 310,
      decoration: BoxDecoration(
          color: theme.isDark
              ? AppColors.darkModeBackgroundContainerColor
              : AppColors.white,
          borderRadius: BorderRadius.circular(20),


          image: DecorationImage(
              image: AssetImage(AppImages.modalBackground), fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: theme.isDark ? AppColors.red : Colors.transparent,
                      border: Border.all(
                          color:
                              theme.isDark ? AppColors.red : AppColors.green),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Icon(
                    Icons.arrow_back,
                    color: theme.isDark ? AppColors.white : AppColors.black,
                  )),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Lottie.asset(_getImage(alertType), height: 120, width: 120),
              const SizedBox(
                height: 5,
              ),
              TextStyles.textHeadings(
                textValue: title,
                textColor: theme.isDark ? AppColors.white : AppColors.black,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomText(
                text: subtitle,
                color: theme.isDark ? AppColors.white : AppColors.black,
                maxLines: 5,
              ),
              SizedBox(
                height: 50,
              )
            ],
          )
        ],
      ),
    ),
    //
    //padding: const EdgeInsets.all(20),
    // closeIcon: Padding(
    //     padding: const EdgeInsets.only(right: 10.0),
    //     child: Container(
    //       height: 40,
    //       width: 40,
    //       decoration: BoxDecoration(
    //           shape: BoxShape.circle, color: Colors.black.withOpacity(0.07)),
    //       child: const Icon(Icons.close, size: 24, color: Colors.black),
    //     )),

    style: AlertStyle(
      backgroundColor: Colors.transparent,
      overlayColor: Colors.black54,
      isCloseButton: false,
      isButtonVisible: false,
      animationType: AnimationType.grow,
      buttonAreaPadding: const EdgeInsets.all(0),
      alertPadding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width),


      isOverlayTapDismiss: true,
      //descTextAlign: TextAlign.center,
      animationDuration: const Duration(milliseconds: 400),
      alertBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
