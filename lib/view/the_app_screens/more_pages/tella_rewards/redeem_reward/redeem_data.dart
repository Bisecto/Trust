import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/category_model.dart' as mainCategory;
import 'package:teller_trust/model/wallet_info.dart';
import 'package:teller_trust/view/important_pages/dialog_box.dart';
import 'package:teller_trust/view/the_app_screens/sevices/product_beneficiary/product_beneficiary.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../../model/service_model.dart';
import '../../../../../res/app_colors.dart';
import '../../../../../res/app_icons.dart';
import '../../../../../res/sharedpref_key.dart';
import '../../../../../utills/app_navigator.dart';
import '../../../../../utills/app_utils.dart';
import '../../../../../utills/app_validator.dart';
import '../../../../../utills/custom_theme.dart';
import '../../../../../utills/enums/toast_mesage.dart';
import '../../../../../utills/shared_preferences.dart';
import '../../../../auth/otp_pin_pages/confirm_with_otp.dart';
import '../../../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../../../widgets/app_custom_text.dart';
import '../../../../widgets/form_button.dart';
import '../../../../widgets/form_input.dart';
import '../../../../widgets/show_toast.dart';
import '../../../../widgets/transaction_receipt.dart';
import '../../../sevices/build_payment_method.dart';
import '../../../sevices/make_bank_transfer/bank_transfer.dart';
import '../tella_point_product_container.dart';

class RedeemWithData extends StatefulWidget {
  final String category;

  const RedeemWithData({
    super.key,
    required this.category,
  });

  @override
  State<RedeemWithData> createState() => _RedeemWithDataState();
}

