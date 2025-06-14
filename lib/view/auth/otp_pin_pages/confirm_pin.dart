import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';

import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_router.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../res/app_strings.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/show_toast.dart';

class ConfirmPin extends StatefulWidget {
  final String pin;

  const ConfirmPin({super.key, required this.pin});

  @override
  State<ConfirmPin> createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
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
              if (state is ErrorState) {
                showToast(
                    context: context,
                    title: 'Error',
                    subtitle: state.error,
                    type: ToastMessageType.error);
              } else if (state is SuccessState) {
                welcomeAlertDialog(context, theme);
                await Future.delayed(const Duration(seconds: 3));
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
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundContainerColor
                                        : AppColors.white,
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
                                        CustomText(
                                          text: "Confirm Your Security Pin",
                                          weight: FontWeight.w600,
                                          size: 20,
                                          color: theme.isDark
                                              ? AppColors
                                                  .darkModeBackgroundMainTextColor
                                              : AppColors.textColor,
                                        ),
                                        CustomText(
                                          text:
                                              "We will require this pin to sign you into the app",
                                          //weight: FontWeight.bold,
                                          size: 16,
                                          color: theme.isDark
                                              ? AppColors
                                                  .darkModeBackgroundMainTextColor
                                              : AppColors.textColor,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        PinPlusKeyBoardPackage(
                                          keyboardButtonShape:
                                              KeyboardButtonShape.defaultShape,
                                          inputShape: InputShape.defaultShape,
                                          keyboardMaxWidth:
                                              AppUtils.deviceScreenSize(context)
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
                                              AppUtils.deviceScreenSize(context)
                                                      .height *
                                                  0.06,
                                          pinInputController:
                                              pinInputController,

                                          onSubmit: () async {
                                            /// ignore: avoid_print
                                            if (widget.pin !=
                                                pinInputController.text) {
                                              showToast(
                                                  context: context,
                                                  title: 'Warning',
                                                  subtitle:
                                                      "PIN does not match",
                                                  type:
                                                      ToastMessageType.warning);
                                            } else {
                                              authBloc.add(CreatePinEvent(
                                                  widget.pin,
                                                  pinInputController.text,
                                                  context));
                                            }
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

  welcomeAlertDialog(BuildContext context, AdaptiveThemeMode theme) {
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
                    decoration: BoxDecoration(
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundContainerColor
                            : AppColors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            theme.isDark
                                ? AppImages.verifyAlertDialogDarkImage
                                : AppImages.verifyAlertDialogImage,
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
                  TextStyles.textHeadings(
                    textValue: AppStrings.magic,
                    textColor: theme.isDark
                        ? AppColors.darkModeBackgroundMainTextColor
                        : AppColors.textColor,
                    textSize: 20,
                    fontWeight: FontWeight.bold
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
