import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../../utills/custom_theme.dart';

class CustomKeyPadWidget extends StatelessWidget {
  final String keyPadValue;
  final bool isKeyPadValueIcon;
  final VoidCallback keyPadCallback;

  const CustomKeyPadWidget({
    super.key,
    required this.keyPadValue,
    required this.keyPadCallback,
    this.isKeyPadValueIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return InkWell(
      onTap: keyPadCallback,
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.only(
          bottom: 5.0,
        ),
        // color:
        // theme.isDark ? AppColors.darkModeBackgroundColor : Colors.white,
        decoration: BoxDecoration(
            color:
                theme.isDark ? AppColors.darkModeBackgroundColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: !theme.isDark
                  ? AppColors.grey
                  : Colors.white,
            )),
        child: Center(
          child: isKeyPadValueIcon
              ? SvgPicture.asset(
                  keyPadValue,
                  color: theme.isDark
                      ? AppColors.darkModeBackgroundMainTextColor
                      : AppColors.black,
                )
              : Text(
                  keyPadValue,
                  style: TextStyle(
                    //color: AppColors.black,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundMainTextColor
                        : AppColors.black,

                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
