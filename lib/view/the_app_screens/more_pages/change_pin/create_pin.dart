import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';

import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_pin/confirm_pin.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/custom_theme.dart';
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

    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
      theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,

      body: Column(
        children: [
          const CustomAppBar(
            title: "Change 4-digit Pin",

          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                   CustomText(
                    text:
                    "This PIN authorises access, please enter your New PIN to change it.",
                    //weight: FontWeight.bold,

                    size: 14,
                    maxLines: 3,
                    color: theme.isDark
                        ? AppColors
                        .darkModeBackgroundMainTextColor
                        : AppColors.textColor,
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
                    inputFillColor: theme.isDark?AppColors.black:AppColors.white,
                    inputHeight: 55,
                    inputWidth: 55,
                    keyboardBtnSize: 70,
                    cancelColor: theme.isDark?AppColors.white:AppColors.black,
                    inputTextColor: theme.isDark?AppColors.white:AppColors.black,
                    inputBorderRadius:
                    BorderRadius.circular(10),
                    doneButton: Icon(Icons.done,color: theme.isDark?AppColors.white:AppColors.black,),
                    buttonFillColor: theme.isDark?AppColors.black:AppColors.white,
                    btnTextColor:  theme.isDark?AppColors.white:AppColors.textColor,

                    keyoardBtnBorderRadius:
                    BorderRadius.circular(10),
                    //inputElevation: 3,
                    buttonBorderColor: AppColors.grey,
                    spacing:
                    AppUtils.deviceScreenSize(context)
                        .height *
                        0.06,
                    pinInputController: pinInputController,

                    onSubmit: () {
                      /// ignore: avoid_print
                      AppNavigator.pushAndStackPage(context, page: ChangeConfirmPin(pin: pinInputController.text, oldPin: widget.oldPin));
                      print("Text is : ${pinInputController.text}");
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
