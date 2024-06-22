import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/model/quick_access_model.dart';
import 'package:teller_trust/model/service_model.dart';
import 'package:teller_trust/res/app_icons.dart';

import '../../../bloc/product_bloc/product_bloc.dart';
import '../../../model/category_model.dart' as categoryModel;
import '../../../res/app_colors.dart';
import '../../../res/app_list.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../../utills/shared_preferences.dart';
import '../../auth/otp_pin_pages/confirm_with_otp.dart';
import '../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../widgets/show_toast.dart';

class AirtimePurchase extends StatefulWidget {
  final categoryModel.Category category;

  const AirtimePurchase({super.key, required this.category});

  @override
  State<AirtimePurchase> createState() => _AirtimePurchaseState();
}

class _AirtimePurchaseState extends State<AirtimePurchase> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();

  @override
  void initState() {
    // TODO: implement initState
    productBloc.add(ListServiceEvent("1", "4", widget.category.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: AppUtils
            .deviceScreenSize(context)
            .height - 100,
        decoration: BoxDecoration(
            color: theme.isDark
        ? AppColors.darkModeBackgroundColor
            : AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocConsumer<ProductBloc, ProductState>(
                    bloc: purchaseProductBloc,
                    listenWhen: (previous, current) =>
                    current is! ProductInitial,
                    listener: (context, state) async {
                      print(state);
                      if (state is PurchaseSuccess) {
                        showToast(
                            context: context,
                            title: 'Success',
                            subtitle: 'Purchase was successful',
                            type: ToastMessageType.info);
                        //refresh();
                        //MSG.snackBar(context, state.msg);

                        // AppNavigator.pushAndRemovePreviousPages(context,
                        //     page: LandingPage(studentProfile: state.studentProfile));
                      } else if (state is AccessTokenExpireState) {
                        showToast(
                            context: context,
                            title: 'Info',
                            subtitle: 'Incorrect Access Pin',
                            type: ToastMessageType.error);

                        //MSG.warningSnackBar(context, state.error);

                        // String firstame =
                        //     await SharedPref.getString('firstName');
                        //
                        // AppNavigator.pushAndRemovePreviousPages(context,
                        //     page: SignInWIthAccessPinBiometrics(
                        //       userName: firstame,
                        //     ));
                      } else if (state is PurchaseErrorState) {
                        showToast(
                            context: context,
                            title: 'Info',
                            subtitle: state.error,
                            type: ToastMessageType.error);

                        //MSG.warningSnackBar(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: theme.isDark
                                      ? AppColors.darkModeBackgroundColor
                                      : AppColors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.billTopBackground,
                                      height: 50,
                                      // Increase height to fit the text
                                      width: double.infinity,
                                      color: AppColors.darkGreen,
                                      // Set the color if needed
                                      placeholderBuilder: (context) {
                                        return Container(
                                          height: 50,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: Center(
                                              child: CircularProgressIndicator()),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 20, // Adjust position as needed
                                      left: 20,
                                      right: 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          TextStyles.textHeadings(
                                            textValue: 'Airtime',
                                            textColor: AppColors.darkGreen,
                                           // w: FontWeight.w600,
                                            textSize: 14,),
                                          // Text(
                                          //   "Airtime purchase",
                                          //   style: TextStyle(
                                          //     color: AppColors.darkGreen,
                                          //     fontWeight: FontWeight.w600,
                                          //     fontSize: 18,
                                          //   ),
                                          // ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.cancel,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ),),
                            SizedBox(
                              height: 10,
                            ),
                            BlocConsumer<ProductBloc, ProductState>(
                              bloc: productBloc,
                              builder: (context, state) {
                                if (state is ServiceSuccessState) {
                                  ServiceModel serviceItem = state.serviceModel;
                                  List<Service> services =
                                      serviceItem.data.services;
                                  //Use user data here
                                  return SizedBox(
                                    height: 90,
                                    child: ListView.builder(
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      //   crossAxisCount: 4,
                                      //   crossAxisSpacing: 8.0,
                                      //   mainAxisSpacing: 8.0,
                                      // ),
                                      itemCount: services.length,
                                      //AppList().serviceItems.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              String selectedAction = '';
                                              setState(() {
                                                //selectedAction=services[index].name;
                                              });

                                              //showAirtimeModal(context, AppList().serviceItems[index]);
                                            },
                                            child: networkProviderItem(
                                                services[index].name,
                                                services[index].image,theme));
                                      },
                                    ),
                                  );
                                } else {
                                  return const CustomText(
                                    text: "There",
                                    size: 15,
                                    weight: FontWeight.bold,
                                    color: AppColors.white,
                                  ); // Show loading indicator or handle error state
                                }
                              },
                              listener: (BuildContext context,
                                  ProductState state) async {
                                if (state is AccessTokenExpireState) {
                                  String firstame =
                                  await SharedPref.getString('firstName');

                                  AppNavigator.pushAndRemovePreviousPages(
                                      context,
                                      page: SignInWIthAccessPinBiometrics(
                                        userName: firstame,
                                      ));
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomTextFormField(
                                        hint: '0.00',
                                        label: 'Select Amount',
                                        controller: _selectedAmtController,
                                        textInputType: TextInputType.number,
                                        validator:
                                        AppValidator.validateTextfield,
                                        icon: Icons.currency_exchange,
                                        borderColor: _selectedAmtController
                                            .text.isNotEmpty
                                            ? AppColors.green
                                            : AppColors.grey,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          //selectAmount("2000"),
                                          selectAmount("2000",theme),
                                          selectAmount("1500",theme),
                                          selectAmount("1000",theme),
                                          selectAmount("500",theme),
                                          selectAmount("200",theme),
                                        ],
                                      ),
                                      CustomTextFormField(
                                        hint: 'Input number here',
                                        label: 'Beneficiary',

                                        controller: _beneficiaryController,
                                        textInputType: TextInputType.number,
                                        validator:
                                        AppValidator.validateTextfield,
                                        icon: Icons.flag,

                                        //isMobileNumber: true,
                                        borderColor: _beneficiaryController
                                            .text.isNotEmpty
                                            ? AppColors.green
                                            : AppColors.grey,
                                      ),

                                      ///Remember to add beneficiary
                                      FormButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            var transactionPin = '';
                                            transactionPin = await modalSheet
                                                .showMaterialModalBottomSheet(
                                                backgroundColor:
                                                Colors.transparent,
                                                shape:
                                                const RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius
                                                          .circular(
                                                          20.0)),
                                                ),
                                                context: context,
                                                builder: (context) =>
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          top: 200.0),
                                                      child: ConfirmWithPin(
                                                        context: context,
                                                        title:
                                                        'Input your transaction pin to continue',
                                                      ),
                                                    ));
                                            print(transactionPin);
                                            if (transactionPin != '') {
                                              purchaseProductBloc.add(
                                                  PurchaseProductEvent(
                                                      context,
                                                      double.parse(
                                                          _selectedAmtController
                                                              .text),
                                                      _beneficiaryController
                                                          .text,
                                                      '',
                                                      transactionPin));
                                            }
                                          }
                                        },
                                        disableButton: _selectedAmtController
                                            .text.isEmpty &&
                                            _beneficiaryController.text.isEmpty,
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
                      );
                    }),
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

  Widget selectAmount(String amt,AdaptiveThemeMode theme) {
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
              //color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.textColor)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextStyles.textDetails(textValue:  "₦ $amt",textColor: AppColors.textColor)
          ),
        ),
      ),
    );
  }

  Widget networkProviderItem(String name, String image,AdaptiveThemeMode theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: AppUtils
        //     .deviceScreenSize(context)
        //     .width / 5,
        width: AppUtils
            .deviceScreenSize(context)
            .width / 5,
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
                color: selectedNetwork == name.toLowerCase()
                    ? AppColors.darkGreen
                    : Colors.transparent),
            // color: selectedNetwork == name.toLowerCase()
            //     ? AppColors.lightShadowGreenColor
            //     : Colors.transparent,
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
                  backgroundImage: NetworkImage(image),
                  //child: Image.asset(image,height: 20,width: 20,),
                ),
                if(selectedNetwork == name.toLowerCase())
                TextStyles.textHeadings(textValue: name,textSize: 12,textColor: AppColors.darkGreen),
                if(selectedNetwork != name.toLowerCase())

                  CustomText(
                  text: name,
                  //color: AppColors.black,
                  size: 12,
                  weight: FontWeight.bold,
                  color:selectedNetwork == name.toLowerCase()
                      ? AppColors.darkGreen: theme.isDark
                      ? AppColors.white
                      : AppColors.black,
                )
              ],
            ),
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
