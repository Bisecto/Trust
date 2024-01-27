import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/create_pin.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../res/app_router.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class VerifyOtp extends StatefulWidget {
  String email;

  VerifyOtp({super.key, required this.email});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightShadowGreenColor,
      body: SingleChildScrollView(
        child: Container(
          height: AppUtils.deviceScreenSize(context).height,
          width: AppUtils.deviceScreenSize(context).width,
          child: Stack(
            //alignment: Alignment.,
            children: [
              Positioned(
                right: 0,
                left: 0,
                top: 0,
                //bottom: 20,
                child: Container(
                  height: AppUtils.deviceScreenSize(context).height * 0.5,
                  width: AppUtils.deviceScreenSize(context).width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.authAppLogoImage),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SafeArea(
                        child: Column(
                          children: [
                            if (Navigator.canPop(context))
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                      Border.all(color: AppColors.green)),
                                  child: const Icon(Icons.arrow_back),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ),
              ),
              Positioned.fill(
                top: AppUtils.deviceScreenSize(context).height * 0.4,
                bottom: AppUtils.deviceScreenSize(context).height * 0.4,
                right: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: AppUtils.deviceScreenSize(context).height * 0.5,
                    width: AppUtils.deviceScreenSize(context).width,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "OTP Verification",
                              weight: FontWeight.w600,
                              size: 20,
                            ),
                            CustomText(
                              text:
                                  "Input 5 digit code sent to ${widget.email}",
                              //weight: FontWeight.bold,
                              size: 16,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            OTPTextField(
                              length: 5,
                              width: MediaQuery.of(context).size.width,
                              fieldWidth: 50,
                              style: const TextStyle(fontSize: 17),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.box,
                              otpFieldStyle: OtpFieldStyle(
                                backgroundColor: AppColors.white,
                                focusBorderColor: AppColors.green,
                              ),
                              onCompleted: (pin) async {
                                AppNavigator.pushAndStackPage(context,
                                    page: const CreatePin());
                                // //print("Completed: " + pin);
                              },
                            ),

                            // DividerWithTextWidget(text: "or login with"),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
