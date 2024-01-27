import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/confirm_pin.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class CreatePin extends StatefulWidget {
  const CreatePin({super.key, });

  @override
  State<CreatePin> createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  OtpFieldController otpFieldController = OtpFieldController();
PinInputController pinInputController=PinInputController(length: 4);
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
                top: AppUtils.deviceScreenSize(context).height * 0.2,
                bottom: AppUtils.deviceScreenSize(context).height * 0.05,
                right: 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: AppUtils.deviceScreenSize(context).height * 0.6,
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
                              text: "Create Your Security Pin",
                              weight: FontWeight.w600,
                              size: 20,
                            ),
                            const CustomText(
                              text:
                                  "We will require this pin to sign you into the app",
                              //weight: FontWeight.bold,
                              size: 16,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // OTPTextField(
                            //   length: pinInputController.length,
                            //   //controller: pinInputController.text,
                            //   width: MediaQuery.of(context).size.width,
                            //   fieldWidth: 50,
                            //   keyboardType: TextInputType.none,
                            //   style: const TextStyle(fontSize: 17),
                            //   textFieldAlignment: MainAxisAlignment.spaceAround,
                            //   fieldStyle: FieldStyle.box,
                            //   otpFieldStyle: OtpFieldStyle(
                            //     backgroundColor: AppColors.white,
                            //     focusBorderColor: AppColors.green,
                            //   ),
                            //   onCompleted: (pin) async {
                            //     // AppNavigator.pushAndStackNamed(context,
                            //     //     name: AppRouter.createSecurity);
                            //     // //print("Completed: " + pin);
                            //   },
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Divider(),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            PinPlusKeyBoardPackage(
                              keyboardButtonShape: KeyboardButtonShape.defaultShape,
                              inputShape: InputShape.defaultShape,
                              keyboardMaxWidth: AppUtils.deviceScreenSize(context).width,
                              inputHasBorder: true,
                              inputFillColor: AppColors.white,
                              inputHeight: 55,
                              inputWidth: 55,
                              keyboardBtnSize: 70,
                                cancelColor:AppColors.black,
                              inputBorderRadius: BorderRadius.circular(10),

                              keyoardBtnBorderRadius: BorderRadius.circular(10),
                              //inputElevation: 3,
                              buttonFillColor: AppColors.white,
                              btnTextColor: AppColors.black,
                              buttonBorderColor: AppColors.grey,
                              spacing: AppUtils.deviceScreenSize(context).height * 0.06,
                              pinInputController: pinInputController,

                              onSubmit: () {
                                /// ignore: avoid_print
                                AppNavigator.pushAndStackPage(context,
                                    page:  ConfirmPin(pin:pinInputController.text));
                                print("Text is : " + pinInputController.text);
                              }, keyboardFontFamily: '',
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
