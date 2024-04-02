import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/create_pin.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../res/app_router.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../sign_in_with_access_pin_and_biometrics.dart';

class VerifyOtp extends StatefulWidget {
  String email;
  bool isRegister;

  VerifyOtp({super.key, required this.email, required this.isRegister});

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.lightShadowGreenColor,
      body: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (previous, current) => current is! AuthInitial,
          buildWhen: (previous, current) => current is! AuthInitial,
          listener: (context, state) async {
            if (state is AuthOtpRequestState) {
              MSG.snackBar(context, state.msg);
              // AppNavigator.pushAndStackNamed(context,
              //     name: AppRouter.otpPage);
            } else if (state is ErrorState) {
              MSG.warningSnackBar(context, state.error);
            } else if (state is AuthOtpVerifySucess) {
              MSG.snackBar(context, state.msg);
              if (widget.isRegister) {
                AppNavigator.pushAndStackPage(context, page: const CreatePin());
              } else {
                String userData=await SharedPref.getString('temUserData');
                String password=await SharedPref.getString('temUserPassword');
                authBloc.add(InitiateSignInEventClick(userData,password));
                //MSG.snackBar(context, state.msg);


              }
            } else if (state is InitiatedLoginState) {
              AppNavigator.pushAndStackPage(context,
                  page: SignInWIthAccessPinBiometrics(
                    userName: state.userName,
                  ));
              // AppNavigator.pushAndStackPage(context,
              // page: UserProfilePage(
              // email: state.userEmail,
              // ));
              // }
            } else if (state is AuthChangeDeviceOtpRequestState) {
              MSG.warningSnackBar(context, state.msg);
              AppNavigator.pushAndStackPage(context, page: VerifyOtp(email: state.email, isRegister: false,));
              //authBloc.add(VerificationContinueEvent());

              // MSG.snackBar(context, state.msg);
              //verifyAlertDialog(context);
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case (AuthInitial || ErrorState)||OTPRequestSuccessState:
                return SingleChildScrollView(
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
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fieldWidth: 50,
                                        controller: otpFieldController,
                                        style: const TextStyle(fontSize: 17),
                                        textFieldAlignment:
                                            MainAxisAlignment.spaceAround,
                                        fieldStyle: FieldStyle.box,
                                        otpFieldStyle: OtpFieldStyle(
                                          backgroundColor: AppColors.white,
                                          focusBorderColor: AppColors.green,
                                        ),
                                        onCompleted: (pin) async {
                                          //authBloc.add(VerifyOTPEventCLick(addedPin));
                                          setState(() {
                                            isCompleted = true;
                                            addedPin = pin;
                                          });
                                        },
                                      ),

                                      // DividerWithTextWidget(text: "or login with"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FormButton(
                                        onPressed: () {
                                          if (isCompleted) {
                                            print(addedPin);
                                            authBloc.add(VerifyOTPEventCLick(
                                                addedPin, widget.isRegister));
                                          } else {
                                            MSG.warningSnackBar(
                                                context, "OTP field is empty");
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
                                        textColor: AppColors.white,
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
                                                  // authBloc.add(RequestResetPasswordEventClick(
                                                  //     widget.email,false));
                                                  authBloc.add(
                                                      PasswordResetRequestOtpEventCLick(
                                                          widget.email));
                                                  setState(() {
                                                    _start = 59;
                                                    startTimer();
                                                  });
                                                } else {
                                                  MSG.warningSnackBar(context,
                                                      'Resend Code after 59s');
                                                }
                                              },
                                              onPress2: () {},
                                              size: 14,
                                              weight: FontWeight.w600,
                                              //color: const Color.fromARGB(255, 19, 48, 63),
                                              color2: AppColors.darkGreen,
                                              //text1: '',
                                              decoration:
                                                  TextDecoration.underline,
                                              text2: 'Resend code after',
                                              color: AppColors.black,
                                              text3: '  00:$_start s',
                                              text4: ''))
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
    );
  }

  String smsOTP = '';
  late Timer _timer;
  int _start = 59;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          //_start = 59;
          _timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
