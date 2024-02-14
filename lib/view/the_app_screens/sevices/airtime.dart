import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:teller_trust/model/quick_access_model.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_list.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../auth/otp_pin_pages/confirm_with_otp.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class AirtimePurchase extends StatefulWidget {
  final Services services;

  const AirtimePurchase({super.key, required this.services});

  @override
  State<AirtimePurchase> createState() => _AirtimePurchaseState();
}

class _AirtimePurchaseState extends State<AirtimePurchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: AppUtils.deviceScreenSize(context).height-100,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   width: AppUtils.deviceScreenSize(context).width,
                //   height: 50,
                //   color: AppColors.darkGreen,
                //   child: const Padding(
                //     padding: EdgeInsets.all(15.0),
                //     child: Padding(
                //       padding: EdgeInsets.all(0),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               // CustomText(
                //               //     text: orderNotification.customer,
                //               //     color: AppColors.white),
                //               // CustomText(
                //               //     text: orderNotification.size,
                //               //     color: AppColors.white)
                //             ],
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           // Container(
                //           //   height: 120,
                //           //   width: AppUtils.deviceScreenSize(context).width / 2,
                //           //   child: CustomText(
                //           //     text: orderNotification.location,
                //           //     color: AppColors.white,
                //           //     maxLines: 5,
                //           //   ),
                //           // )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.darkGreen,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "Airtime purchase",
                          color: AppColors.white,
                          weight: FontWeight.w600,
                          size: 18,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel,
                            color: AppColors.lightShadowGreenColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    networkProviderItem(AppList().networkProviders[0],
                        AppList().networkProvidersImages[0]),
                    networkProviderItem(AppList().networkProviders[1],
                        AppList().networkProvidersImages[1]),
                    networkProviderItem(AppList().networkProviders[2],
                        AppList().networkProvidersImages[2]),
                    networkProviderItem(AppList().networkProviders[3],
                        AppList().networkProvidersImages[3])
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomText(
                    text: "Select Amount",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    selectAmount("2000"),
                    selectAmount("1500"),
                    selectAmount("1000"),
                    selectAmount("500"),
                    selectAmount("200"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            hint: '0.00',
                            label: '',
                            controller: _selectedAmtController,
                            textInputType: TextInputType.number,
                            validator: AppValidator.validateTextfield,
                            icon: Icons.currency_exchange,
                            borderColor: _selectedAmtController.text.isNotEmpty
                                ? AppColors.green
                                : AppColors.grey,
                          ),
                          CustomTextFormField(
                            hint: 'Input number here',
                            label: 'Beneficiary',
                            controller: _beneficiaryController,
                            textInputType: TextInputType.number,
                            validator: AppValidator.validateTextfield,
                            icon: Icons.flag,

                            //isMobileNumber: true,
                            borderColor: _beneficiaryController.text.isNotEmpty
                                ? AppColors.green
                                : AppColors.grey,
                          ),

                          ///Remember to add beneficiary
                          FormButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                modalSheet.showMaterialModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.vertical(top: Radius.circular(20.0)),
                                  ),
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.only(top: 200.0),
                                    child: ConfirmWithPin(),
                                  ),
                                );

                                //AppNavigator.pushNamedAndRemoveUntil(context, name5: AppRouter.landingPage);
                              }
                            },
                            disableButton: AppValidator.validateTextfield(
                                        _selectedAmtController.text) !=
                                    null ||
                                AppValidator.validateTextfield(
                                        _beneficiaryController.text) !=
                                    null,
                            text: 'Purchase Airtime',
                            borderColor: AppColors.darkGreen,
                            bgColor: AppColors.darkGreen,
                            textColor: AppColors.white,
                            borderRadius: 10,
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  String selectedNetwork = "mtn";
  final _beneficiaryController = TextEditingController();
  final _selectedAmtController = TextEditingController();

  Widget selectAmount(String amt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print(amt);
          setState(() {
            _selectedAmtController.text = amt;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.greyAccent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomText(
              text: "N $amt",
            ),
          ),
        ),
      ),
    );
  }

  Widget networkProviderItem(String name, String image) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          border: Border.all(
              color: selectedNetwork == name.toLowerCase()
                  ? AppColors.green
                  : Colors.transparent),
          color: selectedNetwork == name.toLowerCase()
              ? AppColors.lightShadowGreenColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedNetwork = name.toLowerCase();
            });
          },
          child: Column(
            children: [
              CircleAvatar(
                //backgroundColor: service.backgroundColor,
                radius: 20,
                backgroundImage: AssetImage(image),
                //child: Image.asset(image,height: 20,width: 20,),
              ),
              CustomText(
                text: name,
                color: AppColors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
// void showAirtimeModal(BuildContext context, Services services) {
//   modalSheet.showMaterialModalBottomSheet(
//     context: context,
//     enableDrag: true,
//     isDismissible: true,
//     expand: false,
//     //shape: ShapeDecoration(shape: shape),
//     builder: (context) => Container(
//       height: AppUtils.deviceScreenSize(context).height * 0.8,
//       child: ,
//     ),
//   );
// }
}
