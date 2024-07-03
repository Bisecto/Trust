import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../res/app_list.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../widgets/drop_down.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';

class TellaCardRequest extends StatefulWidget {
  const TellaCardRequest({super.key});

  @override
  State<TellaCardRequest> createState() => _TellaCardRequestState();
}

class _TellaCardRequestState extends State<TellaCardRequest> {
  final String _selectedPlan = '';
  final _formKey = GlobalKey<FormState>();
  final _houseDetailsController = TextEditingController();
  final _streetDetailsController = TextEditingController();
  final _landmarkDetailsController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppIcons.tellaCardRequest,
                    height: 20,
                  ),
                  SvgPicture.asset(AppIcons.cancel),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                AppIcons.deliveryFee,
                height: 50,
              ),
              SizedBox(
                height: 10,
              ),
              DropDown(
                //controller: _genderController,
                label: '',
                hint: "Select state",
                width: AppUtils.deviceScreenSize(context).width,
                items: AppList().dataPlanList,
                selectedValue: _selectedPlan,
                color: AppColors.white,
                borderRadius: 12,
                height: 50,
              ),
              DropDown(
                //controller: _genderController,
                label: '',
                hint: "Select LGA",
                width: AppUtils.deviceScreenSize(context).width,
                items: AppList().dataPlanList,
                selectedValue: _selectedPlan,
                color: AppColors.white,
                borderRadius: 12,
                height: 50,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hint: 'Add House details Here',
                        label: '',
                        controller: _houseDetailsController,
                        validator:
                        AppValidator.validateTextfield,
                        widget: Icon(Icons.house),
                        borderColor: _houseDetailsController.text.isNotEmpty?AppColors.green:AppColors.grey,

                      ),

                      CustomTextFormField(
                        label: '',
                        validator:
                        AppValidator.validatePassword,
                        controller: _streetDetailsController,
                        hint: 'Add Street details Here',
                        widget: Icon(Icons.streetview),
                        borderColor: _streetDetailsController.text.isNotEmpty?AppColors.green:AppColors.grey,

                      ), CustomTextFormField(
                        label: '',
                        validator:
                        AppValidator.validatePassword,
                        controller: _landmarkDetailsController,
                        hint: 'Any Landmark?',
                        widget: Icon(Icons.location_on),
                        borderColor: _landmarkDetailsController.text.isNotEmpty?AppColors.green:AppColors.grey,

                      ),
                      CustomTextFormField(
                        label: '',
                        validator:
                        AppValidator.validatePassword,
                        controller: _landmarkDetailsController,
                        hint: 'Phone Number',
                        widget: Icon(Icons.phone_in_talk),
                        borderColor: _landmarkDetailsController.text.isNotEmpty?AppColors.green:AppColors.grey,

                      ),
                      FormButton(
                        onPressed: () {
                          if (_formKey.currentState!
                              .validate()) {
                           // authBloc.add(InitiateSignInEventClick(_emailController.text,_passwordController.text));
                            // await Future.delayed(const Duration(seconds: 3));
                            //AppNavigator.pushNamedAndRemoveUntil(context, name: AppRouter.landingPage);

                          }
                        },
                        text: 'Complete request',
                        borderColor: AppColors.green,
                        bgColor: AppColors.green,
                        textColor: AppColors.white,
                        borderRadius: 10,
                      )
                    ],
                  )),

            ],
          ),
        ),
      ),
    );
  }
}
