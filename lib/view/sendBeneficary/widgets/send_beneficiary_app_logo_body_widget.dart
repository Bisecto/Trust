import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/app_colors.dart';
import '../../../utills/custom_theme.dart';

class SendBeneficiaryAppLogoBodyWidget extends StatelessWidget {
  final Widget child;

  const SendBeneficiaryAppLogoBodyWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 10.0,
        top: 20.0,
      ),
      decoration: BoxDecoration(
        color:
            theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
        image: DecorationImage(
          image: AssetImage(
            theme.isDark?
            'assets/images/tellaTrust.png'
                :'assets/images/tellaTrustLightMode.png',
          ),
          //colorFilter: ColorFilter(),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
