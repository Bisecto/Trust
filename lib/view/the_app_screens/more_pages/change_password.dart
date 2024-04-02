import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/form_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                title: AppIcons.changePassword,
              ),
              BlocConsumer<AuthBloc, AuthState>(
                  bloc: authBloc,
                  listenWhen: (previous, current) => current is! AuthInitial,
                  buildWhen: (previous, current) => current is! AuthInitial,
                  listener: (context, state) async {
                    if (state is ErrorState) {
                      MSG.warningSnackBar(context, state.error);
                    } else if (state is SuccessState) {
                      Navigator.pop(context);
                      Navigator.pop(context);

                      MSG.snackBar(context, "Password changed successful");
                      // welcomeAlertDialog(context);
                      // await Future.delayed(const Duration(seconds: 3));
                      // AppNavigator.pushNamedAndRemoveUntil(context,
                      //     name: AppRouter.landingPage);
                      // }
                    }
                  },
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case AuthInitial || ErrorState:
                        return
                       Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: CustomText(
                                          text: "Let's help you restore your password",
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: CustomContainerWithIcon(
                                          title: 'Cprecious0310@gmail.com',
                                          iconData: SvgPicture.asset(AppIcons.email),
                                        ),
                                      ),
                                      CustomTextFormField(
                                        label: '',
                                        isPasswordField: true,
                                        validator: AppValidator.validatePassword,
                                        controller: _oldPasswordController,
                                        hint: 'Old Password',
                                        icon: Icons.password,
                                        borderColor: _oldPasswordController.text.isNotEmpty
                                            ? AppColors.green
                                            : AppColors.grey,
                                      ),
                                      CustomTextFormField(
                                        label: '',
                                        isPasswordField: true,
                                        validator: AppValidator.validatePassword,
                                        controller: _newPasswordController,
                                        hint: 'New Password',
                                        icon: Icons.password,
                                        borderColor: _newPasswordController.text.isNotEmpty
                                            ? AppColors.green
                                            : AppColors.grey,
                                      ),
                                      CustomTextFormField(
                                        label: '',
                                        isPasswordField: true,
                                        validator: AppValidator.validatePassword,
                                        controller: _confirmPasswordController,
                                        hint: 'Confirm Password',
                                        icon: Icons.password,
                                        borderColor: _confirmPasswordController.text.isNotEmpty
                                            ? AppColors.green
                                            : AppColors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                child: FormButton(
                                    onPressed: () {
                                      Map<dynamic,String> data={
                                        "oldPassword": _oldPasswordController.text,
                                        "newPassword": _newPasswordController.text,
                                        "confirmPassword": _confirmPasswordController.text,
                                      };
                                      modalSheet.showMaterialModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.0)),
                                        ),
                                        context: context,
                                        builder: (context) =>PinContinue(authBloc: authBloc, data: data,)
                                      );
                                    },
                                    text: "Continue",
                                    bgColor: AppColors.green,
                                    borderRadius: 12),
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
                  }),
            ],
          ),
        ));}



}
class PinContinue extends StatefulWidget {
  AuthBloc authBloc;
  Map<dynamic,String> data;
   PinContinue({super.key, required this.authBloc, required this.data});

  @override
  State<PinContinue> createState() => _PinContinueState();
}

class _PinContinueState extends State<PinContinue> {
  PinInputController pinInputController = PinInputController(length: 4);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppUtils.deviceScreenSize(context).height/1.3,

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                          "Please enter your PIN to change password.",
                          weight: FontWeight.bold,
                          size: 16,
                          maxLines: 3,

                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PinPlusKeyBoardPackage(
                          keyboardButtonShape: KeyboardButtonShape.defaultShape,
                          inputShape: InputShape.defaultShape,
                          keyboardMaxWidth:
                          AppUtils.deviceScreenSize(context).width,
                          inputHasBorder: true,
                          inputFillColor: AppColors.white,
                          inputHeight: 55,
                          inputWidth: 55,
                          keyboardBtnSize: 70,
                          cancelColor: AppColors.black,
                          inputBorderRadius: BorderRadius.circular(10),

                          keyoardBtnBorderRadius: BorderRadius.circular(10),
                          //inputElevation: 3,
                          buttonFillColor: AppColors.white,
                          btnTextColor: AppColors.black,
                          buttonBorderColor: AppColors.grey,
                          spacing: AppUtils.deviceScreenSize(context).height * 0.06,
                          pinInputController: pinInputController,

                          onSubmit: () {
                            Navigator.pop(context);
                            widget.authBloc.add(ChangePasswordEvent(pinInputController.text,widget.data));

                          },
                          keyboardFontFamily: '',
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
