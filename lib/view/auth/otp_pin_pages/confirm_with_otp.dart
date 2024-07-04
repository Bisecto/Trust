import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/utills/app_navigator.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../important_pages/dialog_box.dart';
import '../../widgets/app_custom_text.dart';

class ConfirmWithPin extends StatefulWidget {
  String title;
  BuildContext context;
  //final Function() onPressed;


  ConfirmWithPin(
      {super.key,
        required this.title,
        required this.context,    //required this.onPressed,
      });
  @override
  State<ConfirmWithPin> createState() => _ConfirmWithPinState();
}

class _ConfirmWithPinState extends State<ConfirmWithPin> {
  PinInputController pinInputController = PinInputController(length: 4);
  final AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
        //resizeToAvoidBottomInset: true,
        backgroundColor: theme.isDark
            ? AppColors.darkModeBackgroundColor
            : AppColors.lightShadowGreenColor,
        body: Container(
          height: AppUtils.deviceScreenSize(context).height,
          width: AppUtils.deviceScreenSize(context).width,
          decoration: BoxDecoration(
              color: theme.isDark
                  ? AppColors.darkModeBackgroundContainerColor
                  : AppColors.lightShadowGreenColor, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: widget.title,
                    weight: FontWeight.bold,
                    size: 16,
                    maxLines: 3,
                    color: theme.isDark
                        ? AppColors
                        .darkModeBackgroundMainTextColor
                        : AppColors.textColor,

                  ),
                  // const CustomText(
                  //   text: "Input your transaction pin to confirm purchase",
                  //   //weight: FontWeight.bold,
                  //   size: 16,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  PinPlusKeyBoardPackage(
                    keyboardButtonShape: KeyboardButtonShape.defaultShape,
                    inputShape: InputShape.defaultShape,
                    keyboardMaxWidth: AppUtils.deviceScreenSize(context).width,
                    inputHasBorder: true,
                    inputFillColor: theme.isDark?AppColors.black:AppColors.white,
                    inputHeight: 60,
                    inputWidth: 60,
                    keyboardBtnSize: 70,
                    //inputType: InputType.dash,
                    cancelColor: theme.isDark?AppColors.white:AppColors.black,
                    inputTextColor: theme.isDark?AppColors.white:AppColors.black,

                    inputBorderRadius: BorderRadius.circular(10),
                    doneButton: Icon(Icons.done,color: theme.isDark?AppColors.white:AppColors.black,),

                    keyoardBtnBorderRadius: BorderRadius.circular(10),
                    //inputElevation: 3,
                    buttonFillColor: theme.isDark?AppColors.black:AppColors.white,
                    btnTextColor:  theme.isDark?AppColors.white:AppColors.textColor,
                    buttonBorderColor: AppColors.grey,
                    spacing: AppUtils.deviceScreenSize(context).height * 0.06,
                    pinInputController: pinInputController,
                   // leftExtraInputWidget: SvgPicture.asset(AppIcons.biometric),

                    onSubmit: () async {
                      /// ignore: avoid_print
                      Navigator.pop(context, pinInputController.text);

                      //AppNavigator.pushAndStackPage(context, page: PurchaseReceipt());
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
