import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../res/app_colors.dart';
import '../res/app_icons.dart';
import '../res/app_images.dart';
import '../res/app_strings.dart';
import '../utills/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUtils appUtils = AppUtils();

  @override
  void initState() {
    appUtils.openApp(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Image.asset(
          AppImages.splashLogo,
          height: AppUtils.deviceScreenSize(context).height,
          width: AppUtils.deviceScreenSize(context).width,
        )
        // SvgPicture.asset(
        //   AppIcons.splashScreen,
        //   height: AppUtils.deviceScreenSize(context).height,
        //   width: AppUtils.deviceScreenSize(context).width,
        // ),
        // Container(
        //   height: AppUtils.deviceScreenSize(context).height,
        //   width: AppUtils.deviceScreenSize(context).width,
        //   decoration:  BoxDecoration(
        //       gradient: const LinearGradient(
        //         colors: [
        //           AppColors.lightGreen,
        //           AppColors.darkGreen,
        //           AppColors.lightGreen
        //         ],
        //         begin: Alignment.bottomLeft,
        //         end: Alignment.topRight,
        //       ),
        //       // image: DecorationImage(
        //       //     image: const AssetImage(
        //       //       AppImages.splashScreenFrame,
        //       //     ),
        //       //     fit: BoxFit.values[0])),
        //   child: Center(child:Image.asset(AppImages.fullLogo)),
        // )
        );
  }
}
