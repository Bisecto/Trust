import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/view/auth/sign_in_screen.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';
import '../../widgets/show_toast.dart';

class ResetPassword extends StatefulWidget {
  String email;

  ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthBloc authBloc = AuthBloc();
  final _formKey = GlobalKey<FormState>();
  OtpFieldController otpFieldController = OtpFieldController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
    super.initState();
  }

  bool isCompleted = false;
  String addedPin = '';
  bool onPasswordValidated = false;

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
          listener: (context, state) {
            if (state is PasswordResetSuccessState) {
              // MSG.snackBar(context, state.msg);

              AppNavigator.pushAndStackPage(context, page: const SignInScreen());
              showToast(
                  context: context,
                  title: 'Successful',
                  subtitle: state.msg,
                  type: ToastMessageType.success);
            } else if (state is ErrorState) {
              showToast(
                  context: context,
                  title: 'Error',
                  subtitle: state.error,
                  type: ToastMessageType.error);
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case AuthInitial || ErrorState:
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
                          top: AppUtils.deviceScreenSize(context).height * 0.2,
                          bottom:
                              AppUtils.deviceScreenSize(context).height * 0.15,
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
                                  //physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: "Reset Password",
                                        weight: FontWeight.w600,
                                        size: 20,
                                        color: theme.isDark
                                            ? AppColors
                                                .darkModeBackgroundMainTextColor
                                            : AppColors.textColor,
                                      ),
                                      // CustomText(
                                      //   text:
                                      //   "Enter your email or phone number to enable you rest your password",
                                      //   //weight: FontWeight.bold,
                                      //   size: 16,
                                      // ),
                                      OTPTextField(
                                        length: 5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fieldWidth: 50,
                                        controller: otpFieldController,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: theme.isDark
                                                ? AppColors.white
                                                : AppColors.black),
                                        textFieldAlignment:
                                            MainAxisAlignment.spaceAround,
                                        fieldStyle: FieldStyle.box,
                                        otpFieldStyle: OtpFieldStyle(
                                          backgroundColor: theme.isDark
                                              ? AppColors.black
                                              : AppColors.white,
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

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              CustomTextFormField(
                                                label: '',
                                                isPasswordField: true,
                                                validator: AppValidator
                                                    .validatePassword,
                                                controller: _passwordController,
                                                hint: 'New Password',
                                                widget: const Icon(Icons.password),
                                                borderColor: _passwordController
                                                        .text.isNotEmpty
                                                    ? AppColors.green
                                                    : AppColors.grey,
                                              ),
                                              CustomTextFormField(
                                                label: '',
                                                isPasswordField: true,
                                                validator: AppValidator
                                                    .validatePassword,
                                                controller:
                                                    _confirmPasswordController,
                                                hint: 'Confirm New Password',
                                                widget: const Icon(Icons.password),
                                                borderColor:
                                                    _confirmPasswordController
                                                            .text.isNotEmpty
                                                        ? AppColors.green
                                                        : AppColors.grey,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: FlutterPwValidator(
                                                  controller:
                                                      _passwordController,
                                                  minLength: 8,
                                                  uppercaseCharCount: 1,
                                                  numericCharCount: 1,
                                                  specialCharCount: 1,
                                                  width: 400,
                                                  height: 150,
                                                  onSuccess: () {
                                                    setState(() {
                                                      onPasswordValidated =
                                                          true;
                                                    });
                                                  },
                                                  onFail: () {
                                                    setState(() {
                                                      onPasswordValidated =
                                                          false;
                                                    });
                                                  },
                                                ),
                                              ),
                                              FormButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    authBloc.add(ResetPasswordEvent(
                                                        widget.email,
                                                        addedPin,
                                                        _passwordController
                                                            .text,
                                                        _confirmPasswordController
                                                            .text,
                                                        context));
                                                    // await Future.delayed(const Duration(seconds: 3));
                                                    //AppNavigator.pushNamedAndRemoveUntil(context, name: AppRouter.landingPage);
                                                  }

                                                  // if (isCompleted) {
                                                  //   print(addedPin);
                                                  //   authBloc.add(
                                                  //       PasswordResetResetPasswordEventCLick(_emailController.text));
                                                  // } else {
                                                  //   MSG.warningSnackBar(
                                                  //       context, "OTP field is empty");
                                                  // }

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
                                            ],
                                          )),
                                      // DividerWithTextWidget(text: "or login with"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
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
}
