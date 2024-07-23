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

  static OutlineInputBorder networkSearchErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      50.0,
    ),
    borderSide: const BorderSide(
      color: AppColors.red,
      width: 1.5,
    ),
  );

  static TextStyle italicTextStyle = const TextStyle(
    fontStyle: FontStyle.italic,
    color: AppColors.white,
  );

  static TextStyle networkDefaultTextStyle = const TextStyle(
    color: AppColors.white,
  );

  static EdgeInsetsDirectional networkSearchWidgetContentPadding =
      const EdgeInsetsDirectional.only(
    top: 10,
    bottom: 10,
    start: 30,
    end: 1,
  );
}
