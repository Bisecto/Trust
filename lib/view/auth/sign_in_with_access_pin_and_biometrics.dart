import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../res/app_colors.dart';
import '../../res/app_images.dart';
import '../../res/app_router.dart';
import '../../res/app_strings.dart';
import '../../utills/app_navigator.dart';
import '../../utills/app_utils.dart';
import '../../utills/app_validator.dart';
import '../important_pages/dialog_box.dart';
import '../important_pages/not_found_page.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/form_input.dart';
import 'package:local_auth/local_auth.dart';

class SignInWIthAccessPinBiometrics extends StatefulWidget {
  const SignInWIthAccessPinBiometrics({super.key});

  @override
  State<SignInWIthAccessPinBiometrics> createState() =>
      _SignInWIthAccessPinBiometricsState();
}

class _SignInWIthAccessPinBiometricsState
    extends State<SignInWIthAccessPinBiometrics> {
  OtpFieldController otpFieldController = OtpFieldController();
  PinInputController pinInputController = PinInputController(length: 4);
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
            listener: (context, state) async {
              if (state is ErrorState) {
                MSG.warningSnackBar(context, state.error);
              } else if (state is SuccessState) {
                welcomeAlertDialog(context);
                await Future.delayed(const Duration(seconds: 3));
                AppNavigator.pushNamedAndRemoveUntil(context,
                    name: AppRouter.landingPage);
                // }
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
                                  AppUtils.deviceScreenSize(context).height *
                                      0.5,
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
                                              child:
                                                  const Icon(Icons.arrow_back),
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
                            top:
                                AppUtils.deviceScreenSize(context).height * 0.2,
                            bottom: AppUtils.deviceScreenSize(context).height *
                                0.05,
                            right: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                height:
                                    AppUtils.deviceScreenSize(context).height *
                                        0.6,
                                width: AppUtils.deviceScreenSize(context).width,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          text: "John,",
                                          weight: FontWeight.w600,
                                          size: 16,
                                        ),
                                        const CustomText(
                                          text:
                                              "Please confirm your pin to access you Trust",
                                          //weight: FontWeight.bold,
                                          size: 14,
                                        ),
                                        const SizedBox(
                                          height: 20,
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
                                              AppUtils.deviceScreenSize(context)
                                                  .width,
                                          inputHasBorder: true,
                                          inputFillColor: AppColors.white,
                                          inputHeight: 55,
                                          inputWidth: 55,
                                          keyboardBtnSize: 70,
                                          cancelColor: AppColors.black,
                                          inputBorderRadius:
                                              BorderRadius.circular(10),
                                          leftExtraInputWidget: GestureDetector(
                                              onTap: () async {
                                                final LocalAuthentication
                                                    _localAuthentication =
                                                    LocalAuthentication();
                                                bool isBiometricAvailable =
                                                    await _localAuthentication
                                                        .canCheckBiometrics;
                                                if (isBiometricAvailable) {
                                                  LocalAuthentication();
                                                  bool isAuthenticated =
                                                      await _localAuthentication
                                                          .authenticate(
                                                              localizedReason:
                                                                  'Authenticate '
                                                                  'using biometrics');
                                                  if (isAuthenticated) {
                                                    print(12345678);
                                                  }
                                                } else {
                                                  MSG.warningSnackBar(context,
                                                      "No biometrics is set");
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Container(
                                                    height: 70,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                AppColors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Icon(
                                                        Icons.fingerprint)),
                                              )),
                                          keyoardBtnBorderRadius:
                                              BorderRadius.circular(10),
                                          //inputElevation: 3,
                                          buttonFillColor: AppColors.white,
                                          btnTextColor: AppColors.black,
                                          buttonBorderColor: AppColors.grey,
                                          spacing:
                                              AppUtils.deviceScreenSize(context)
                                                      .height *
                                                  0.06,
                                          pinInputController:
                                              pinInputController,
                                          onSubmit: () async {
                                            /// ignore: avoid_print
                                            String userData=await SharedPref.getString('userData');
                                            String password=await SharedPref.getString('password');
                                            authBloc.add(SignInEventClick(userData,password,pinInputController.text,'accessPin'));
                                            // if (widget.pin !=
                                            //     pinInputController.text) {
                                            //   MSG.warningSnackBar(
                                            //       context, "Pin does not match");
                                            // } else {
                                            //authBloc.add(CreatePinEvent(widget.pin, pinInputController.text));
                                            // }
                                            print(
                                                "Text is : ${pinInputController.text}");
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
                case LoadingState:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return const Center(
                    child: NotFoundPage(),
                  );
              }
            }));
  }

  welcomeAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
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
                            AppImages.welcomeImage2,
                          ),
                          fit: BoxFit.fill,
                        ),
                        //color: AppColors.red,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    text: AppStrings.magic,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    text: AppStrings.magicDescription,
                    // weight: FontWeight.bold,
                    size: 16,
                    color: AppColors.textColor,
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

class CustomAppKeyBoard {}
