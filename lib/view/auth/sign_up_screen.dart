
import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../res/app_router.dart';
import '../../res/app_strings.dart';
import '../../utills/app_validator.dart';
import '../widgets/form_button.dart';
import '../widgets/form_input.dart';

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
                right: 20,
                left: 5,
                //top: 20,
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
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: AppUtils.deviceScreenSize(context).height *
                                0.08,
                            top: 0,
                            right: 0,
                            left: 0,
                            child: SingleChildScrollView(
                              physics: const ScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    text: "Sign Up",
                                    weight: FontWeight.w600,
                                    size: 20,
                                  ),
                                  const CustomText(
                                    text:
                                        "Create an account to enable you pay bills",
                                    //weight: FontWeight.bold,
                                    size: 16,
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
                                            controller: _firstNameController,
                                            validator:
                                                AppValidator.validateTextfield,
                                            icon: Icons.person_2_outlined,
                                            borderColor: _firstNameController
                                                    .text.isNotEmpty
                                                ? AppColors.green
                                                : AppColors.grey,
                                          ),
                                          CustomTextFormField(
                                            hint: 'Middle Name',
                                            label: '',
                                            controller: _middleNameController,
                                            validator:
                                                AppValidator.validateTextfield,
                                            icon: Icons.person_2_outlined,
                                            borderColor: _middleNameController
                                                    .text.isNotEmpty
                                                ? AppColors.green
                                                : AppColors.grey,
                                          ),
                                          CustomTextFormField(
                                            hint: 'Surname',
                                            label: '',
                                            controller: _surNameController,
                                            validator:
                                                AppValidator.validateTextfield,
                                            icon: Icons.person_2_outlined,
                                            borderColor: _surNameController
                                                    .text.isNotEmpty
                                                ? AppColors.green
                                                : AppColors.grey,
                                          ),
                                          CustomTextFormField(
                                            hint: 'Email',
                                            label: '',
                                            controller: _emailController,
                                            validator:
                                                AppValidator.validateEmail,
                                            icon: Icons.email_outlined,
                                            borderColor:
                                                _emailController.text.isNotEmpty
                                                    ? AppColors.green
                                                    : AppColors.grey,
                                          ),
                                          CustomTextFormField(
                                            hint: 'Phone Number',
                                            label: '',
                                            controller: _phoneController,
                                            validator:
                                                AppValidator.validateTextfield,
                                            icon: Icons.local_phone_outlined,
                                            borderColor:
                                                _phoneController.text.isNotEmpty
                                                    ? AppColors.green
                                                    : AppColors.grey,
                                          ),
                                          CustomTextFormField(
                                            label: '',
                                            isPasswordField: true,
                                            validator:
                                                AppValidator.validatePassword,
                                            controller: _passwordController,
                                            hint: 'Password',
                                            icon: Icons.lock_outline,
                                            borderColor: _passwordController
                                                    .text.isNotEmpty
                                                ? AppColors.green
                                                : AppColors.grey,
                                            isobscure: true,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            top: AppUtils.deviceScreenSize(context).height *
                                0.59,
                            right: 0,
                            left: 0,
                            child: FormButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  verifyAlertDialog(context);
                                }
                              },

                              text: 'Continue',
                              borderColor: AppColors.green,
                              bgColor: AppColors.green,
                              textColor: AppColors.white,
                              borderRadius: 10,
                              // disableButton: _formKey.currentState!
                              //     .validate()??false,
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
      ),
    );
  }

  verifyAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppUtils.deviceScreenSize(context).width,
                    height: 150,
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            AppImages.verifyAlertDialogImage,
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
                  const CustomText(
                    text: AppStrings.verifySomething,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    text: AppStrings.verifySomethingDescription,
                    // weight: FontWeight.bold,
                    size: 16,
                    color: AppColors.textColor,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 20, 0),
                    child: FormButton(
                      onPressed: () {
                        AppNavigator.pushAndStackNamed(context,
                            name: AppRouter.otpVerification);
                      },
                      height: 50,
                      // width: AppUtils.deviceScreenSize(context).width / 2.5,
                      text: 'Continue',
                      borderColor: AppColors.green,
                      bgColor: AppColors.green,
                      textColor: AppColors.white,
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
