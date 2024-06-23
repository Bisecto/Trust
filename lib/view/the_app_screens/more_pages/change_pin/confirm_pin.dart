import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_router.dart';
import 'package:teller_trust/view/important_pages/dialog_box.dart';

import '../../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/custom_theme.dart';
import '../../../../utills/enums/toast_mesage.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/appBar_widget.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/show_toast.dart';


class ChangeConfirmPin extends StatefulWidget {
  final String pin;
  final String oldPin;

  const ChangeConfirmPin({super.key, required this.pin,required this.oldPin});

  @override
  State<ChangeConfirmPin> createState() => _ChangeConfirmPinState();
}

class _ChangeConfirmPinState extends State<ChangeConfirmPin> {
  OtpFieldController otpFieldController = OtpFieldController();
  PinInputController pinInputController = PinInputController(length: 4);
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
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
             CustomAppBar(
               title: "Change 4-digit Pin",
            ),
            BlocConsumer<AuthBloc, AuthState>(
                bloc: authBloc,
                listenWhen: (previous, current) => current is! AuthInitial,
                buildWhen: (previous, current) => current is AuthInitial,
                listener: (context, state) async {
                  if (state is ErrorState) {
                    showToast(
                        context: context,
                        title: 'Error',
                        subtitle: state.error,
                        type: ToastMessageType.error);
                    //MSG.warningSnackBar(context, state.error);
                  } else if (state is SuccessState) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    //MSG.snackBar(context, "4-Digit Access PIN");
                    showToast(
                        context: context,
                        title: 'Successful',
                        subtitle: "Changing 4-Digit Access PIN was successful",
                        type: ToastMessageType.success);
                    // welcomeAlertDialog(context);
                    // await Future.delayed(const Duration(seconds: 3));
                    // AppNavigator.pushNamedAndRemoveUntil(context,
                    //     name: AppRouter.landingPage);
                    // }
                  }
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case AuthInitial || ErrorState:
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          physics:
                          const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                               CustomText(
                                text:
                                "We will require this pin to sign you into the app",
                                //weight: FontWeight.bold,
                                size: 14,
                                maxLines: 3,
                                color: theme.isDark
                                    ? AppColors
                                    .darkModeBackgroundMainTextColor
                                    : AppColors.textColor,                              ),
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
                                pinInputController:
                                pinInputController,

                                onSubmit: () async {
                                  /// ignore: avoid_print
                                  if (widget.pin !=
                                      pinInputController.text) {
                                    showToast(
                                        context: context,
                                        title: 'Warning',
                                        subtitle: "PIN does not match",
                                        type: ToastMessageType.warning);
                                    // MSG.warningSnackBar(context,
                                    //     "Pin does not match");
                                  } else {
                                    authBloc.add(ChangePinEvent(
                                      widget.oldPin,
                                        widget.pin,
                                        pinInputController.text,context));
                                  }
                                  print(
                                      "Text is : ${pinInputController.text}");
                                },
                                keyboardFontFamily: '',
                              ),
                            ],
                          ),
                        ),
                      );
                    // case LoadingState:
                    //   return const Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    default:
                      return const Center(
                        child: NotFoundPage(),
                      );
                  }
                }),
          ],
        ));
  }

}
