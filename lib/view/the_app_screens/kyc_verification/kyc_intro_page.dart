import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../res/app_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkGreen,
        elevation: 1,
        title: const CustomText(
          text: "KYC verification",
          color: AppColors.white,
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            //bottom: 20,
            child: Container(
              height: AppUtils.deviceScreenSize(context).height,
              width: AppUtils.deviceScreenSize(context).width,
              //color: ,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(AppImages.authAppLogoImage),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              child: SvgPicture.asset(AppIcons.kycBackground),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,

            child: Container(
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
                      const CustomText(
                        text: 'Increase Your\nTransaction Limit',
                        size: 24,
                        weight: FontWeight.w900,
                        textAlign: TextAlign.center,
                        color: AppColors.black,
                        maxLines: 2,
                      ),
                      const CustomText(
                        text: 'Claim Tella point',
                        size: 12,
                        textAlign: TextAlign.center,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.white,
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
                                const CustomText(
                                  text: '3 Steps to go',
                                  size: 24,
                                  weight: FontWeight.w900,
                                  textAlign: TextAlign.center,
                                  color: AppColors.black,
                                  maxLines: 2,
                                ),
                                Container(
                                  height: 80,
                                  width: AppUtils.deviceScreenSize(context)
                                          .width -
                                      20,
                                  child: Stepper(
                                    currentStep: current_step,
                                    steps: steps,

                                    type: StepperType.horizontal,
                                    //physics: const ScrollPhysics(),
                                    elevation: 0,
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(Icons.person_2_outlined),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text: "BVN or NIN",
                                      color: AppColors.black,
                                      weight: FontWeight.bold,
                                      size: 12,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      text: "Attestation",
                                      color: AppColors.black,
                                      weight: FontWeight.bold,
                                      size: 12,
                                    )
                                  ],
                                ),
                                FormButton(
                                  onPressed: () {
                                    AppNavigator.pushAndStackPage(context,
                                        page: BVN_NIN_KYC_1());
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
