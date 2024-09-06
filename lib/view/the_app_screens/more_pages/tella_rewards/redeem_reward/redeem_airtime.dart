import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/service_model.dart' as serviceModel;
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/view/the_app_screens/sevices/make_bank_transfer/bank_transfer.dart';
import 'package:teller_trust/view/the_app_screens/sevices/product_beneficiary/product_beneficiary.dart';
import 'package:teller_trust/view/widgets/purchase_receipt.dart';

import '../../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../../model/wallet_info.dart';
import '../../../../../repository/app_repository.dart';
import '../../../../../res/apis.dart';
import '../../../../../res/app_colors.dart';
import '../../../../../res/sharedpref_key.dart';
import '../../../../../utills/app_navigator.dart';
import '../../../../../utills/app_utils.dart';
import '../../../../../utills/app_validator.dart';
import '../../../../../utills/custom_theme.dart';
import '../../../../../utills/enums/toast_mesage.dart';
import '../../../../../utills/shared_preferences.dart';
import '../../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../../model/category_model.dart' as categoryModel;
import '../../../../../model/product_model.dart' as productMode;
import '../../../../../model/wallet_info.dart';
import '../../../../../repository/app_repository.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../../../auth/otp_pin_pages/confirm_with_otp.dart';
import '../../../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../../../widgets/app_custom_text.dart';
import '../../../../widgets/form_button.dart';
import '../../../../widgets/form_input.dart';
import '../../../../widgets/show_toast.dart';
import '../../../../widgets/transaction_receipt.dart';
import '../tella_point_product_container.dart';

class RedeemWithAirtime extends StatefulWidget {
  final String category;

  const RedeemWithAirtime({super.key, required this.category});

  @override
  State<RedeemWithAirtime> createState() => _RedeemWithAirtimeState();
}

