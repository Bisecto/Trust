import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/create_pin.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/show_toast.dart';
import '../sign_in_with_access_pin_and_biometrics.dart';

class VerifyOtp extends StatefulWidget {
  String phone;
  bool isRegister;

  VerifyOtp({super.key, required this.phone, required this.isRegister});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  OtpFieldController otpFieldController = OtpFieldController();
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
    startTimer();
    super.initState();
  }

  bool isCompleted = false;
  String addedPin = '';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.isDark
          ? AppColors.darkModeBackgroundColor
          : AppColors.lightShadowGreenColor,
      body: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (previous, current) => current is! AuthInitial,
          buildWhen: (previous, current) => current is AuthInitial,
          listener: (context, state) async {
            if (state is AuthOtpRequestState) {
              //MSG.snackBar(context, state.msg);
              showToast(
                  context: context,
                  title: 'Info',
                  subtitle: state.msg,
                  type: ToastMessageType.info);
              // AppNavigator.pushAndStackNamed(context,
              //     name: AppRouter.otpPage);
            } else if (state is ErrorState) {
              showToast(
                  context: context,
                  title: 'Error',
                  subtitle: state.error,
                  type: ToastMessageType.error);
            } else if (state is AuthOtpVerifySucess) {
              // MSG.snackBar(context, state.msg);
              if (widget.isRegister) {
                AppNavigator.pushAndStackPage(context, page: const CreatePin());
              } else {
                String userData = await SharedPref.getString('temUserData');
                String password = await SharedPref.getString('temUserPassword');
                authBloc
                    .add(InitiateSignInEventClick(userData, password, context));
                //MSG.snackBar(context, state.msg);
              }
            } else if (state is InitiatedLoginState) {
              AppNavigator.pushAndStackPage(context,
                  page: SignInWIthAccessPinBiometrics(
                    userName: state.userName,
                  ));
              // AppNavigator.pushAndStackPage(context,
              // page: UserProfilePage(
              // phone: state.userphone,
              // ));
              // }
            } else if (state is AuthChangeDeviceOtpRequestState) {
              // MSG.warningSnackBar(context, state.msg);
              AppNavigator.pushAndStackPage(context,
                  page: VerifyOtp(
                    phone: state.phone,
                    isRegister: false,
                  ));
              showToast(
                  context: context,
                  title: 'Info',
                  subtitle: state.msg,
                  type: ToastMessageType.info);
              //authBloc.add(VerificationContinueEvent());

              // MSG.snackBar(context, state.msg);
              //verifyAlertDialog(context);
            } else if (state is OTPRequestSuccessState) {
              showToast(
                  context: context,
                  title: 'Info',
                  subtitle: state.msg,
                  type: ToastMessageType.info);
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case (AuthInitial || ErrorState):
                return SingleChildScrollView(
                  child: SizedBox(
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
                            height:
                                AppUtils.deviceScreenSize(context).height * 0.5,
                            width: AppUtils.deviceScreenSize(context).width,
                            decoration: const BoxDecoration(
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: AppColors.green)),
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
                          top: AppUtils.deviceScreenSize(context).height * 0.3,
                          bottom:
                              AppUtils.deviceScreenSize(context).height * 0.3,
                          right: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              height:
                                  AppUtils.deviceScreenSize(context).height *
                                      0.5,
                              width: AppUtils.deviceScreenSize(context).width,
                              decoration: BoxDecoration(
                                  color: theme.isDark
                                      ? AppColors
                                          .darkModeBackgroundContainerColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "OTP Verification",
                                        weight: FontWeight.w600,
                                        size: 20,
                                        color: theme.isDark
                                            ? AppColors
                                                .darkModeBackgroundMainTextColor
                                            : AppColors.textColor,
                                      ),
                                      CustomText(
                                        text:
                                            "Input 5 digit code sent to ${widget.phone}",
                                        //weight: FontWeight.bold,
                                        color: theme.isDark
                                            ? AppColors
                                                .darkModeBackgroundSubTextColor
                                            : AppColors.textColor,
                                        size: 16,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      OTPTextField(
                                        length: 5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fieldWidth: 50,
                                        controller: otpFieldController,
                                        style: const TextStyle(fontSize: 17),
                                        textFieldAlignment:
                                            MainAxisAlignment.spaceAround,
                                        fieldStyle: FieldStyle.box,
                                        otpFieldStyle: OtpFieldStyle(
                                          backgroundColor: theme.isDark
                                              ? AppColors
                                                  .darkModeBackgroundContainerColor
                                              : AppColors.white,
                                          focusBorderColor: AppColors.green,
                                          //borderColor: AppColors.red
                                        ),
                                        onChanged: (pin) {
                                          if (pin.length > 4) {
                                            setState(() {
                                              isCompleted = true;
                                              addedPin = pin;
                                            });
                                          } else {
                                            setState(() {
                                              isCompleted = false;
                                              addedPin = pin;
                                            });
                                          }
                                        },
                                        // onCompleted: (pin) async {
                                        //   //authBloc.add(VerifyOTPEventCLick(addedPin));
                                        //   setState(() {
                                        //     isCompleted = true;
                                        //     addedPin = pin;
                                        //   });
                                        // },
                                      ),

                                      // DividerWithTextWidget(text: "or login with"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FormButton(
                                        onPressed: () {
                                          if (isCompleted) {
                                            print(addedPin);
                                            //AppNavigator.pushAndStackPage(context, page: const CreatePin());

                                            authBloc.add(VerifyOTPEventCLick(
                                                addedPin,
                                                widget.isRegister,
                                                context));
                                          } else {
                                            showToast(
                                                context: context,
                                                title: 'Warning',
                                                subtitle: "OTP field is empty",
                                                type: ToastMessageType.warning);
                                            // MSG.warningSnackBar(
                                            //     context, "OTP field is empty");
                                          }

                                          //  //if(otpFieldController.)
                                          // AppNavigator.pushAndStackPage(context,
                                          //     page: const CreatePin());
                                          // // if (!_formKey.currentState!
                                          // //     .validate()) {
                                          // //   //verifyAlertDialog(context);
                                          // // }
                                        },
                                        text: 'Continue',
                                        borderColor: AppColors.green,
                                        bgColor: AppColors.green,
                                        textColor: !isCompleted
                                            ? AppColors.textColor
                                            : AppColors.white,
                                        borderRadius: 10,
                                        disableButton: !isCompleted,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: TextStyles.richTexts(
                                              onPress1: () {
                                                if (_start == 0) {
                                                  authBloc.add(
                                                      PasswordResetRequestOtpEventCLick(widget.phone, context)
                                                  );
                                                  setState(() {
                                                    _start = 180; // Reset the timer to 180 seconds
                                                    startTimer();
                                                  });
                                                } else {
                                                  setState(() {
                                                    MSG.warningSnackBar(context, 'Resend Code after 3:00 minutes');
                                                  });
                                                }
                                              },
                                              onPress2: () {
                                                if (_start == 0) {
                                                  authBloc.add(
                                                      PasswordResetRequestOtpEventCLick(widget.phone, context)
                                                  );
                                                  setState(() {
                                                    _start = 180; // Reset the timer to 180 seconds
                                                    startTimer();
                                                  });
                                                } else {
                                                  MSG.warningSnackBar(context, 'Resend Code after 3:00 minutes');
                                                }
                                              },
                                              size: 14,
                                              weight: FontWeight.w600,
                                              color2: AppColors.darkGreen,
                                              decoration: TextDecoration.underline,
                                              text2: 'Resend code after',
                                              color: AppColors.black,
                                              text3: '  ${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')} minutes',
                                              text4: ''
                                          )
                                      )                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
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
    );
  }

  String smsOTP = '';
  late Timer _timer;
  int _start = 180;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          _timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }}
