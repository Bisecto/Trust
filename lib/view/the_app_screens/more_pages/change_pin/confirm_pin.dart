import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:teller_trust/res/app_router.dart';
import 'package:teller_trust/view/important_pages/dialog_box.dart';

import '../../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../utills/app_utils.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/appBar_widget.dart';
import '../../../widgets/app_custom_text.dart';


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
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        body: Column(
          children: [
             CustomAppBar(
              title: AppIcons.change4DigitPassword,
            ),
            BlocConsumer<AuthBloc, AuthState>(
                bloc: authBloc,
                listenWhen: (previous, current) => current is! AuthInitial,
                buildWhen: (previous, current) => current is! AuthInitial,
                listener: (context, state) async {
                  if (state is ErrorState) {
                    MSG.warningSnackBar(context, state.error);
                  } else if (state is SuccessState) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    MSG.snackBar(context, "4-Digit Access PIN");
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

                              const CustomText(
                                text:
                                "We will require this pin to sign you into the app",
                                //weight: FontWeight.bold,
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
                                pinInputController:
                                pinInputController,

                                onSubmit: () async {
                                  /// ignore: avoid_print
                                  if (widget.pin !=
                                      pinInputController.text) {
                                    MSG.warningSnackBar(context,
                                        "Pin does not match");
                                  } else {
                                    authBloc.add(ChangePinEvent(
                                      widget.oldPin,
                                        widget.pin,
                                        pinInputController.text));
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
                    case LoadingState:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
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
