import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/kyc_bloc/kyc_bloc.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../../res/app_colors.dart';
import '../../../../res/app_router.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_validator.dart';
import '../../../../utills/custom_theme.dart';
import '../../../../utills/enums/toast_mesage.dart';
import '../../../../utills/shared_preferences.dart';
import '../../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/form_input.dart';
import '../../../widgets/show_toast.dart';

class BvnNinKyc2 extends StatefulWidget {
  const BvnNinKyc2({super.key});

  @override
  State<BvnNinKyc2> createState() => _BvnNinKyc2State();
}

class _BvnNinKyc2State extends State<BvnNinKyc2> {
  String selectedString = 'BVN';
  final _numberController = TextEditingController();
  final dob = TextEditingController();
  final KycBloc kycBloc = KycBloc();
  OtpFieldController otpFieldController = OtpFieldController();
  bool isCompleted = false;
  String addedOTP = '';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      // appBar: AppBar(
      //   backgroundColor: AppColors.darkGreen,
      //   elevation: 1,
      //   title: const CustomText(
      //     text: "KYC verification",
      //     color: AppColors.white,
      //   ),
      //   leading: Navigator.canPop(context)
      //       ? IconButton(
      //           icon: const Icon(Icons.arrow_back, color: AppColors.white),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         )
      //       : null,
      // ),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            // bottom: 0,
            child: SizedBox(
              height: AppUtils.deviceScreenSize(context).height + 50,
              width: double.infinity,
              // color: theme.isDark
              //     ? AppColors.darkModeBackgroundColor
              //     : AppColors.white,

              //color: ,
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(AppImages.authAppLogoImage),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              child: SvgPicture.asset(
                theme.isDark
                    ? AppIcons.kycDarkBackground
                    : AppIcons.kycBackground,
                height: AppUtils.deviceScreenSize(context).height + 50,
                width: double.infinity,
              ),
            ),
          ),
          SafeArea(
            left: true,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: theme.isDark
                                ? AppColors.white
                                : AppColors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(child: Icon(Icons.arrow_back)),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                color: theme.isDark
                    ? AppColors.darkModeBackgroundContainerColor
                    : AppColors.white,
                child: Container(
                    width: AppUtils.deviceScreenSize(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: BlocConsumer<KycBloc, KycState>(
                        bloc: kycBloc,
                        listenWhen: (previous, current) =>
                            current is! KycInitial,
                        buildWhen: (previous, current) =>
                            current is! KycInitial,
                        listener: (context, state) async {
                          if (state is ErrorState) {
                            showToast(
                                context: context,
                                title: 'Error Occurred',
                                subtitle: state.error,
                                type: ToastMessageType.error);

                            //MSG.warningSnackBar(context, state.error);
                          } else if (state is AccessTokenExpireState) {
                            String firstame =
                                await SharedPref.getString('firstName');

                            AppNavigator.pushAndRemovePreviousPages(context,
                                page: SignInWIthAccessPinBiometrics(
                                  userName: firstame,
                                ));
                          } else if (state is SuccessState) {
                            showToast(
                                context: context,
                                title: 'KYC Verification',
                                subtitle: state.msg,
                                type: ToastMessageType.success);
                          }
                        },
                        builder: (context, state) {
                          print(state);
                          switch (state.runtimeType) {
                            case KycInitial || ErrorState:
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: AppColors.darkGreen),
                                        color: AppColors.appBarMainColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     setState(() {
                                            //       selectedString = 'NIN';
                                            //     });
                                            //   },
                                            //   child: Container(
                                            //     width: 35,
                                            //     height: 20,
                                            //     decoration: BoxDecoration(
                                            //       color: selectedString == 'NIN'
                                            //           ? AppColors.green
                                            //           : Colors.transparent,
                                            //       borderRadius:
                                            //           BorderRadius.circular(10),
                                            //     ),
                                            //     child: Center(
                                            //       child: CustomText(
                                            //         text: 'NIN',
                                            //         color:
                                            //             selectedString == 'NIN'
                                            //                 ? AppColors.white
                                            //                 : Colors.black,
                                            //         size: 10,
                                            //         weight: FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedString = 'BVN';
                                                });
                                              },
                                              child: Container(
                                                width: 35,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: selectedString == 'BVN'
                                                      ? AppColors.green
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: CustomText(
                                                    text: 'BVN',
                                                    color:
                                                        selectedString == 'BVN'
                                                            ? AppColors.white
                                                            : Colors.black,
                                                    size: 10,
                                                    weight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomText(
                                      text: 'Enter your $selectedString',
                                      size: 20,
                                      weight: FontWeight.bold,
                                      textAlign: TextAlign.center,
                                      color: theme.isDark
                                          ? AppColors.white
                                          : AppColors.black,
                                      maxLines: 2,
                                    ),
                                    CustomText(
                                      text:
                                          'We will use this to ensure your account belongs to you',
                                      size: 12,
                                      textAlign: TextAlign.start,
                                      maxLines: 3,
                                      color: theme.isDark
                                          ? AppColors.lightPrimary
                                          : AppColors.textColor,
                                      weight: FontWeight.bold,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomText(
                                      text: 'Level 1 Benefits',
                                      size: 12,
                                      textAlign: TextAlign.center,
                                      color: theme.isDark
                                          ? AppColors.lightPrimary
                                          : AppColors.textColor,
                                      weight: FontWeight.bold,
                                    ),
                                    CustomTextFormField(
                                      label: '',
                                      validator: AppValidator.validateTextfield,
                                      controller: _numberController,
                                      hint: selectedString == 'NIN'
                                          ? 'Enter your NIN (11 digits)'
                                          : 'Enter your BVN (11 digits)',
                                      widget:
                                          const Icon(Icons.verified_outlined),
                                      textInputType: TextInputType.number,
                                      borderColor:
                                          _numberController.text.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 5478)),
                                                //15 years ago
                                                firstDate: DateTime(1940),
                                                //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 5478)));
                                        dob.text = pickedDate != null
                                            ? DateFormat('dd/MM/yyyy')
                                                .format(pickedDate)
                                            : '';
                                      },
                                      child: CustomTextFormField(
                                        controller: dob,
                                        enabled: false,
                                        hint: 'Date of Birth',
                                        widget:
                                            const Icon(Icons.calendar_month),
                                        validator:
                                            AppValidator.validateTextfield,
                                        borderColor: dob.text.isNotEmpty
                                            ? AppColors.green
                                            : AppColors.grey,
                                        label: '',
                                      ),

                                      // _buildTF(
                                      //     enabled: false,
                                      //     title: "Date of Birth",
                                      //     iconUrl: 'assets/icons/dob.svg',
                                      //     controller: dob,
                                      //     textCapitalization:
                                      //         TextCapitalization.sentences),
                                    ),
                                    FormButton(
                                      onPressed: () {
                                        kycBloc.add(InitiateVerification(
                                            selectedString,
                                            _numberController.text,
                                            dob.text,
                                            context));
                                      },
                                      text: 'Save Details',
                                      borderRadius: 10,
                                      //bgColor: _numberController.text.length != 10?AppColors.grey:AppColors.darkGreen,
                                      disableButton:
                                          _numberController.text.length != 11,
                                    ),
                                  ],
                                ),
                              );
                            case RequestOtpState:
                              final requestOtpState = state as RequestOtpState;

                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'OTP Verification',
                                      size: 20,
                                      weight: FontWeight.bold,
                                      textAlign: TextAlign.center,
                                      color: theme.isDark
                                          ? AppColors.white
                                          : AppColors.black,
                                      maxLines: 2,
                                    ),
                                    CustomText(
                                      text:
                                          'Input 5 digit code sent to your $selectedString phone number',
                                      size: 12,
                                      textAlign: TextAlign.start,
                                      maxLines: 3,
                                      color: theme.isDark
                                          ? AppColors.lightgrey
                                          : AppColors.textColor,
                                      //color: AppColors.textColor,
                                      weight: FontWeight.bold,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    OTPTextField(
                                      length: 6,
                                      width: MediaQuery.of(context).size.width,
                                      fieldWidth: 40,
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
                                          addedOTP = pin;
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
                                          kycBloc.add(ValidateVerification(
                                              selectedString,
                                              requestOtpState.identityId,
                                              addedOTP,
                                              _numberController.text,
                                              context));

                                          // authBloc.add(VerifyOTPEventCLick(
                                          //     addedPin,
                                          //     widget.isRegister,
                                          //     context));
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
                                      textColor: AppColors.white,
                                      borderRadius: 10,
                                      disableButton: !isCompleted,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            case SuccessState:
                              final successData = state as SuccessState;
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: 'KYC LEVEL 1 DONE!!!',
                                      size: 20,
                                      weight: FontWeight.bold,
                                      textAlign: TextAlign.center,
                                      //color: AppColors.black,
                                      color: theme.isDark
                                          ? AppColors.white
                                          : AppColors.textColor,
                                      maxLines: 2,
                                    ),
                                    CustomText(
                                      text: 'You can now transact more',
                                      size: 12,
                                      textAlign: TextAlign.start,
                                      maxLines: 3,
                                      color: theme.isDark
                                          ? AppColors.lightPrimary
                                          : AppColors.textColor,
                                      weight: FontWeight.bold,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      //height: 100,
                                      width: AppUtils.deviceScreenSize(context)
                                          .width,
                                      decoration: BoxDecoration(
                                          color: AppColors.lightgreen2,
                                          border: Border.all(
                                              color: AppColors.lightGreen),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text:
                                                  'Bank Name: ${successData.bankName}',
                                              size: 12,
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              color: AppColors.lightGreen,
                                              weight: FontWeight.bold,
                                            ),
                                            CustomText(
                                              text:
                                                  'Account Number: ${successData.nuban}',
                                              size: 12,
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              color: AppColors.lightGreen,
                                              weight: FontWeight.bold,
                                            ),
                                            CustomText(
                                              text:
                                                  'Account Name: ${successData.accountName}',
                                              size: 12,
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              color: AppColors.lightGreen,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CustomText(
                                      text:
                                          'Now you can start sending and receiving funds',
                                      size: 10,
                                      textAlign: TextAlign.start,
                                      maxLines: 3,
                                      color: theme.isDark
                                          ? AppColors.lightPrimary
                                          : AppColors.textColor,
                                      weight: FontWeight.bold,
                                    ),
                                    FormButton(
                                      onPressed: () {
                                        AppNavigator.pushNamedAndRemoveUntil(
                                            context,
                                            name: AppRouter.landingPage);
                                      },
                                      text: "Done",
                                      borderColor: AppColors.lightgrey,
                                      bgColor: AppColors.white,
                                      textColor: AppColors.black,
                                    )
                                  ],
                                ),
                              );
                            default:
                              return const Center(
                                child: NotFoundPage(),
                              );
                          }
                        })),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
