import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/confirm_pin.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_pin/confirm_pin.dart';

import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/appBar_widget.dart';
import '../../../widgets/app_custom_text.dart';



class ChangePinNew extends StatefulWidget {
  String oldPin;
   ChangePinNew({
    super.key,
    required this.oldPin
  });

  @override
  State<ChangePinNew> createState() => _ChangePinNewState();
}

class _ChangePinNewState extends State<ChangePinNew> {
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const CustomText(
                    text:
                    "This PIN authorises access, please enter your New PIN to change it.",
                    //weight: FontWeight.bold,
                    maxLines: 3,
                    size: 16,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PinPlusKeyBoardPackage(
                    keyboardButtonShape:
                    KeyboardButtonShape.defaultShape,
                    inputShape: InputShape.defaultShape,
                    keyboardMaxWidth:
                    AppUtils.deviceScreenSize(context)
                        .width,
                    inputHasBorder: true,
                    inputFillColor: AppColors.white,
                    inputHeight: 55,
                    inputWidth: 55,
                    keyboardBtnSize: 70,
                    cancelColor: AppColors.black,
                    inputBorderRadius:
                    BorderRadius.circular(10),

                    keyoardBtnBorderRadius:
                    BorderRadius.circular(10),
                    //inputElevation: 3,
                    buttonFillColor: AppColors.white,
                    btnTextColor: AppColors.black,
                    buttonBorderColor: AppColors.grey,
                    spacing:
                    AppUtils.deviceScreenSize(context)
                        .height *
                        0.06,
                    pinInputController: pinInputController,

                    onSubmit: () {
                      /// ignore: avoid_print
                      AppNavigator.pushAndStackPage(context, page: ChangeConfirmPin(pin: pinInputController.text, oldPin: widget.oldPin));
                      print("Text is : " +
                          pinInputController.text);
                    },
                    keyboardFontFamily: '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
