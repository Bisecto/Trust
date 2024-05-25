import 'package:flutter/material.dart';
import 'package:teller_trust/model/category_model.dart';
import 'package:teller_trust/model/quick_access_model.dart';
import 'package:teller_trust/view/widgets/drop_down.dart';

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

class DataPurchase extends StatefulWidget {
  final Category category;

  const DataPurchase({super.key, required this.category});

  @override
  State<DataPurchase> createState() => _DataPurchaseState();
}

class _DataPurchaseState extends State<DataPurchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: AppUtils.deviceScreenSize(context).height - 100,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                          text: "Data purchase",
                          color: AppColors.white,
                          weight: FontWeight.w600,
                          size: 18,
                        ),
                        GestureDetector(
                          onTap: () {
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
                  padding: const EdgeInsets.all(10),
                  child: DropDown(
                    //controller: _genderController,
                    label: 'Select Data Plan',
                    hint: "Choose Plan",
                    width: AppUtils.deviceScreenSize(context).width,
                    items: AppList().dataPlanList,
                    selectedValue: _selectedPlan,
                    color: AppColors.white,
                    borderRadius: 10,
                    height: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // CustomTextFormField(
                          //   // hint: '0.00',
                          //   // label: '',
                          //   // controller: _selectedAmtController,
                          //   // textInputType: TextInputType.number,
                          //   // validator: AppValidator.validateTextfield,
                          //   // icon: Icons.currency_exchange,
                          //   // borderColor: _selectedAmtController.text.isNotEmpty
                          //   //     ? AppColors.green
                          //   //     : AppColors.grey,
                          // ),
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var transactionPin = '';
                                transactionPin =
                                    await modalSheet.showMaterialModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.0)),
                                    ),
                                    context: context,
                                    builder: (context) => ConfirmWithPin(
                                      context: context,
                                      title:
                                      'Input your transaction pin to continue',
                                    ));
                                print(transactionPin);
                                if (transactionPin != '') {
                                  //AppNavigator.pushAndStackPage(context, page: SetTransactionPin());
                                  // billBloc.add(AirtimePurchaseEventClick(
                                  //     numberTextEditingControlller.text,
                                  //     amtTextEditingControlller.text,
                                  //     //'airtel',
                                  //     selectedServiceProvider,
                                  //     transactionPin,
                                  //     context,
                                  //     saveBeneficiary));
                                  // //AppNavigator.pushAndStackPage(context, page: PaymentSuccess());
                                }
                              }
                            },
                            disableButton: AppValidator.validateTextfield(
                                        _selectedPlan) !=
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
  final String _selectedPlan = '';

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
