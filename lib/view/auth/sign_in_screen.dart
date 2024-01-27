import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/res/app_strings.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../utills/app_validator.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: AppColors.lightShadowGreenColor,
      body: SingleChildScrollView(
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
                top: AppUtils.deviceScreenSize(context).height * 0.3,
                bottom: AppUtils.deviceScreenSize(context).height * 0.2,
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
                                      hint: 'Email',
                                      label: '',
                                      controller: _emailController,
                                      validator:
                                      AppValidator.validateEmail,
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
      ),
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
