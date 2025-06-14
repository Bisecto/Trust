import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/auth/sign_in_screen.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_colors.dart';
import '../../res/app_images.dart';
import '../../res/app_router.dart';
import '../../res/app_strings.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/app_navigator.dart';
import '../../utills/app_utils.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../important_pages/not_found_page.dart';
import '../widgets/app_custom_text.dart';
import 'package:local_auth/local_auth.dart';

import '../widgets/show_toast.dart';

class SignInWIthAccessPinBiometrics extends StatefulWidget {
  String userName;

  SignInWIthAccessPinBiometrics({super.key, required this.userName});

  @override
  State<SignInWIthAccessPinBiometrics> createState() =>
      _SignInWIthAccessPinBiometricsState();
}

class _SignInWIthAccessPinBiometricsState
    extends State<SignInWIthAccessPinBiometrics> {
  //OtpFieldController otpFieldController = OtpFieldController();
  PinInputController pinInputController = PinInputController(length: 4);
  final AuthBloc authBloc = AuthBloc();
  bool canUseBiometrics = false;
  final LocalAuthentication auth = LocalAuthentication();
  bool canUseBiometrics2 = false;

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
    super.initState();
    getCanUseBiometrics();
    //getCanUseBiometrics2();
  }

  Future<void> getCanUseBiometrics() async {
    bool isBiometricsEnabled =
        await SharedPref.getBool(SharedPrefKey.biometricKey) ?? false;
    var availableBiometrics = await auth.getAvailableBiometrics();
    bool canCheck = await auth.canCheckBiometrics;
    bool isSupported = await auth.isDeviceSupported();

    // Update the state using setState
    setState(() {
      canUseBiometrics = canCheck &&
          isSupported &&
          availableBiometrics.isNotEmpty &&
          isBiometricsEnabled;
    });
    print(canUseBiometrics);
  }

  Future<void> getCanUseBiometrics2() async {
    var availableBiometrics = await auth.getAvailableBiometrics();
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool isDeviceSupported = await auth.isDeviceSupported();
    setState(() {
      // Ensure each condition evaluates to a boolean
      canUseBiometrics2 = canCheckBiometrics && // Note the function call
          isDeviceSupported &&
          availableBiometrics.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider
        .of<CustomThemeState>(context)
        .adaptiveThemeMode;

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
              if (state is ErrorState) {
                // setState(() {
                //   pinInputController.text = '    ';
                // });

                AppNavigator.pushAndRemovePreviousPages(context,
                    page: SignInWIthAccessPinBiometrics(
                      userName: widget.userName,
                    ));
                showToast(
                    context: context,
                    title: 'Error',
                    subtitle: state.error,
                    type: ToastMessageType.error);
              } else if (state is SuccessState) {
                //await Future.delayed(const Duration(seconds: 3));
                AppNavigator.pushNamedAndRemoveUntil(context,
                    name: AppRouter.landingPage);
                // AppNavigator.pushNamedAndRemoveUntil(context,
                //     name: AppRouter.landingPage,);
                // // }
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case AuthInitial || ErrorState:
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: AppUtils
                          .deviceScreenSize(context)
                          .height,
                      width: AppUtils
                          .deviceScreenSize(context)
                          .width,
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
                              AppUtils
                                  .deviceScreenSize(context)
                                  .height *
                                  0.5,
                              width: AppUtils
                                  .deviceScreenSize(context)
                                  .width,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImages.authAppLogoImage),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              // child: Padding(
                              //   padding: const EdgeInsets.all(20.0),
                              //   child: Align(
                              //     alignment: Alignment.topLeft,
                              //     child: SafeArea(
                              //       child: Column(
                              //         children: [
                              //           if (Navigator.canPop(context))
                              //             GestureDetector(
                              //               onTap: () {
                              //                 Navigator.pop(context);
                              //               },
                              //               child: Container(
                              //                 height: 50,
                              //                 width: 50,
                              //                 decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.circular(5),
                              //                     border: Border.all(
                              //                         color: AppColors.green)),
                              //                 child:
                              //                     const Icon(Icons.arrow_back),
                              //               ),
                              //             ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                          Positioned.fill(
                            top:
                            AppUtils
                                .deviceScreenSize(context)
                                .height * 0.2,
                            bottom: AppUtils
                                .deviceScreenSize(context)
                                .height *
                                0.05,
                            right: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                height:
                                AppUtils
                                    .deviceScreenSize(context)
                                    .height *
                                    0.6,
                                width: AppUtils
                                    .deviceScreenSize(context)
                                    .width,
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors
                                        .darkModeBackgroundContainerColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SingleChildScrollView(
                                    // physics:
                                    //     const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                          "${AppUtils.formatString(
                                              data: widget.userName)},",
                                          weight: FontWeight.w600,
                                          size: 16,
                                          color: theme.isDark
                                              ? AppColors
                                              .darkModeBackgroundMainTextColor
                                              : AppColors.textColor,
                                        ),
                                        CustomText(
                                          text:
                                          "Please confirm your pin to access your TellaTrust account.",
                                          //weight: FontWeight.bold,
                                          size: 12,
                                          maxLines: 2,
                                          color: theme.isDark
                                              ? AppColors
                                              .darkModeBackgroundSubTextColor
                                              : AppColors.textColor,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                              text: "Not you?",
                                              color: theme.isDark
                                                  ? AppColors
                                                  .darkModeBackgroundSubTextColor
                                                  : AppColors.textColor,
                                              //weight: FontWeight.bold,
                                              size: 12,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await AppUtils()
                                                    .logout(context);
                                                await FirebaseMessaging.instance
                                                    .deleteToken();

                                                AppNavigator.pushAndReplacePage(
                                                    context,
                                                    page: const SignInScreen());
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors.red),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10)),
                                                child: const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 4.0, 10, 4),
                                                  child: CustomText(
                                                    text: "Logout",
                                                    //weight: FontWeight.bold,
                                                    color: AppColors.red,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // PinAuthentication(
                                        //   onChanged: (v) {
                                        //     if (kDebugMode) {
                                        //       print(v);
                                        //     }
                                        //   },
                                        //   onSpecialKeyTap: () {},
                                        //   specialKey: const SizedBox(),
                                        //   useFingerprint: true,
                                        //
                                        //   onbuttonClick: () {},
                                        //   submitLabel: const Text(
                                        //     'Submit',
                                        //     style: TextStyle(color: Colors.white, fontSize: 20),
                                        //   ),
                                        PinPlusKeyBoardPackage(
                                          keyboardButtonShape:
                                          KeyboardButtonShape.defaultShape,
                                          inputShape: InputShape.defaultShape,
                                          keyboardMaxWidth:
                                          AppUtils
                                              .deviceScreenSize(context)
                                              .width,
                                          inputHasBorder: true,
                                          inputFillColor: theme.isDark
                                              ? AppColors.black
                                              : AppColors.white,
                                          inputHeight: 55,
                                          inputWidth: 55,
                                          keyboardBtnSize: 70,
                                          cancelColor: theme.isDark
                                              ? AppColors.white
                                              : AppColors.black,
                                          inputTextColor: theme.isDark
                                              ? AppColors.white
                                              : AppColors.black,
                                          inputBorderRadius:
                                          BorderRadius.circular(10),
                                          doneButton: Icon(
                                            Icons.done,
                                            color: theme.isDark
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),

                                          leftExtraInputWidget: canUseBiometrics
                                              ? GestureDetector(
                                              onTap: () async {
                                                bool didAuthenticate =
                                                await AppUtils.biometrics(
                                                    "Please authenticate to sign in");
                                                if (didAuthenticate) {
                                                  String hashedPin =
                                                  await SharedPref
                                                      .getString(
                                                      SharedPrefKey
                                                          .hashedAccessPinKey);
                                                  print(hashedPin);
                                                  String unHashedPin =
                                                      AppUtils().decryptData(
                                                          hashedPin) ??
                                                          '';
                                                  print(unHashedPin);
                                                  String userData =
                                                  await SharedPref
                                                      .getString(
                                                      SharedPrefKey
                                                          .userDataKey);
                                                  String password =
                                                  await SharedPref
                                                      .getString(
                                                      SharedPrefKey
                                                          .passwordKey);
                                                  authBloc.add(
                                                      SignInEventClick(
                                                          userData,
                                                          password,
                                                          unHashedPin,
                                                          'accessPin',
                                                          context));
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
                                                    width: 100,
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
                                              : const SizedBox(),
                                          keyoardBtnBorderRadius:
                                          BorderRadius.circular(10),
                                          //inputElevation: 3,
                                          buttonFillColor: theme.isDark
                                              ? AppColors.black
                                              : AppColors.white,
                                          btnTextColor: theme.isDark
                                              ? AppColors.white
                                              : AppColors.textColor,
                                          buttonBorderColor: AppColors.grey,
                                          spacing:
                                          AppUtils
                                              .deviceScreenSize(context)
                                              .height *
                                              0.06,
                                          pinInputController:
                                          pinInputController,
                                          onSubmit: () async {
                                            /// ignore: avoid_print
                                            String userData =
                                            await SharedPref.getString(
                                                SharedPrefKey.userDataKey);
                                            String password =
                                            await SharedPref.getString(
                                                SharedPrefKey.passwordKey);
                                            authBloc.add(SignInEventClick(
                                                userData,
                                                password,
                                                pinInputController.text,
                                                'accessPin',
                                                context));
                                            // if (widget.pin !=
                                            //     pinInputController.text) {
                                            //   MSG.warningSnackBar(
                                            //       context, "Pin does not match");
                                            // } else {
                                            //authBloc.add(CreatePinEvent(widget.pin, pinInputController.text));
                                            // }
                                            print(
                                                "Text is : ${pinInputController
                                                    .text}");
                                          },
                                          keyboardFontFamily: '',
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
            }));
  }

  welcomeAlertDialog(BuildContext context,
      AdaptiveThemeMode theme,) {
    showDialog(
        context: context,
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
                    width: AppUtils
                        .deviceScreenSize(context)
                        .width,
                    height: 150,
                    decoration: BoxDecoration(
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundContainerColor
                            : AppColors.white,
                        image: const DecorationImage(
                          image: AssetImage(
                            AppImages.welcomeImage2,
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
                    text: AppStrings.magic,
                    weight: FontWeight.bold,
                    size: 18,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundMainTextColor
                        : AppColors.textColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: AppStrings.magicDescription,
                    // weight: FontWeight.bold,
                    size: 16,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundSubTextColor
                        : AppColors.textColor,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // SizedBox(
                  //   height: 20,
                  // )
                ],
              ),
            ),
          );
        });
  }
}
