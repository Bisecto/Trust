import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/view/auth/forgot_password/reset_password.dart';
import 'package:teller_trust/view/auth/otp_pin_pages/create_pin.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../res/app_router.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';
import '../../widgets/show_toast.dart';

class RequestOtp extends StatefulWidget {
  RequestOtp({
    super.key,
  });

  @override
  State<RequestOtp> createState() => _RequestOtpState();
}

class _RequestOtpState extends State<RequestOtp> {
  final AuthBloc authBloc = AuthBloc();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
    super.initState();
  }

  bool isCompleted = false;
  String addedPin = '';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:theme.isDark? Brightness
          .light:Brightness.dark, // Brightness.light for white icons, Brightness.dark for dark icons
    ));
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
            if (state is OTPRequestSuccessState) {
              //MSG.snackBar(context, state.msg);
              AppNavigator.pushAndStackPage(context,
                  page: ResetPassword(
                    email: _emailController.text,
                  ));
              showToast(
                  context: context,
                  title: 'Success',
                  subtitle: state.msg,
                  type: ToastMessageType.success);
            } else if (state is ErrorState) {
              //MSG.warningSnackBar(context, state.error);
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
                            decoration: BoxDecoration(
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
                                        text: "Forgot Password",
                                        weight: FontWeight.w600,
                                        size: 20,
                                        color: theme.isDark
                                            ? AppColors
                                            .darkModeBackgroundMainTextColor
                                            : AppColors.textColor,
                                      ),
                                      CustomText(
                                        text:
                                            "Enter your email or phone number to enable you rest your password",
                                        //weight: FontWeight.bold,
                                        size: 16,
                                        color: theme.isDark
                                            ? AppColors
                                            .darkModeBackgroundSubTextColor
                                            : AppColors.textColor,
                                      ),
                                      const SizedBox(
                                        height: 10,
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
                                                widget: Icon(Icons.email),
                                                borderColor: _emailController
                                                        .text.isNotEmpty
                                                    ? AppColors.green
                                                    : AppColors.grey,
                                              ),
                                              FormButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    authBloc.add(
                                                        PasswordResetRequestOtpEventCLick(
                                                            _emailController
                                                                .text,
                                                            context));
                                                    // await Future.delayed(const Duration(seconds: 3));
                                                    //AppNavigator.pushNamedAndRemoveUntil(context, name: AppRouter.landingPage);
                                                  }

                                                  // if (isCompleted) {
                                                  //   print(addedPin);
                                                  //   authBloc.add(
                                                  //       PasswordResetRequestOtpEventCLick(_emailController.text));
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
                                                textColor: AppColors.white,
                                                borderRadius: 10,
                                                //disableButton: !isCompleted,
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
