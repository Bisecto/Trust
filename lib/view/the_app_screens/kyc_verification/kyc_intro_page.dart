import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../res/app_colors.dart';
import '../../../utills/custom_theme.dart';
import 'bvn_or_nin_verification/requirement_veri.dart';

class KYCIntro extends StatefulWidget {
  const KYCIntro({super.key});

  @override
  State<KYCIntro> createState() => _KYCIntroState();
}

class _KYCIntroState extends State<KYCIntro> {
  int current_step = 0;

  List<Step> steps = [
    const Step(
      title: Text(''),
      content: Text(''),
      isActive: true,
    ),
    const Step(
      title: Text(''),
      content: Text(''),
      isActive: false,
    ),
    const Step(
      title: Text(''),
      content: Text(''),
      state: StepState.complete,
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      // appBar: AppBar(
      //   backgroundColor: AppColors.darkGreen,
      //   elevation: 1,
      //   title: const CustomText(
      //     text: "KYC verification",
      //     color: AppColors.white,
      //   ),
      //   leading: Navigator.canPop(context)
      //       ? IconButton(
      //           icon: const Icon(Icons.arrow_back, color: AppColors.white),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         )
      //       : null,
      // ),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            // bottom: 0,
            child: SizedBox(
              height: AppUtils.deviceScreenSize(context).height + 50,
              width: double.infinity,
              // color: theme.isDark
              //     ? AppColors.darkModeBackgroundColor
              //     : AppColors.white,

              //color: ,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(AppImages.authAppLogoImage),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              child: SvgPicture.asset(
                theme.isDark
                    ? AppIcons.kycDarkBackground
                    : AppIcons.kycBackground,
                height: AppUtils.deviceScreenSize(context).height + 50,
                width: double.infinity,
              ),
            ),
          ),
          SafeArea(
            left: true,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: theme.isDark
                                ? AppColors.white
                                : AppColors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(child: Icon(Icons.arrow_back)),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                //height: AppUtils.deviceScreenSize(context).height,
                width: AppUtils.deviceScreenSize(context).width,

                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage(AppImages.authAppLogoImage),
                //     fit: BoxFit.fill,
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Increase Your\nTransaction Limit',
                        size: 24,
                        weight: FontWeight.w900,
                        textAlign: TextAlign.center,
                        color: theme.isDark ? AppColors.white : AppColors.black,
                        maxLines: 2,
                      ),
                      const CustomText(
                        text: 'Claim Tella point',
                        size: 12,
                        textAlign: TextAlign.center,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: AppUtils.deviceScreenSize(context).width,
                        height: 70,
                        decoration: BoxDecoration(
                          color: theme.isDark?null:AppColors.lightgreen2,
                          border: Border.all(color: AppColors.darkGreen),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Image.asset(AppImages.coatOfArm,height: 25,width: 25,),
                              const SizedBox(width: 10,),
                              Container(
                                width: AppUtils.deviceScreenSize(context).width /
                                    1.4,
                                height: 50,
                                child: const CustomText(
                                  text:
                                      'We are required by the CBN to ensure you '
                                      'complete your profile set-up to gain'
                                      ' full access to all Tella Bank services.',
                                  maxLines: 3,
                                  color: AppColors.darkGreen,
                                  size:12,
                                  weight: FontWeight.w800,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(20),
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundContainerColor
                            : AppColors.white,
                        child: Container(
                          //height: 250,
                          width: AppUtils.deviceScreenSize(context).width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: '3 Steps to go',
                                  size: 24,
                                  weight: FontWeight.w900,
                                  textAlign: TextAlign.center,
                                  color: theme.isDark
                                      ? AppColors.white
                                      : AppColors.black,
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 80,
                                  width:
                                      AppUtils.deviceScreenSize(context).width -
                                          20,
                                  child: Stepper(
                                    currentStep: current_step,
                                    steps: steps,

                                    type: StepperType.horizontal,
                                    //physics: const ScrollPhysics(),
                                    elevation: 0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.person_2_outlined),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text: "BVN or NIN",
                                      color: theme.isDark
                                          ? AppColors.white
                                          : AppColors.black,
                                      weight: FontWeight.bold,
                                      size: 12,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.check),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text: "Attestation",
                                      color: theme.isDark
                                          ? AppColors.white
                                          : AppColors.black,
                                      weight: FontWeight.bold,
                                      size: 12,
                                    )
                                  ],
                                ),
                                FormButton(
                                  onPressed: () {
                                    AppNavigator.pushAndStackPage(context,
                                        page: const BVN_NIN_KYC_1());
                                  },
                                  text: 'Get Started',
                                  borderRadius: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
