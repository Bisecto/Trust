import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';

class GeneralConstant {
  static OutlineInputBorder networkSearchBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      50.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.white,
      width: 1.5,
    ),
  );
  
  static OutlineInputBorder sendSearchBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      50.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.recentTxnMainBgColor,
      width: 1.5,
    ),
  );
  
  static OutlineInputBorder tellaSendSearchBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      10.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.sendFormBorderColor,
      width: 1.5,
    ),
  );
  
  static OutlineInputBorder bankSendSearchBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      10.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.sendFormBorderColor,
      width: 1.5,
    ),
  );

  static OutlineInputBorder networkSearchErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      50.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.red,
      width: 1.5,
    ),
  );
  
  static OutlineInputBorder tellaSendSearchErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      50.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.red,
      width: 1.5,
    ),
  );

  static OutlineInputBorder bankSendSearchErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      50.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.red,
      width: 1.5,
    ),
  );

  static TextStyle normalTextStyle = const TextStyle(
    fontStyle: FontStyle.normal,
    color: AppColors.recentTxnTxtColor,
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
  );

  static TextStyle italicTextStyle = const TextStyle(
    fontStyle: FontStyle.italic,
    color: AppColors.white,
  );

  static TextStyle networkDefaultTextStyle = const TextStyle(
    color: AppColors.recentTxnAmountBgColor,
  );
  
  static TextStyle sendToDefaultTextStyle = const TextStyle(
    color: AppColors.sendBodyTextColor,
  );

  static EdgeInsetsDirectional networkSearchWidgetContentPadding =
      const EdgeInsetsDirectional.only(
    top: 10,
    bottom: 10,
    start: 30,
    end: 1,
  );
  
  static EdgeInsetsDirectional sendToFormWidgetContentPadding =
      const EdgeInsetsDirectional.only(
    top: 10,
    bottom: 10,
    start: 10,
    end: 1,
  );
  
  static EdgeInsetsDirectional tellaSendToSearchWidgetContentPadding =
      const EdgeInsetsDirectional.only(
    top: 10,
    bottom: 10,
    start: 30,
    end: 1,
  );
  
  static EdgeInsetsDirectional bankSendToSearchWidgetContentPadding =
      const EdgeInsetsDirectional.only(
    top: 10,
    bottom: 10,
    start: 30,
    end: 1,
  );

  static EdgeInsetsDirectional sendSearchWidgetContentPadding =
      const EdgeInsetsDirectional.only(
    top: 10,
    bottom: 10,
    start: 30,
    end: 1,
  );
}
