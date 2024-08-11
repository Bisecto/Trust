import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:provider/provider.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/shared_preferences.dart';
import '../../widgets/app_custom_text.dart';

class ConfirmWithPin extends StatefulWidget {
  String title;
  BuildContext context;
  //final Function() onPressed;

  ConfirmWithPin({
    super.key,
    required this.title,
    required this.context, //required this.onPressed,
  });
  @override
  State<ConfirmWithPin> createState() => _ConfirmWithPinState();
}

class _ConfirmWithPinState extends State<ConfirmWithPin> {
  PinInputController pinInputController = PinInputController(length: 4);
  final AuthBloc authBloc = AuthBloc();
  bool canUseBiometrics = false;
  final LocalAuthentication auth = LocalAuthentication();
  bool canUseBiometrics2 = false;
  @override
  void initState() {
    // TODO: implement initState
    getCanUseBiometrics();
    super.initState();
  }
  getCanUseBiometrics() async {
    bool isBiometricsEnabled = await SharedPref.getBool('biometric') ?? false;
    var availableBiometrics = await auth.getAvailableBiometrics();
    canUseBiometrics = await auth.canCheckBiometrics &&
        await auth.isDeviceSupported() &&
        availableBiometrics.isNotEmpty &&
        isBiometricsEnabled;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
        //resizeToAvoidBottomInset: true,
        backgroundColor: theme.isDark
            ? AppColors.darkModeBackgroundColor
            : AppColors.white,
        body: SingleChildScrollView(
          child: Container(
            height: AppUtils.deviceScreenSize(context).height,
            width: AppUtils.deviceScreenSize(context).width,
            decoration: BoxDecoration(
                color: theme.isDark
                    ? AppColors.darkModeBackgroundContainerColor
                    : AppColors.lightShadowGreenColor,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: widget.title,
                          weight: FontWeight.bold,
                          size: 16,
                          maxLines: 3,
                          color: theme.isDark
                              ? AppColors.darkModeBackgroundMainTextColor
                              : AppColors.textColor,
                        ),
                        // const CustomText(
                        //   text: "Input your transaction pin to confirm purchase",
                        //   //weight: FontWeight.bold,
                        //   size: 16,
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        PinPlusKeyBoardPackage(
                          keyboardButtonShape: KeyboardButtonShape.defaultShape,
                          inputShape: InputShape.defaultShape,
                          keyboardMaxWidth:
                              AppUtils.deviceScreenSize(context).width,
                          inputHasBorder: true,
                          inputFillColor:
                              theme.isDark ? AppColors.black : AppColors.white,
                          inputHeight: 55,
                          inputWidth: 55,
                          keyboardBtnSize: 70,
                          // leftExtraInputWidget: canUseBiometrics
                          //     ? GestureDetector(
                          //     onTap: () async {
                          //       bool didAuthenticate =
                          //       await AppUtils.biometrics(
                          //           "Please authenticate to sign in");
                          //       if (didAuthenticate) {
                          //         String hashedPin=await SharedPref.getString('hashedAccessPin');
                          //         print(hashedPin);
                          //         String unHashedPin= AppUtils().decryptData(hashedPin)??'';
                          //         print(unHashedPin);
                          //         String userData =
                          //         await SharedPref.getString(
                          //             'userData');
                          //         String password =
                          //         await SharedPref.getString(
                          //             'password');
                          //         Navigator.pop(context, unHashedPin);
                          //         //model.signIn(context, withBiometrics: true);
                          //       }
                          //       // final LocalAuthentication
                          //       //     _localAuthentication =
                          //       //     LocalAuthentication();
                          //       // bool isBiometricAvailable =
                          //       //     await _localAuthentication
                          //       //         .canCheckBiometrics;
                          //       // if (isBiometricAvailable) {
                          //       //   LocalAuthentication();
                          //       //   bool isAuthenticated =
                          //       //       await _localAuthentication
                          //       //           .authenticate(
                          //       //               localizedReason:
                          //       //                   'Authenticate '
                          //       //                   'using biometrics');
                          //       //   if (isAuthenticated) {
                          //       //     print(12345678);
                          //       //   }
                          //       // } else {
                          //       //   MSG.warningSnackBar(context,
                          //       //       "No biometrics is set");
                          //       // }
                          //     },
                          //     child: Padding(
                          //       padding:
                          //       const EdgeInsets.all(
                          //           5.0),
                          //       child: Container(
                          //           height: 70,
                          //           width: 115,
                          //           decoration: BoxDecoration(
                          //               border: Border.all(
                          //                   color: AppColors
                          //                       .grey),
                          //               borderRadius:
                          //               BorderRadius
                          //                   .circular(
                          //                   10)),
                          //           child: const Icon(
                          //               Icons.fingerprint)),
                          //     ))
                          //     : const SizedBox(),
                          //inputType: InputType.dash,
                          cancelColor:
                              theme.isDark ? AppColors.white : AppColors.black,
                          inputTextColor:
                              theme.isDark ? AppColors.white : AppColors.black,

                          inputBorderRadius: BorderRadius.circular(10),

                          doneButton: Icon(
                            Icons.done,
                            color: theme.isDark
                                ? AppColors.white
                                : AppColors.black,
                          ),


                          keyoardBtnBorderRadius: BorderRadius.circular(10),
                          //inputElevation: 3,
                          buttonFillColor:
                              theme.isDark ? AppColors.black : AppColors.white,
                          btnTextColor: theme.isDark
                              ? AppColors.white
                              : AppColors.textColor,
                          buttonBorderColor: AppColors.grey,
                          spacing:
                              AppUtils.deviceScreenSize(context).height * 0.06,
                          pinInputController: pinInputController,
                          // leftExtraInputWidget: SvgPicture.asset(AppIcons.biometric),

                          onSubmit: () async {
                            /// ignore: avoid_print
                            Navigator.pop(context, pinInputController.text);

                            //AppNavigator.pushAndStackPage(context, page: PurchaseReceipt());
                            print("Text is : ${pinInputController.text}");
                          },
                          keyboardFontFamily: '',
                        ),
                       if (canUseBiometrics)
                      ... [const SizedBox(
                        height: 20,
                      ), CustomText(text: 'Use biometric',color: theme.isDark
                            ? AppColors.darkModeBackgroundMainTextColor
                            : AppColors.textColor,size: 16,),
                        canUseBiometrics
                            ? GestureDetector(
                            onTap: () async {
                              bool didAuthenticate =
                              await AppUtils.biometrics(
                                  "Please authenticate to sign in");
                              if (didAuthenticate) {
                                String hashedPin=await SharedPref.getString('hashedAccessPin');
                                print(hashedPin);
                                String unHashedPin= AppUtils().decryptData(hashedPin)??'';
                                print(unHashedPin);
                                String userData =
                                await SharedPref.getString(
                                    'userData');
                                String password =
                                await SharedPref.getString(
                                    'password');
                                Navigator.pop(context, unHashedPin);
                                //model.signIn(context, withBiometrics: true);
                              }
                              // final LocalAuthentication
                              //     _localAuthentication =
                              //     LocalAuthentication();
                              // bool isBiometricAvailable =
                              //     await _localAuthentication
                              //         .canCheckBiometrics;
                              // if (isBiometricAvailable) {
                              //   LocalAuthentication();
                              //   bool isAuthenticated =
                              //       await _localAuthentication
                              //           .authenticate(
                              //               localizedReason:
                              //                   'Authenticate '
                              //                   'using biometrics');
                              //   if (isAuthenticated) {
                              //     print(12345678);
                              //   }
                              // } else {
                              //   MSG.warningSnackBar(context,
                              //       "No biometrics is set");
                              // }
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.all(
                                  5.0),
                              child: Container(
                                  height: 70,
                                  width: 115,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors
                                              .grey),
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          10)),
                                  child: const Icon(
                                      Icons.fingerprint)),
                            ))
                            : const SizedBox(),]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
