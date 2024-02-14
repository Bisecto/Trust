import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:teller_trust/utills/app_navigator.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../important_pages/dialog_box.dart';
import '../../the_app_screens/sevices/purchase_receipt.dart';
import '../../widgets/app_custom_text.dart';

class ConfirmWithPin extends StatefulWidget {
  const ConfirmWithPin({super.key});

  @override
  State<ConfirmWithPin> createState() => _ConfirmWithPinState();
}

class _ConfirmWithPinState extends State<ConfirmWithPin> {
  OtpFieldController otpFieldController = OtpFieldController();
  PinInputController pinInputController = PinInputController(length: 4);
  final AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: AppUtils.deviceScreenSize(context).height,
          width: AppUtils.deviceScreenSize(context).width,
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const CustomText(
                  //   text: "Confirm Your Security Pin",
                  //   weight: FontWeight.w600,
                  //   size: 20,
                  // ),
                  const CustomText(
                    text: "Input your transaction pin to confirm purchase",
                    //weight: FontWeight.bold,
                    size: 16,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PinPlusKeyBoardPackage(
                    keyboardButtonShape: KeyboardButtonShape.defaultShape,
                    inputShape: InputShape.defaultShape,
                    keyboardMaxWidth: AppUtils.deviceScreenSize(context).width,
                    inputHasBorder: true,
                    inputFillColor: AppColors.white,
                    inputHeight: 60,
                    inputWidth: 60,
                    keyboardBtnSize: 70,
                    //inputType: InputType.dash,
                    cancelColor: AppColors.black,
                    inputBorderRadius: BorderRadius.circular(10),

                    keyoardBtnBorderRadius: BorderRadius.circular(10),
                    //inputElevation: 3,
                    buttonFillColor: AppColors.white,
                    btnTextColor: AppColors.black,
                    buttonBorderColor: AppColors.grey,
                    spacing: AppUtils.deviceScreenSize(context).height * 0.06,
                    pinInputController: pinInputController,
                   // leftExtraInputWidget: SvgPicture.asset(AppIcons.biometric),

                    onSubmit: () async {
                      /// ignore: avoid_print
                      AppNavigator.pushAndStackPage(context, page: PurchaseReceipt());
                      print("Text is : ${pinInputController.text}");
                    },
                    keyboardFontFamily: '',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
