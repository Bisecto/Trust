import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/res/app_strings.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_router.dart';
import '../../utills/app_validator.dart';
import '../important_pages/dialog_box.dart';
import '../important_pages/not_found_page.dart';
import '../widgets/form_button.dart';
import '../widgets/form_input.dart';

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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: AppColors.lightShadowGreenColor,
      body: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (previous, current) => current is! AuthInitial,
          buildWhen: (previous, current) => current is! AuthInitial,
          listener: (context, state) {
            if (state is InitiatedLoginState) {
              MSG.snackBar(context, state.msg);

              AppNavigator.pushAndStackNamed(context,
                  name: AppRouter.signInWIthAccessPinBiometrics);
            } else if (state is ErrorState) {
              MSG.warningSnackBar(context, state.error);
            }  else if (state is VerificationContinueState) {
              AppNavigator.pushAndStackNamed(context,
                  name: AppRouter.otpVerification);
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
            // case PostsFetchingState:
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
              case AuthInitial || ErrorState:
                return
                   SingleChildScrollView(
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
                              height: AppUtils.deviceScreenSize(context).height * 0.5,
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
                                                  borderRadius: BorderRadius.circular(5),
                                                  border:
                                                  Border.all(color: AppColors.green)),
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
                            top: AppUtils.deviceScreenSize(context).height * 0.4,
                            bottom: AppUtils.deviceScreenSize(context).height * 0.1,
                            right: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                height: AppUtils.deviceScreenSize(context).height * 0.5,
                                width: AppUtils.deviceScreenSize(context).width,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SingleChildScrollView(
                                    physics: const NeverScrollableScrollPhysics(),

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          text: "Log In",
                                          weight: FontWeight.w600,
                                          size: 20,
                                        ),
                                        const CustomText(
                                          text: "See who is back",
                                          //weight: FontWeight.bold,
                                          size: 16,
                                        ),
                                        Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                CustomTextFormField(
                                                  hint: 'Email or Phone number',
                                                  label: '',
                                                  controller: _emailController,
                                                  validator:
                                                  AppValidator.validateTextfield,
                                                  icon: Icons.email,
                                                  borderColor: _emailController.text.isNotEmpty?AppColors.green:AppColors.grey,

                                                ),

                                                CustomTextFormField(
                                                  label: '',
                                                  isPasswordField: true,
                                                  validator:
                                                  AppValidator.validatePassword,
                                                  controller: _passwordController,
                                                  hint: 'Password',
                                                  icon: Icons.password,
                                                  borderColor: _passwordController.text.isNotEmpty?AppColors.green:AppColors.grey,

                                                ),

                                                FormButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      authBloc.add(InitiateSignInEventClick(_emailController.text,_passwordController.text));
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
                                        Center(
                                          child: CustomText(
                                            text: "Forgot Password?",
                                            color: AppColors.red,
                                            size: 16,

                                          ),
                                        ),
                                        // DividerWithTextWidget(text: "or login with"),
                                        const SizedBox(
                                          height: 10,
                                        ),
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
                  )
                  ;

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