class _RedeemWithDataState extends State<RedeemWithData> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();
  String selectedDataPlan = 'Choose Plan';
  String selectedDataPlanPrice = '';
  bool isSaveAsBeneficiarySelected = false;
  String beneficiaryName = '';
  String selectedDataPlanId = '';
  String selectedServiceId = '';
  bool isPaymentAllowed = false;

  // final FlutterContactPicker _contactPicker = FlutterContactPicker();
  // Contact? contacts;

  @override
  void initState() {
    // TODO: implement initState
    productBloc.add(
        ListServiceEvent("1", "4", '5a048479-1b91-4a25-acde-aded88ca667c'));

    super.initState();
  }

  String _selectedPaymentMethod = 'wallet';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      height: AppUtils.deviceScreenSize(context).height / 1.1,
      decoration: BoxDecoration(
          color: theme.isDark
              ? AppColors.darkModeBackgroundColor
              : AppColors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: Column(
        children: [
          Container(
            height: (AppUtils.deviceScreenSize(context).height / 1.2) - 50,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    BlocConsumer<ProductBloc, ProductState>(
                        bloc: purchaseProductBloc,
                        listenWhen: (previous, current) =>
                            current is! ProductInitial,
                        listener: (context, state) async {
                          print(state);
                          if (state is PurchaseSuccess) {
                            _beneficiaryController.clear();
                            state.transaction.order!.product!.name ==
                                widget.category;

                            AppNavigator.pushAndStackPage(context,
                                page: TransactionReceipt(
                                    transaction: state.transaction));

                            // showToast(
                            //     context: context,
                            //     title: 'Success',
                            //     subtitle: 'Purchase was successful',
                            //     type: ToastMessageType.info);
                            //refresh();
                            //MSG.snackBar(context, state.msg);

                            // AppNavigator.pushAndRemovePreviousPages(context,
                            //     page: LandingPage(studentProfile: state.studentProfile));
                          } else if (state is QuickPayInitiated) {
                            String accessToken = await SharedPref.getString(
                                SharedPrefKey.accessTokenKey);

                            AppNavigator.pushAndStackPage(context,
                                page: MakePayment(
                                  quickPayModel: state.quickPayModel,
                                  accessToken: accessToken,
                                ));
                          } else if (state is AccessTokenExpireState) {
                            String firstame = await SharedPref.getString(
                                SharedPrefKey.firstNameKey);

                            AppNavigator.pushAndRemovePreviousPages(context,
                                page: SignInWIthAccessPinBiometrics(
                                  userName: firstame,
                                ));
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: theme.isDark
                                          ? AppColors.darkModeBackgroundColor
                                          : AppColors.white,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          top: 0, // Adjust position as needed
                                          left: 0,
                                          right: 0,
                                          child: SvgPicture.asset(
                                            AppIcons.billTopBackground,
                                            height: 60,
                                            // Increase height to fit the text
                                            width: double.infinity,
                                            color: AppColors.darkGreen,
                                            // Set the color if needed
                                            placeholderBuilder: (context) {
                                              return Container(
                                                height: 50,
                                                width: double.infinity,
                                                color: Colors.grey[300],
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 10, // Adjust position as needed
                                          left: 10,
                                          right: 10,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextStyles.textHeadings(
                                                textValue: 'Data',
                                                textColor: AppColors.darkGreen,
                                                // w: FontWeight.w600,
                                                textSize: 14,
                                              ),
                                              // Text(
                                              //   "Airtime purchase",
                                              //   style: TextStyle(
                                              //     color: AppColors.darkGreen,
                                              //     fontWeight: FontWeight.w600,
                                              //     fontSize: 18,
                                              //   ),
                                              // ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.grey,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // const SizedBox(
                                //   height: 10,
                                // ),
                                TellaPointProductContainer(
                                  showForwardIcon: false,
                                ),

                                BlocConsumer<ProductBloc, ProductState>(
                                  bloc: productBloc,
                                  builder: (context, state) {
                                    if (state is ServiceSuccessState) {
                                      ServiceModel serviceItem =
                                          state.serviceModel;
                                      List<Service> services =
                                          serviceItem.data.services;
                                      //Use user data here
                                      return SizedBox(
                                        height: 105,
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
                                                    services[index].image,
                                                    services[index].id,
                                                    theme));
                                          },
                                        ),
                                      );
                                    } else {
                                      return _loadingNetwork(); // Show loading indicator or handle error state
                                    }
                                  },
                                  listener: (BuildContext context,
                                      ProductState state) async {
                                    if (state is AccessTokenExpireState) {
                                      String firstame =
                                          await SharedPref.getString(
                                              SharedPrefKey.firstNameKey);

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
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedNetwork == '') {
                                        setState(() {
                                          MSG.warningSnackBar(context,
                                              'Please Select a service provider');
                                        });
                                      } else {
                                        modalSheet.showMaterialModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          isDismissible: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20.0),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: const EdgeInsets.only(
                                                top: 200.0),
                                            child: DataPlan(
                                              onDataPlanSelected: (String name,
                                                  String price, String id) {
                                                setState(() {
                                                  selectedDataPlan = name;
                                                  selectedDataPlanPrice = price;
                                                  selectedDataPlanId = id;
                                                });
                                                Navigator.pop(
                                                    context); // Close modal
                                              },
                                              categoryId:
                                                  '5a048479-1b91-4a25-acde-aded88ca667c',
                                              serviceId: selectedServiceId,
                                              theme: theme,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: theme.isDark
                                            ? AppColors
                                                .darkModeBackgroundContainerColor
                                            : AppColors.white,
                                        border: Border.all(
                                          color: selectedServiceId.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: CustomText(
                                                text: selectedDataPlan,
                                                size: 14,
                                                color: selectedDataPlan !=
                                                        "Choose Plan"
                                                    ? (theme.isDark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    : (theme.isDark
                                                        ? Colors.grey
                                                        : AppColors
                                                            .lightDivider),
                                              ),
                                            ),
                                            const Icon(Icons.arrow_drop_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (selectedDataPlanPrice.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: amount(selectedDataPlanPrice),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          CustomTextFormField(
                                            hint: 'Input number here',
                                            label: 'Beneficiary',
                                            controller: _beneficiaryController,
                                            textInputType: TextInputType.number,
                                            validator:
                                                AppValidator.validateTextfield,
                                            widget: SvgPicture.asset(
                                                AppIcons.nigeriaLogo),
                                            //isMobileNumber: true,
                                            suffixIcon: GestureDetector(
                                              onTap: () async {
                                                //contacts.clear();
                                                // Contact? contact =
                                                // await _contactPicker
                                                //     .selectContact();
                                                // setState(() {
                                                //   // contacts = contact!.fullName==null
                                                //   //     ? null
                                                //   //     : contact;
                                                //   // print(contacts);
                                                //   _beneficiaryController.text =
                                                //       contact!.phoneNumbers!.first;
                                                // });
                                              },
                                              child: Icon(
                                                  Icons.contact_page_outlined,
                                                  color: _beneficiaryController
                                                          .text.isNotEmpty
                                                      ? AppColors.green
                                                      : theme.isDark
                                                          ? AppColors.white
                                                          : AppColors.black),
                                            ),

                                            borderColor: _beneficiaryController
                                                    .text.isNotEmpty
                                                ? AppColors.green
                                                : AppColors.grey,
                                          ),
                                          if (selectedDataPlanId.isNotEmpty)
                                            SizedBox(
                                              height: 10,
                                            ),
                                          if (selectedDataPlanId.isNotEmpty)
                                            BeneficiaryWidget(
                                              productId: selectedDataPlanId,
                                              beneficiaryNum: (value) {
                                                setState(() {
                                                  _beneficiaryController.text =
                                                      value;
                                                });
                                              },
                                            ),
                                          SizedBox(
                                            height: 200,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          )

                                          ///Remember to add beneficiary
                                          // FormButton(
                                          //   onPressed: () async {
                                          //     if (_formKey.currentState!
                                          //         .validate()) {
                                          //       var transactionPin = '';
                                          //       // transactionPin = await modalSheet
                                          //       //     .showMaterialModalBottomSheet(
                                          //       //         backgroundColor:
                                          //       //             Colors.transparent,
                                          //       //         shape:
                                          //       //             const RoundedRectangleBorder(
                                          //       //           borderRadius:
                                          //       //               BorderRadius.vertical(
                                          //       //                   top: Radius
                                          //       //                       .circular(
                                          //       //                           20.0)),
                                          //       //         ),
                                          //       //         context: context,
                                          //       //         builder: (context) =>
                                          //       //             Padding(
                                          //       //               padding:
                                          //       //                   const EdgeInsets
                                          //       //                       .only(
                                          //       //                       top: 200.0),
                                          //       //               child: ConfirmWithPin(
                                          //       //                 context: context,
                                          //       //                 title:
                                          //       //                     'Input your transaction pin to continue',
                                          //       //               ),
                                          //       //             ));
                                          //       print(transactionPin);
                                          //       // if (transactionPin != '') {
                                          //       //   purchaseProductBloc.add(
                                          //       //       PurchaseProductEvent(
                                          //       //           context,
                                          //       //           double.parse(
                                          //       //               selectedDataPlanPrice),
                                          //       //           _beneficiaryController
                                          //       //               .text,
                                          //       //           selectedDataPlanId,
                                          //       //           transactionPin,false));
                                          //       // }
                                          //     }
                                          //   },
                                          //   disableButton: (!isPaymentAllowed &&
                                          //       _beneficiaryController
                                          //           .text.isNotEmpty),
                                          //   // selectedDataPlanId.isNotEmpty &&
                                          //   //     _beneficiaryController.text=='',
                                          //   text: 'Purchase Data',
                                          //   borderColor: AppColors.darkGreen,
                                          //   bgColor: AppColors.darkGreen,
                                          //   textColor: AppColors.white,
                                          //   borderRadius: 10,
                                          // )
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
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: FormButton(
              // onPressed: () async {
              //   print(_selectedPaymentMethod);
              //   print(selectedDataPlanPrice);
              //   print(_beneficiaryController.text.isNotEmpty);
              //   print(!isPaymentAllowed);
              //
              //   if (_formKey.currentState!.validate()) {
              //     if (_selectedPaymentMethod != 'wallet') {
              //       var transactionPin = '';
              //       widget.category.requiredFields.amount =
              //           selectedDataPlanPrice;
              //       widget.category.requiredFields.phoneNumber =
              //           _beneficiaryController.text;
              //
              //       purchaseProductBloc.add(PurchaseProductEvent(
              //           context,
              //           widget.category.requiredFields,
              //           selectedDataPlanId,
              //           transactionPin,
              //           true,
              //           isSaveAsBeneficiarySelected,
              //           beneficiaryName));
              //     } else {
              //       var transactionPin = '';
              //       transactionPin =
              //           await modalSheet.showMaterialModalBottomSheet(
              //               backgroundColor: Colors.transparent,
              //               isDismissible: true,
              //               shape: const RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.vertical(
              //                     top: Radius.circular(20.0)),
              //               ),
              //               context: context,
              //               builder: (context) => Padding(
              //                     padding: const EdgeInsets.only(top: 200.0),
              //                     child: ConfirmWithPin(
              //                       context: context,
              //                       title:
              //                           'Input your transaction pin to continue',
              //                     ),
              //                   ));
              //       print(transactionPin);
              //       if (transactionPin != '') {
              //         setState(() {
              //           widget.category.requiredFields.amount =
              //               selectedDataPlanPrice;
              //           widget.category.requiredFields.phoneNumber =
              //               _beneficiaryController.text;
              //         });
              //
              //         purchaseProductBloc.add(PurchaseProductEvent(
              //             context,
              //             widget.category.requiredFields,
              //             selectedDataPlanId,
              //             transactionPin,
              //             false,
              //             isSaveAsBeneficiarySelected,
              //             beneficiaryName));
              //       }
              //     }
              //   }
              // },
              disableButton: (!isPaymentAllowed ||
                  _beneficiaryController.text.length < 10),
              text: 'Purchase Data',
              borderColor: AppColors.darkGreen,
              bgColor: AppColors.darkGreen,
              textColor: AppColors.white,
              borderRadius: 10,
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget _loadingNetwork() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        //physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)))),
                  const SizedBox(height: 10),
                  Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(milliseconds: 50),
                    color: Colors.grey.withOpacity(0.5),
                    colorOpacity: 0.5,
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 10,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(milliseconds: 50),
                    color: Colors.grey.withOpacity(0.5),
                    colorOpacity: 0.5,
                    enabled: true,
                    direction: ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }

  Widget amount(String amt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGreen)),
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

  Widget _loadingBeneficiaries() {
    return SizedBox(
      height: AppUtils.deviceScreenSize(context).width / 5,
      width: AppUtils.deviceScreenSize(context).width / 5,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        //physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)))),
                  const SizedBox(height: 10),
                  Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(milliseconds: 50),
                    color: Colors.grey.withOpacity(0.5),
                    colorOpacity: 0.5,
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 10,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Shimmer(
                    duration: const Duration(seconds: 1),
                    interval: const Duration(milliseconds: 50),
                    color: Colors.grey.withOpacity(0.5),
                    colorOpacity: 0.5,
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final String _selectedPlan = '';

  String selectedNetwork = "";
  final _beneficiaryController = TextEditingController();

  Widget networkProviderItem(String name, String image, String id, theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: AppUtils.deviceScreenSize(context).width / 5,
        width: AppUtils.deviceScreenSize(context).width / 5,
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
                selectedServiceId = id;
                selectedDataPlanPrice = '';
                selectedDataPlanId = '';
                selectedDataPlan = 'Choose Plan';
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
                const SizedBox(
                  height: 5,
                ),
                if (selectedNetwork == name.toLowerCase())
                  TextStyles.textHeadings(
                      textValue: name,
                      textSize: 12,
                      textColor: AppColors.darkGreen),
                if (selectedNetwork != name.toLowerCase())
                  CustomText(
                    text: name,
                    //color: AppColors.black,
                    size: 12,
                    weight: FontWeight.bold,
                    color: selectedNetwork == name.toLowerCase()
                        ? AppColors.darkGreen
                        : theme.isDark
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

class DataPlan extends StatelessWidget {
  final String categoryId;
  final String serviceId;
  final AdaptiveThemeMode theme;
  final Function(String, String, String) onDataPlanSelected;

  const DataPlan(
      {Key? key,
      required this.serviceId,
      required this.categoryId,
      required this.onDataPlanSelected,
      required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => ProductBloc(),
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundColor
                        : AppColors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0, // Adjust position as needed
                        left: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          AppIcons.billTopBackground,
                          height: 60,
                          // Increase height to fit the text
                          width: double.infinity,
                          color: AppColors.darkGreen,
                          // Set the color if needed
                          placeholderBuilder: (context) {
                            return Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10, // Adjust position as needed
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextStyles.textHeadings(
                              textValue: 'Data Plans',
                              textColor: AppColors.darkGreen,
                              // w: FontWeight.w600,
                              textSize: 14,
                            ),
                            // Text(
                            //   "Airtime purchase",
                            //   style: TextStyle(
                            //     color: AppColors.darkGreen,
                            //     fontWeight: FontWeight.w600,
                            //     fontSize: 18,
                            //   ),
                            // ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: DataPlanList(
                  onDataPlanSelected: onDataPlanSelected,
                  serviceId: serviceId,
                  categoryId: categoryId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataPlanList extends StatefulWidget {
  final String categoryId;
  final String serviceId;
  final Function(String, String, String) onDataPlanSelected;

  const DataPlanList({
    Key? key,
    required this.serviceId,
    required this.categoryId,
    required this.onDataPlanSelected,
  }) : super(key: key);

  @override
  _DataPlanListState createState() => _DataPlanListState();
}

class _DataPlanListState extends State<DataPlanList> {
  final TextEditingController _searchController = TextEditingController();
  int page = 1;
  ProductBloc productListBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchDataPlan('', page, widget.categoryId, widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      color: theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          child: Column(
            children: [
              CustomTextFormField(
                hint: 'Search Data plan',
                label: '',
                controller: _searchController,
                validator: AppValidator.validateAccountNumberfield,
                widget: const Icon(Icons.search),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  bloc: productListBloc,
                  builder: (context, state) {
                    if (state is ProductLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductSuccessState) {
                      final product = state;
                      return ListView.builder(
                        itemCount: product.productModel.data.items.length,
                        itemBuilder: (context, index) {
                          final singleProduct =
                              product.productModel.data.items[index];
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: ListTile(
                                onTap: () {
                                  widget.onDataPlanSelected(
                                    singleProduct.name,
                                    singleProduct.buyerPrice.toString(),
                                    singleProduct.id,
                                  );
                                },
                                title: CustomText(
                                  text: singleProduct.name,
                                  size: 14,
                                  weight: FontWeight.w700,
                                ),
                                subtitle: Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.naira,
                                      color: AppColors.green,
                                    ),
                                    CustomText(
                                      text: singleProduct.buyerPrice.toString(),
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                )
                                //shape: ShapeBorder(),
                                ),
                          );
                        },
                      );
                    } else if (state is ProductErrorState) {
                      final error = state;
                      return Center(
                        child: Text(error.error),
                      );
                    }
                    return Container(); // Placeholder, should never be reached
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged() {
    page = 1; // Reset page number to 1 when search query changes
    _fetchDataPlan(
        _searchController.text, page, widget.categoryId, widget.serviceId);
  }

  void _fetchDataPlan(String query, int pageNo, categoryId, serviceId) {
    productListBloc
        .add(FetchProduct(query, pageNo.toString(), 20, categoryId, serviceId));
    page++; // Increment page number after making the request
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
