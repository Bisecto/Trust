import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/res/app_strings.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/auth/sign_in_with_access_pin_and_biometrics.dart';
import 'package:teller_trust/view/auth/sign_up_screen.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_router.dart';
import '../../utills/app_validator.dart';
import '../../utills/constants/loading_dialog.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../important_pages/dialog_box.dart';
import '../important_pages/not_found_page.dart';
import '../widgets/form_button.dart';
import '../widgets/form_input.dart';
import '../widgets/show_toast.dart';
import 'forgot_password/request_otp.dart';
import 'otp_pin_pages/create_pin.dart';
import 'otp_pin_pages/verify_otp.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
    SharedPref.remove("password");
    SharedPref.remove("email");
    SharedPref.remove("phone");
    SharedPref.remove("accessPin");
    SharedPref.remove("userId");
    SharedPref.remove("firstname");
    SharedPref.remove("lastname");
    SharedPref.remove("userData");
    SharedPref.remove("refresh-token");
    SharedPref.remove("access-token");
    SharedPref.remove("temUserData");
    SharedPref.remove("temUserPassword");
    SharedPref.remove("temUserPhone");
    super.initState();
  }

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
            if (state is InitiatedLoginState) {
              if (state.isBiometricPinSet) {
                //MSG.snackBar(context, state.msg);

                AppNavigator.pushAndStackPage(context,
                    page: SignInWIthAccessPinBiometrics(
                      userName: state.userName,
                    ));
                showToast(
                    context: context,
                    title: 'Successful',
                    subtitle: state.msg,
                    type: ToastMessageType.success);

              } else {
                // MSG.snackBar(context, "Logged in. You have not created an access PIN");

                AppNavigator.pushAndStackPage(context, page: const CreatePin());
                showToast(
                    context: context,
                    title: 'Info',
                    subtitle: "Logged in. You have not created an access PIN",
                    type: ToastMessageType.info);
              }
            }
            else if (state is AuthOtpRequestState) {
              //MSG.warningSnackBar(context, state.msg);
              // showToast(
              //     context: context,
              //     title: 'Info',
              //     subtitle: state.msg,
              //     type: ToastMessageType.info);
              // MSG.snackBar(context, state.msg);
              verifyAlertDialog(context,state.msg,theme);
            }else if (state is AuthChangeDeviceOtpRequestState) {

              //MSG.warningSnackBar(context, state.error);
              AppNavigator.pushAndStackPage(context,
                  page: VerifyOtp(
                    email: state.email,
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
            } else if (state is ErrorState) {
              showToast(
                  context: context,
                  title: 'Error Occurred',
                  subtitle: state.error,
                  type: ToastMessageType.error);

              //MSG.warningSnackBar(context, state.error);
            } else if (state is VerificationContinueState) {
              AppNavigator.pushAndStackPage(context,
                  page: VerifyOtp(
                    email: _emailController.text,
                    isRegister: true,
                  ));
              // AppNavigator.pushAndStackNamed(context,
              //     name: AppRouter.otpVerification);
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
                          top: AppUtils.deviceScreenSize(context).height * 0.35,
                          bottom:
                              AppUtils.deviceScreenSize(context).height * 0.1,
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
                                        text: "Log In",
                                        weight: FontWeight.w600,
                                        size: 20,
                                        color: theme.isDark
                                            ? AppColors
                                            .darkModeBackgroundMainTextColor
                                            : AppColors.textColor,
                                      ),
                                       CustomText(
                                        text: "See who is back",
                                        //weight: FontWeight.bold,
                                        size: 16,
                                        color: theme.isDark
                                            ? AppColors
                                            .darkModeBackgroundSubTextColor
                                            : AppColors.textColor,
                                      ),
                                      Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              CustomTextFormField(
                                                hint: 'Email or Phone number',
                                                label: '',
                                                controller: _emailController,
                                                validator: AppValidator
                                                    .validateTextfield,
                                                icon: Icons.email,
                                                borderColor: _emailController
                                                        .text.isNotEmpty
                                                    ? AppColors.green
                                                    : AppColors.grey,
                                              ),
                                              CustomTextFormField(
                                                label: '',
                                                isPasswordField: true,
                                                validator: AppValidator
                                                    .validatePassword,
                                                controller: _passwordController,
                                                hint: 'Password',
                                                icon: Icons.password,
                                                borderColor: _passwordController
                                                        .text.isNotEmpty
                                                    ? AppColors.green
                                                    : AppColors.grey,
                                              ),
                                              FormButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    authBloc.add(
                                                        InitiateSignInEventClick(
                                                            _emailController
                                                                .text,
                                                            _passwordController
                                                                .text,context));
                                                    // await Future.delayed(const Duration(seconds: 3));
                                                    //AppNavigator.pushNamedAndRemoveUntil(context, name: AppRouter.landingPage);
                                                  }
                                                },
                                                text: 'Continue',
                                                borderColor: AppColors.green,
                                                bgColor: AppColors.green,
                                                textColor: AppColors.white,
                                                borderRadius: 10,
                                              )
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AppNavigator.pushAndStackPage(context,
                                              page: RequestOtp());
                                        },
                                        child: const Center(
                                          child: CustomText(
                                            text: "Forgot Password?",
                                            color: AppColors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      // DividerWithTextWidget(text: "or login with"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              text: "New to TellaTrust?",
                                              color: theme.isDark
                                                  ? AppColors
                                                  .darkModeBackgroundSubTextColor
                                                  : AppColors.textColor,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                AppNavigator.pushAndStackPage(
                                                    context,
                                                    page: SignUpScreen());
                                              },
                                              child: CustomText(
                                                text: "Sign up?",
                                                color: theme.isDark
                                                    ? AppColors
                                                    .white
                                                    : AppColors.blue,
                                                weight: FontWeight.w700,
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
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
      String msg,    AdaptiveThemeMode theme,

      ) {
    showDialog(
        context: context,
        barrierDismissible:false,

        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: theme.isDark
                ? AppColors.darkModeBackgroundColor
                : AppColors.white,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
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
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   CustomText(
                    text: AppStrings.verifySomething,
                    weight: FontWeight.bold,
                    size: 18,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundMainTextColor
                        : AppColors.textColor,

                  ),
                  SizedBox(
                    height: 10,
                  ),
                   CustomText(
                    text: msg,
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
                  SizedBox(
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

  DividerWithTextWidget({required this.text});

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
