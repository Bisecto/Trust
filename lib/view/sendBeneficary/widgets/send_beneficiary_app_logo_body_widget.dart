import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      // height: size.height,
      // width: size.width,
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 0.0,
        bottom: 0.0,
        top: 20.0,
      ),
      decoration: BoxDecoration(
        color:Colors.transparent
            //theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
        // image: DecorationImage(
        //   image: AssetImage(
        //     theme.isDark?
        //     'assets/images/tellaTrust.png'
        //         :'assets/images/tellaTrustLightMode.png',
        //   ),
        //   //colorFilter: ColorFilter(),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: child,
    );
  }
}