class _RedeemWithAirtimeState extends State<RedeemWithAirtime> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();
  String _selectedPaymentMethod = 'wallet';
  bool isPaymentAllowed = false;

  // final FlutterContactPicker _contactPicker = FlutterContactPicker();
  // Contact? contacts;

  @override
  void initState() {
    // TODO: implement initState
    productBloc.add(
        ListServiceEvent("1", "4", "73d3270a-1446-45ed-ac9b-d55c7e82cf65"));

    super.initState();
  }

  bool isInitial = true;
  String productId = '';

  void _handleNetworkSelect(String? networkName) async {
    setState(() {
      productId = '';
    });
    AppRepository appRepository = AppRepository();
    String accessToken =
        await SharedPref.getString(SharedPrefKey.accessTokenKey);
    String apiUrl =
        '${AppApis.listProduct}?page=1&pageSize=10&categoryId=${'73d3270a-1446-45ed-ac9b-d55c7e82cf65'}&serviceId=$networkName';

    try {
      var listServiceResponse = await appRepository.appGetRequest(
        apiUrl,
        accessToken: accessToken,
      );

      if (listServiceResponse.statusCode == 200) {
        print("productModel dtddhdhd: ${listServiceResponse.body}");
        productMode.ProductModel productModel =
            productMode.ProductModel.fromJson(
                json.decode(listServiceResponse.body));
        setState(() {
          productId = productModel.data.items[0].id;
          isInitial = false;
        });
        print(productId);
        // Process the data as needed
      } else {
        print("Error: ${listServiceResponse.statusCode}");
        // Handle error
      }
    } catch (e) {
      print("Network request failed: $e");
      // Handle exception
    }
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BlocConsumer<ProductBloc, ProductState>(
                        bloc: purchaseProductBloc,
                        listenWhen: (previous, current) =>
                            current is! ProductInitial,
                        listener: (context, state) async {
                          print(state);
                          if (state is PurchaseSuccess) {
                            _beneficiaryController.clear();
                            _selectedAmtController.clear();

                            ///CHECK THIS
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
                            // showToast(
                            //     context: context,
                            //     title: 'Token expired',
                            //     subtitle: 'Login again.',
                            //     type: ToastMessageType.error);

                            //MSG.warningSnackBar(context, state.error);

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
                              children: [
                                Container(
                                  height: 60,
                                  width: double.infinity,
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
                                            width: AppUtils.deviceScreenSize(
                                                    context)
                                                .width,
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
                                                textValue: 'Airtime',
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
                                // Padding(
                                //     padding: const EdgeInsets.all(15.0),
                                //     child: Beneficiary(
                                //       billType: 'airtime',
                                //       onBeneficiarySelected: (phone) {
                                //         setState(() {
                                //           numberTextEditingControlller.text =
                                //               phone; // Update the selected beneficiary's phone number
                                //         });
                                //       },
                                //     )),
                                TellaPointProductContainer(
                                  showForwardIcon: false,
                                ),
                                BlocConsumer<ProductBloc, ProductState>(
                                  bloc: productBloc,
                                  builder: (context, state) {
                                    if (state is ServiceSuccessState) {
                                      serviceModel.ServiceModel serviceItem =
                                          state.serviceModel;
                                      List<serviceModel.Service> services =
                                          serviceItem.data.services;
                                      if (isInitial) {
                                        // _handleNetworkSelect(services
                                        //     .firstWhere(
                                        //         (service) =>
                                        //             service.name.toLowerCase() ==
                                        //             'mtn'.toLowerCase(),
                                        //         orElse: () => serviceModel.Service(
                                        //             image: '',
                                        //             id: '',
                                        //             name: '',
                                        //             slug: '',
                                        //             category: serviceModel.Category(
                                        //                 id: '',
                                        //                 name: '',
                                        //                 slug: '')))
                                        //     .id);
                                      }
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
                                                    services[index].image,
                                                    theme,
                                                    () => _handleNetworkSelect(services
                                                        .firstWhere(
                                                            (service) =>
                                                                service.name
                                                                    .toLowerCase() ==
                                                                services[index]
                                                                    .name
                                                                    .toLowerCase(),
                                                            orElse: () => serviceModel.Service(
                                                                image: '',
                                                                id: '',
                                                                name: '',
                                                                slug: '',
                                                                category: serviceModel
                                                                    .Category(
                                                                        id: '',
                                                                        name:
                                                                            '',
                                                                        slug:
                                                                            '')))
                                                        .id)));
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
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0, 10, 10),
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
                                            widget: SvgPicture.asset(
                                              AppIcons.naira,
                                              color: _selectedAmtController
                                                      .text.isNotEmpty
                                                  ? AppColors.darkGreen
                                                  : AppColors.grey,
                                              height: 22,
                                              width: 22,
                                            ),
                                            borderColor: _selectedAmtController
                                                    .text.isNotEmpty
                                                ? AppColors.green
                                                : AppColors.grey,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              //selectAmount("2000"),
                                              selectAmount("200", theme),
                                              selectAmount("500", theme),
                                              selectAmount("1000", theme),
                                              selectAmount("1500", theme),
                                              selectAmount("2000", theme),
                                            ],
                                          ),

                                          CustomTextFormField(
                                            hint: 'Input number here',
                                            label: 'Beneficiary',

                                            controller: _beneficiaryController,
                                            textInputType: TextInputType.number,
                                            validator:
                                                AppValidator.validateTextfield,
                                            widget: SvgPicture.asset(
                                                AppIcons.nigeriaLogo),
                                            suffixIcon: GestureDetector(
                                              onTap: () async {
                                                //contacts.clear();
                                                // Contact? contact =
                                                //     await _contactPicker
                                                //         .selectContact();
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
                                            //isMobileNumber: true,
                                            borderColor: _beneficiaryController
                                                    .text.isNotEmpty
                                                ? AppColors.green
                                                : AppColors.grey,
                                          ),
                                          if (productId.isNotEmpty)
                                            SizedBox(
                                              height: 10,
                                            ),
                                          if (productId.isNotEmpty)
                                            BeneficiaryWidget(
                                              productId: productId,
                                              beneficiaryNum: (value) {
                                                setState(() {
                                                  _beneficiaryController.text =
                                                      value;
                                                });
                                              },
                                            ),

                                          ///Remember to add beneficiary
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
              //   print(beneficiaryName);
              //   print(isSaveAsBeneficiarySelected);
              //   print(_selectedPaymentMethod);
              //   print(_beneficiaryController.text.isNotEmpty);
              //   print(!isPaymentAllowed);
              //
              //   if (_formKey.currentState!.validate()) {
              //     if (productId != '') {
              //       if (_selectedPaymentMethod != 'wallet') {
              //         var transactionPin = '';
              //         widget.category.requiredFields.amount =
              //             _selectedAmtController.text;
              //         widget.category.requiredFields.phoneNumber =
              //             _beneficiaryController.text;
              //
              //         purchaseProductBloc.add(PurchaseProductEvent(
              //             context,
              //             widget.category.requiredFields,
              //             productId,
              //             transactionPin,
              //             true,
              //             isSaveAsBeneficiarySelected,
              //             beneficiaryName));
              //       } else {
              //         var transactionPin = '';
              //         transactionPin =
              //         await modalSheet.showMaterialModalBottomSheet(
              //             backgroundColor: Colors.transparent,
              //             isDismissible: true,
              //             shape: const RoundedRectangleBorder(
              //               borderRadius: BorderRadius.vertical(
              //                   top: Radius.circular(20.0)),
              //             ),
              //             context: context,
              //             builder: (context) => Padding(
              //               padding: const EdgeInsets.only(top: 200.0),
              //               child: ConfirmWithPin(
              //                 context: context,
              //                 title:
              //                 'Input your transaction pin to continue',
              //               ),
              //             ));
              //         print(transactionPin);
              //         if (transactionPin != '') {
              //           setState(() {
              //             widget.category.requiredFields.amount =
              //                 _selectedAmtController.text;
              //             widget.category.requiredFields.phoneNumber =
              //                 _beneficiaryController.text;
              //           });
              //
              //           purchaseProductBloc.add(PurchaseProductEvent(
              //               context,
              //               widget.category.requiredFields,
              //               productId,
              //               transactionPin,
              //               false,
              //               isSaveAsBeneficiarySelected,
              //               beneficiaryName));
              //         }
              //       }
              //     } else {
              //       showToast(
              //           context: context,
              //           title: 'Info',
              //           subtitle: 'Please select a network provider',
              //           type: ToastMessageType.info);
              //     }
              //   }
              // },
              disableButton: (!isPaymentAllowed ||
                  !_beneficiaryController.text.isNotEmpty),
              text: 'Purchase Airtime',
              borderColor: AppColors.darkGreen,
              bgColor: AppColors.darkGreen,
              textColor: AppColors.white,
              borderRadius: 10,
              width: AppUtils.deviceScreenSize(context).width,
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  String selectedNetwork = "";
  final _beneficiaryController = TextEditingController();
  final _selectedAmtController = TextEditingController();
  bool isSaveAsBeneficiarySelected = false;
  String beneficiaryName = '';

  Widget selectAmount(String amt, AdaptiveThemeMode theme) {
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
              child: TextStyles.textDetails(
                  textValue: "₦ $amt", textColor: AppColors.textColor)),
        ),
      ),
    );
  }

  Widget networkProviderItem(
    String name,
    String image,
    AdaptiveThemeMode theme,
    void Function() onNetworkSelect, // Callback for network request
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: AppUtils.deviceScreenSize(context).width / 5,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: selectedNetwork == name.toLowerCase()
                ? AppColors.darkGreen
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedNetwork = name.toLowerCase();
              });
              onNetworkSelect(); // Trigger the network request
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(image),
                ),
                if (selectedNetwork == name.toLowerCase())
                  TextStyles.textHeadings(
                    textValue: name,
                    textSize: 12,
                    textColor: AppColors.darkGreen,
                  ),
                if (selectedNetwork != name.toLowerCase())
                  CustomText(
                    text: name,
                    size: 10,
                    weight: FontWeight.bold,
                    color: selectedNetwork == name.toLowerCase()
                        ? AppColors.darkGreen
                        : theme.isDark
                            ? AppColors.white
                            : AppColors.black,
                  ),
              ],
            ),
          ),
        ),
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
