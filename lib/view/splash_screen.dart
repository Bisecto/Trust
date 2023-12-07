
import 'package:flutter/material.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../res/app_colors.dart';
import '../res/app_images.dart';
import '../res/app_strings.dart';
import '../utills/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUtils appUtils=AppUtils();
  @override
  void initState() {
    appUtils.checkPermission(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.logoWhite,height: 90,width: 80,),
            const CustomText(
              text: AppStrings.appName,
              color: AppColors.white,
              weight: FontWeight.bold,
              size: 25,
            )

          ],
        ),
      ),
    );
  }
}
