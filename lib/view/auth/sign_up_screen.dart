import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/verify_otp.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_strings.dart';
import '../../utills/app_validator.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../important_pages/not_found_page.dart';
import '../widgets/form_button.dart';
import '../widgets/form_input.dart';
import '../widgets/show_toast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _surNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
    super.initState();
  }

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
            if (state is AuthOtpRequestState) {
              // MSG.snackBar(context, state.msg);
              verifyAlertDialog(context, state.msg, theme);
              // showToast(
              //     context: context,
              //     title: 'Info',
              //     subtitle: state.error,
              //     type: ToastMessageType.error);
              // AppNavigator.pushAndStackNamed(context,
              //     name: AppRouter.otpPage);
            } else if (state is ErrorState) {
              showToast(
                  context: context,
                  title: 'Error',
                  subtitle: state.error,
                  type: ToastMessageType.error);
            } else if (state is VerificationContinueState) {
              AppNavigator.pushAndStackPage(context,
                  page: VerifyOtp(
                      email: _emailController.text, isRegister: true));
              // AppNavigator.pushAndStackNamed(context,
              //     name: AppRouter.otpVerification);
            } else if (state is SuccessState) {
              // AppNavigator.pushAndStackPage(context,
              // page: UserProfilePage(
              // email: state.userEmail,
              // ));
              // }
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              // case PostsFetchingState:
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              case AuthInitial || ErrorState:
                return SingleChildScrollView(
                  child: SizedBox(
                    height: AppUtils.deviceScreenSize(context).height,
                    width: AppUtils.deviceScreenSize(context).width,
                    child: Stack(
                      //alignment: Alignment.,
                      children: [
                        Positioned(
                          top: 20,
                          right: 0,
                          left: 5,
                          //top: 20,
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
                          top: AppUtils.deviceScreenSize(context).height * 0.25,
                          bottom: 20,
                          right: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              //height: AppUtils.deviceScreenSize(context).height * 0.7,
                              width: AppUtils.deviceScreenSize(context).width,
                              decoration: BoxDecoration(
                                  color: theme.isDark
                                      ? AppColors
                                          .darkModeBackgroundContainerColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: AppUtils.deviceScreenSize(context)
                                              .height *
                                          0.08,
                                      top: 0,
                                      right: 0,
                                      left: 0,
                                      child: SingleChildScrollView(
                                        //controller: ScrollController(),
                                        physics: const ScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: "Sign Up",
                                              weight: FontWeight.w600,
                                              size: 20,
                                              color: theme.isDark
                                                  ? AppColors
                                                      .darkModeBackgroundMainTextColor
                                                  : AppColors.textColor,
                                            ),
                                            CustomText(
                                              text:
                                                  "Create an account to enable you pay bills",
                                              //weight: FontWeight.bold,
                                              size: 14,
                                              maxLines: 2,
                                              color: theme.isDark
                                                  ? AppColors
                                                      .darkModeBackgroundSubTextColor
                                                  : AppColors.textColor,
                                            ),

                                            // ),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //   children: [
                                            //     GestureDetector(
                                            //       onTap: () {
                                            //         //Navigator.pop(context);
                                            //       },
                                            //       child: Container(
                                            //         height: 50,
                                            //         width: AppUtils.deviceScreenSize(context).width /
                                            //             2.5,
                                            //         decoration: const BoxDecoration(
                                            //           image: DecorationImage(
                                            //             image: AssetImage(AppImages.Google),
                                            //             fit: BoxFit.fill,
                                            //           ),
                                            //         ),
                                            //         // child: const Icon(Icons.arrow_back),
                                            //       ),
                                            //     ),
                                            //     GestureDetector(
                                            //       onTap: () {
                                            //         //Navigator.pop(context);
                                            //       },
                                            //       child: Container(
                                            //         height: 50,
                                            //         width: AppUtils.deviceScreenSize(context).width /
                                            //             2.5,
                                            //         decoration: const BoxDecoration(
                                            //           image: DecorationImage(
                                            //             image: AssetImage(AppImages.apple),
                                            //             fit: BoxFit.fill,
                                            //           ),
                                            //         ),
                                            //         // child: const Icon(Icons.arrow_back),
                                            //       ),
                                            //     )
                                            //   ],
                                            // ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                            // DividerWithTextWidget(text: "or signup with"),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                            Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    CustomTextFormField(
                                                      hint: 'First Name',
                                                      label: '',
                                                      controller:
                                                          _firstNameController,
                                                      validator: AppValidator
                                                          .validateTextfield,
                                                      widget: const Icon(Icons
                                                          .person_2_outlined),
                                                      borderColor:
                                                          _firstNameController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? AppColors.green
                                                              : AppColors.grey,
                                                      // backgroundColor: ,
                                                    ),
                                                    CustomTextFormField(
                                                      hint: 'Middle Name',
                                                      label: '',
                                                      controller:
                                                          _middleNameController,
                                                      // validator: AppValidator
                                                      //     .validateTextfield,
                                                      widget: const Icon(Icons
                                                          .person_2_outlined),
                                                      borderColor:
                                                          _middleNameController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? AppColors.green
                                                              : AppColors.grey,
                                                    ),
                                                    CustomTextFormField(
                                                      hint: 'Surname',
                                                      label: '',
                                                      controller:
                                                          _surNameController,
                                                      validator: AppValidator
                                                          .validateTextfield,
                                                      widget: const Icon(Icons
                                                          .person_2_outlined),
                                                      borderColor:
                                                          _surNameController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? AppColors.green
                                                              : AppColors.grey,
                                                    ),
                                                    CustomTextFormField(
                                                      hint: 'Email',
                                                      label: '',
                                                      controller:
                                                          _emailController,
                                                      validator: AppValidator
                                                          .validateEmail,
                                                      widget:
                                                          const Icon(Icons.email_outlined),
                                                      borderColor:
                                                          _emailController.text
                                                                  .isNotEmpty
                                                              ? AppColors.green
                                                              : AppColors.grey,
                                                    ),
                                                    CustomTextFormField(
                                                      hint: 'Phone Number',
                                                      label: '',
                                                      controller:
                                                          _phoneController,
                                                      validator: AppValidator
                                                          .validateTextfield,
                                                      widget: const Icon(Icons
                                                          .local_phone_outlined),
                                                      borderColor:
                                                          _phoneController.text
                                                                  .isNotEmpty
                                                              ? AppColors.green
                                                              : AppColors.grey,
                                                    ),
                                                    CustomTextFormField(
                                                      label: '',
                                                      isPasswordField: true,
                                                      validator: AppValidator
                                                          .validatePassword,
                                                      controller:
                                                          _passwordController,
                                                      hint: 'Password',
                                                      widget: const Icon(Icons.lock_outline),
                                                      borderColor:
                                                          _passwordController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? AppColors.green
                                                              : AppColors.grey,
                                                      isobscure: true,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
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
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      top: AppUtils.deviceScreenSize(context)
                                              .height *
                                          0.59,
                                      right: 0,
                                      left: 0,
                                      child: FormButton(
                                        onPressed: () {
                                          //verifyAlertDialog(context, "state.msg", theme);

                                          if (_formKey.currentState!
                                              .validate()) {
                                            //User user=
                                            Map<String, dynamic> user = {
                                              "firstName":
                                                  _firstNameController.text,
                                              "middleName":
                                                  _middleNameController.text,
                                              "lastName":
                                                  _surNameController.text,
                                              "email": _emailController.text,
                                              "phone": _phoneController.text,
                                              "password":
                                                  _passwordController.text,
                                              "confirmPassword":
                                                  _passwordController.text,
                                            };

                                            if (kDebugMode) {
                                              print(user);
                                            }
                                            authBloc.add(SignUpEventClick(
                                                user, context));
                                            //verifyAlertDialog(context);
                                          }
                                        },
                                        text: 'Continue',
                                        borderColor: AppColors.green,
                                        bgColor: AppColors.green,
                                        textColor: theme.isDark
                                            ? AppColors.darkModeBackgroundColor
                                            : AppColors.white,
                                        borderRadius: 10,
                                        //disableButton: !_formKey.currentState!.validate(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );

              // case AuthOtpRequestState:
              //   final otpData = state as AuthOtpRequestState;
              //   return Center(
              //     child: ,
              //   );
              // return OTPPage(
              // email: otpData.email,
              // otpReason: 'account_verification',
              // );
              // case UpdateUserProfileState:
              // final profileState = state as UpdateUserProfileState;
              //
              // return UserProfilePage(
              // email: profileState.userEmail,
              // );
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

  verifyAlertDialog(
    BuildContext context,
    String msg,
    AdaptiveThemeMode theme,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: theme.isDark
                ? AppColors.darkModeBackgroundColor
                : AppColors.white,
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: Container(
              decoration: BoxDecoration(
                  color: theme.isDark
                      ? AppColors.darkModeBackgroundContainerColor
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppUtils.deviceScreenSize(context).width,
                    height: 150,
                    decoration:  BoxDecoration(
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundContainerColor
                            : AppColors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            theme.isDark? AppImages.verifyAlertDialogDarkImage:AppImages.verifyAlertDialogImage,
                          ),
                          fit: BoxFit.fill,
                        ),
                        //color: AppColors.red,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   CustomText(
                    text: AppStrings.verifySomething,
                    weight: FontWeight.bold,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundMainTextColor
                        : AppColors.textColor,
                    size: 18,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: msg,
                    //AppStrings.verifySomethingDescription,
                    // weight: FontWeight.bold,
                    size: 16,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundSubTextColor
                        : AppColors.textColor,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 20, 0),
                    child: FormButton(
                      onPressed: () {
                        authBloc.add(VerificationContinueEvent(context));
                      },
                      height: 50,
                      // width: AppUtils.deviceScreenSize(context).width / 2.5,
                      text: 'Continue',
                      borderColor: AppColors.green,
                      bgColor: AppColors.green,
                      textColor:theme.isDark
                          ? AppColors.darkModeBackgroundContainerColor: AppColors.white,
                      borderRadius: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        });
  }
}

class DividerWithTextWidget extends StatelessWidget {
  final String text;

  const DividerWithTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: const Divider(height: 2, thickness: 1),
    ));

    return Row(children: [line, CustomText(text: text), line]);
  }
}
