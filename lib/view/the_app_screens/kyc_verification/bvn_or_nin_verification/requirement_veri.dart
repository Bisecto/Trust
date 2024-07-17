import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/kyc_verification/bvn_or_nin_verification/select_verification_type.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/custom_theme.dart';

class BVN_NIN_KYC_1 extends StatefulWidget {
  const BVN_NIN_KYC_1({super.key});

  @override
  State<BVN_NIN_KYC_1> createState() => _BVN_NIN_KYC_1State();
}

class _BVN_NIN_KYC_1State extends State<BVN_NIN_KYC_1> {
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
              height: AppUtils.deviceScreenSize(context).height+50,
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
                height: AppUtils.deviceScreenSize(context).height+50,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                color: theme.isDark
                    ? AppColors.darkModeBackgroundContainerColor
                    : AppColors.white,
                child: Container(
                  width: AppUtils.deviceScreenSize(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Level 1',
                          size: 20,
                          weight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          color:
                              theme.isDark ? AppColors.white : AppColors.black,
                          maxLines: 2,
                        ),
                        CustomText(
                          text: 'Requirements for Level 1',
                          size: 12,
                          textAlign: TextAlign.center,
                          color:
                              theme.isDark ? AppColors.white : AppColors.black,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.person_2_outlined),
                            const SizedBox(width: 10),
                            CustomText(
                              text: "BVN or NIN",
                              color: theme.isDark
                                  ? AppColors.white
                                  : AppColors.black,
                              weight: FontWeight.bold,
                              size: 12,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.check),
                            const SizedBox(width: 10),
                            CustomText(
                              text: "Attestation",
                              color: theme.isDark
                                  ? AppColors.white
                                  : AppColors.black,
                              weight: FontWeight.bold,
                              size: 12,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const CustomText(
                          text: 'Level 1 Benefits',
                          size: 12,
                          textAlign: TextAlign.center,
                          color: AppColors.textColor,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 10],
                          color: AppColors.lightgrey,
                          strokeWidth: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      text: 'Single Credit Limit:',
                                      size: 10,
                                      textAlign: TextAlign.center,
                                      color: AppColors.lightgrey,
                                      weight: FontWeight.bold,
                                    ),
                                    CustomText(
                                      text: 'N 50,000.00',
                                      size: 12,
                                      textAlign: TextAlign.center,
                                      color: theme.isDark
                                          ? AppColors.lightgrey
                                          : AppColors.black,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const CustomText(
                                      text: 'Daily Credit Limit:',
                                      size: 10,
                                      textAlign: TextAlign.center,
                                      color: AppColors.lightgrey,
                                      weight: FontWeight.bold,
                                    ),
                                    CustomText(
                                      text: 'N 300,000.00',
                                      size: 12,
                                      textAlign: TextAlign.center,
                                      color: theme.isDark
                                          ? AppColors.lightgrey
                                          : AppColors.black,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 10],
                          color: AppColors.lightgrey,
                          strokeWidth: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      text: 'Single Debit Limit:',
                                      size: 10,
                                      textAlign: TextAlign.center,
                                      color: AppColors.lightgrey,
                                      weight: FontWeight.bold,
                                    ),
                                    CustomText(
                                      text: 'N 50,000.00',
                                      size: 12,
                                      textAlign: TextAlign.center,
                                      color: theme.isDark
                                          ? AppColors.lightgrey
                                          : AppColors.black,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const CustomText(
                                      text: 'Daily Debit Limit:',
                                      size: 10,
                                      textAlign: TextAlign.center,
                                      color: AppColors.lightgrey,
                                      weight: FontWeight.bold,
                                    ),
                                    CustomText(
                                      text: 'N 300,000.00',
                                      size: 12,
                                      textAlign: TextAlign.center,
                                      color: theme.isDark
                                          ? AppColors.lightgrey
                                          : AppColors.black,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormButton(
                          onPressed: () {
                            AppNavigator.pushAndStackPage(context,
                                page: const BvnNinKyc2());
                          },
                          text: 'Continue',
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
