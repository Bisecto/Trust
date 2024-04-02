import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/confirm_pin.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_pin/create_pin.dart';
import 'package:teller_trust/view/widgets/appBar_widget.dart';

import '../../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/app_custom_text.dart';

class OldPin extends StatefulWidget {
  const OldPin({
    super.key,
  });

  @override
  State<OldPin> createState() => _OldPinState();
}

class _OldPinState extends State<OldPin> {
  OtpFieldController otpFieldController = OtpFieldController();
  PinInputController pinInputController = PinInputController(length: 4);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const CustomAppBar(
            title: AppIcons.change4DigitPassword,
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text:
                          "This PIN authorises access, please enter your old PIN to change it.",
                      //weight: FontWeight.bold,
                      size: 16,
                      maxLines: 3,

                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PinPlusKeyBoardPackage(
                      keyboardButtonShape: KeyboardButtonShape.defaultShape,
                      inputShape: InputShape.defaultShape,
                      keyboardMaxWidth:
                          AppUtils.deviceScreenSize(context).width,
                      inputHasBorder: true,
                      inputFillColor: AppColors.white,
                      inputHeight: 55,
                      inputWidth: 55,
                      keyboardBtnSize: 70,
                      cancelColor: AppColors.black,
                      inputBorderRadius: BorderRadius.circular(10),

                      keyoardBtnBorderRadius: BorderRadius.circular(10),
                      //inputElevation: 3,
                      buttonFillColor: AppColors.white,
                      btnTextColor: AppColors.black,
                      buttonBorderColor: AppColors.grey,
                      spacing: AppUtils.deviceScreenSize(context).height * 0.06,
                      pinInputController: pinInputController,

                      onSubmit: () {
                        AppNavigator.pushAndStackPage(context, page: ChangePinNew(oldPin: pinInputController.text));
                        /// ignore: avoid_print
                        //authBloc.add(VerificationContinueEvent());
                        print("Text is : " + pinInputController.text);
                      },
                      keyboardFontFamily: '',
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
