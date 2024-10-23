import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/category_model.dart' as mainCategory;
import 'package:teller_trust/view/important_pages/dialog_box.dart';
import 'package:teller_trust/view/the_app_screens/sevices/product_beneficiary/product_beneficiary.dart';

import '../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../model/wallet_info.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';
import '../../../../res/app_images.dart';
import '../../../../res/sharedpref_key.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/app_validator.dart';
import '../../../../utills/custom_theme.dart';
import '../../../../utills/enums/toast_mesage.dart';
import '../../../../utills/shared_preferences.dart';
import '../../../auth/otp_pin_pages/confirm_with_otp.dart';
import '../../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_button.dart';
import '../../../widgets/form_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../../widgets/purchase_receipt.dart';
import '../../../widgets/show_toast.dart';
import '../../../widgets/transaction_receipt.dart';
import '../../more_pages/tella_rewards/tella_point_product_container.dart';
import '../payment_method/payment_method.dart';
import '../make_bank_transfer/bank_transfer.dart';

class CablePurchase extends StatefulWidget {
  final mainCategory.Category category;
  final WalletInfo walletInfo;


  const CablePurchase({super.key, required this.category, required this.walletInfo});

  @override
  State<CablePurchase> createState() => _CablePurchaseState();
}

class _CablePurchaseState extends State<CablePurchase> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();
  ProductBloc verifyEntityNumberProductBloc = ProductBloc();
  String selectedCableProvider = 'Choose Provider';
  String selectedCableProviderImage = '';
  String selectedCableProviderId = '';
  String selectedServiceId = '';
  String serviceID = '';
  bool isPaymentAllowed = false;
  final _selectedAmtController = TextEditingController();
  bool isSaveAsBeneficiarySelected = false;
  String beneficiaryName = '';

//bool isBeneficiaryAllowed=false;
  String selectedCablePlan = 'Choose Plan';
  String selectedCablePlanPrice = '';
  String selectedCablePlanId = '';
  TextEditingController _beneficiaryController = TextEditingController();
  CancelableOperation<void>? _cancelableOperation; // Store the current operation

  @override
  void dispose() {
    _beneficiaryController.dispose();
    _cancelableOperation?.cancel(); // Cancel any ongoing operations on dispose
    super.dispose();
  }
  // Future<String> handleNetworkSelect(String? selectedServiceId) async {
  //   AppRepository appRepository = AppRepository();
  //   String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
  //   String apiUrl =
  //       '${AppApis.listProduct}?page=1&pageSize=10&categoryId=${widget.category
  //       .id}&serviceId=$selectedServiceId';
  //
  //   try {
  //     var listServiceResponse = await appRepository.appGetRequest(
  //       apiUrl,
  //       accessToken: accessToken,
  //     );
  //
  //     if (listServiceResponse.statusCode == 200) {
  //       print("productModel dtddhdhd: ${listServiceResponse.body}");
  //       productMode.ProductModel productModel =
  //       productMode.ProductModel.fromJson(
  //           json.decode(listServiceResponse.body));
  //       setState(() {
  //         serviceID = productModel.data.items[0].id;
  //       });
  //       print(productModel);
  //       print(serviceID);
  //
  //       return serviceID;
  //       // Process the data as needed
  //     } else {
  //       print("Error: ${listServiceResponse.statusCode}");
  //       return '';
  //
  //       // Handle error
  //     }
  //   } catch (e) {
  //     return '';
  //
  //     print("Network request failed: $e");
  //     // Handle exception
  //   }
  // }
  void _onInputChanged(String value) {
    if (value.length > 9 && selectedCableProviderId.isNotEmpty) {
      // Cancel the previous request if it exists
      _cancelableOperation?.cancel();

      // Create a new cancelable operation for the current request
      _cancelableOperation = CancelableOperation.fromFuture(
        verifyEntityNumber(value), // The function that sends the request
        onCancel: () {
          print("Previous request canceled");
        },
      );

      // Handle the response
      _cancelableOperation!.value.then((response) {
        if (mounted) {
          // Process the response here
        }
      }).catchError((error) {
        // Handle the error here
      });
    }else{
      MSG.warningSnackBar(context, 'Please enter a valid cable number or select a valid provider');
    }
  }
  Future<void> verifyEntityNumber(String meterNumber) async {
    // Simulate an API request or call your Bloc event here
    verifyEntityNumberProductBloc.add(
      VerifyEntityNumberEvent(selectedCablePlanId, meterNumber),
    );
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  String _selectedPaymentMethod = 'wallet';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      height: AppUtils.deviceScreenSize(context).height/ 1.1,
      decoration: BoxDecoration(
          color: theme.isDark
              ? AppColors.darkModeBackgroundColor
              : AppColors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: Column(
        children: [
          Container(
            height: (AppUtils.deviceScreenSize(context).height/ 1.2)-50,

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
                            //_selectedAmtController.clear();
                            state.transaction.order!.product!.name ==
                                widget.category.name;

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
                            String accessToken =
                            await SharedPref.getString(SharedPrefKey.accessTokenKey);

                            AppNavigator.pushAndStackPage(context,
                                page: MakePayment(
                                  quickPayModel: state.quickPayModel,
                                  accessToken: accessToken,
                                ));
                          } else if (state is AccessTokenExpireState) {
                            String firstame =
                            await SharedPref.getString(SharedPrefKey.firstNameKey);

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
                                                textValue: 'Cable',
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
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.grey,
                                                  size:30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //(),

                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // BlocConsumer<ProductBloc, ProductState>(
                                //   bloc: productBloc,
                                //   builder: (context, state) {
                                //     if (state is ServiceSuccessState) {
                                //       ServiceModel serviceItem = state.serviceModel;
                                //       List<Service> services =
                                //           serviceItem.data.services;
                                //       //Use user Cable here
                                //       return SizedBox(
                                //         height: 105,
                                //         child: ListView.builder(
                                //           physics:
                                //           const NeverScrollableScrollPhysics(),
                                //           scrollDirection: Axis.horizontal,
                                //           // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                //           //   crossAxisCount: 4,
                                //           //   crossAxisSpacing: 8.0,
                                //           //   mainAxisSpacing: 8.0,
                                //           // ),
                                //           itemCount: services.length,
                                //           //AppList().serviceItems.length,
                                //           itemBuilder: (context, index) {
                                //             return GestureDetector(
                                //                 onTap: () {
                                //                   String selectedAction = '';
                                //                   setState(() {
                                //                     //selectedAction=services[index].name;
                                //                   });
                                //
                                //                   //showAirtimeModal(context, AppList().serviceItems[index]);
                                //                 },
                                //                 child: networkProviderItem(
                                //                     services[index].name,
                                //                     services[index].image,
                                //                     services[index].id,
                                //                     theme));
                                //           },
                                //         ),
                                //       );
                                //     } else {
                                //       return const CustomText(
                                //         text: "     Loading.....",
                                //         size: 15,
                                //         weight: FontWeight.bold,
                                //         color: AppColors.white,
                                //       ); // Show loading indicator or handle error state
                                //     }
                                //   },
                                //   listener: (BuildContext context,
                                //       ProductState state) async {
                                //     if (state is AccessTokenExpireState) {
                                //       String firstame =
                                //       await SharedPref.getString('firstName');
                                //
                                //       AppNavigator.pushAndRemovePreviousPages(
                                //           context,
                                //           page: SignInWIthAccessPinBiometrics(
                                //             userName: firstame,
                                //           ));
                                //     }
                                //   },
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () {
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
                                          padding:
                                          const EdgeInsets.only(top: 200.0),
                                          child: CableProvider(
                                            onCableProviderSelected: (String name,
                                                String imageUrl, String id) async {
                                              setState(() {
                                                selectedCableProvider = name;
                                                selectedCableProviderImage =
                                                    imageUrl;
                                                selectedCableProviderId = id;
                                              });
                                              print(selectedCableProviderId);
                                              Navigator.pop(context); // Close modal

                                              // if (_beneficiaryController
                                              //     .text.length >
                                              //     9 &&
                                              //     mainServiceId != '') {
                                              //   verifyEntityNumberProductBloc
                                              //       .add(
                                              //       VerifyEntityNumberEvent(
                                              //           mainServiceId,
                                              //           _beneficiaryController
                                              //               .text));
                                              // }
                                            },
                                            categoryId: widget.category.id,
                                            serviceId: selectedServiceId,
                                            theme: theme,
                                          ),
                                        ),
                                      );
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
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 25.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (selectedCableProvider !=
                                                "Choose Provider")
                                              Image.network(
                                                selectedCableProviderImage,
                                                height: 24,
                                                width: 24,
                                              ),
                                            if (selectedCableProvider !=
                                                "Choose Provider")
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            Expanded(
                                              child: CustomText(
                                                text: selectedCableProvider,
                                                size: 14,
                                                color: selectedCableProvider !=
                                                    "Choose Provider"
                                                    ? (theme.isDark
                                                    ? Colors.white
                                                    : Colors.black)
                                                    : (theme.isDark
                                                    ? Colors.grey
                                                    : AppColors.lightDivider),
                                              ),
                                            ),
                                            const Icon(Icons.arrow_drop_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedCableProvider ==
                                          'Choose Provider') {
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
                                            padding:
                                            const EdgeInsets.only(top: 200.0),
                                            child: CablePlan(
                                              onCablePlanSelected: (String name,
                                                  String price, String id) {
                                                setState(() {
                                                  selectedCablePlan = name;
                                                  selectedCablePlanPrice = price;
                                                  _selectedAmtController.text =
                                                      price;
                                                  selectedCablePlanId = id;
                                                });
                                                Navigator.pop(
                                                    context); // Close modal
                                              },
                                              categoryId: widget.category.id,
                                              serviceId: selectedCableProviderId,
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
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 25.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: CustomText(
                                                text: selectedCablePlan,
                                                size: 14,
                                                color: selectedCablePlan !=
                                                    "Choose Plan"
                                                    ? (theme.isDark
                                                    ? Colors.white
                                                    : Colors.black)
                                                    : (theme.isDark
                                                    ? Colors.grey
                                                    : AppColors.lightDivider),
                                              ),
                                            ),
                                            const Icon(Icons.arrow_drop_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (selectedCablePlanPrice.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: amount(selectedCablePlanPrice),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          CustomTextFormField(
                                            hint: 'Input decoder card number here',
                                            label: 'Beneficiary',
                                            controller: _beneficiaryController,
                                            textInputType: TextInputType.number,
                                            widget: const Icon(Icons.numbers),
                                            onChanged: _onInputChanged,
                                            suffixIcon: Padding(
                                              padding:
                                              const EdgeInsets.all(5.0),
                                              child: FormButton(
                                                onPressed: () {
                                                  _onInputChanged(_beneficiaryController.text);
                                                },
                                                topPadding: 0,
                                                text: "Verify",
                                                width: 100,
                                                height: 30,
                                              ),
                                            ),

                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter your SmartCard number';
                                              } else if (value.length < 9) {
                                                return 'Invalid SmartCard number';
                                              }
                                              return null;
                                            },
                                            borderColor: _beneficiaryController.text.isNotEmpty ? AppColors.green : AppColors.grey,
                                          ),

// Ensure this BlocConsumer is only rendered if the input length is valid and a provider is selected
                                          if (_beneficiaryController.text.length > 9 && selectedCableProviderId.isNotEmpty)
                                            BlocConsumer<ProductBloc, ProductState>(
                                              bloc: verifyEntityNumberProductBloc,
                                              listener: (context, state) {
                                                if (state is EntityNumberErrorState) {
                                                  // Handle error (e.g., show a snack bar or error message)
                                                }
                                              },
                                              builder: (context, state) {
                                                if (state is EntityNumberSuccessState) {
                                                  final res = state;
                                                  return Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 25.0),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: AppColors.lightgreen2,
                                                            border: Border.all(color: AppColors.darkGreen),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: CustomText(
                                                              text: res.electricityVerifiedData.name,
                                                              color: AppColors.green,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (state is EntityNumberErrorState) {
                                                  final errorMsg = state.error;

                                                  return  Padding(
                                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 25.0),
                                                    child: CustomText(
                                                      text: errorMsg,
                                                      size: 14,
                                                      color: AppColors.red,
                                                    ),
                                                  );
                                                } else {
                                                  return Padding(
                                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 25.0),
                                                    child: CustomText(
                                                      text: "Verifying user...",
                                                      size: 14,
                                                      color: theme.isDark ? AppColors.white : AppColors.black,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),

                                          if (selectedCablePlanId.isNotEmpty)
                                            SizedBox(
                                              height: 10,
                                            ),
                                          if (selectedCablePlanId.isNotEmpty)
                                            BeneficiaryWidget(
                                              productId: selectedCablePlanId,
                                              beneficiaryNum: (value) {
                                                setState(() {
                                                  _beneficiaryController.text =
                                                      value;
                                                });
                                              },
                                            ),
                                          SizedBox(
                                            height: 310,
                                            child: PaymentMethodScreen(
                                              amtToPay: _selectedAmtController
                                                  .text.isEmpty
                                                  ? '0'
                                                  : _selectedAmtController.text,
                                              onPaymentMethodSelected: (method) {
                                                // No need to use setState here directly as it might be called during the build phase
                                                Future.microtask(() {
                                                  if (mounted) {
                                                    setState(() {
                                                      _selectedPaymentMethod =
                                                          method;
                                                      // print(_selectedPaymentMethod);
                                                    });
                                                  }
                                                });
                                              },
                                              ispaymentAllowed: (allowed) {
                                                // Deferred update to avoid issues during the build phase
                                                Future.microtask(() {
                                                  if (mounted) {
                                                    setState(() {
                                                      isPaymentAllowed = allowed;
                                                      // print(isPaymentAllowed);
                                                    });
                                                  }
                                                });
                                              },
                                              name: (value) {
                                                print(value);
                                                Future.microtask(() {
                                                  if (mounted) {
                                                    setState(() {
                                                      beneficiaryName = value;
                                                      // print(isPaymentAllowed);
                                                    });
                                                  }
                                                });
                                              },
                                              isSaveAsBeneficiarySelected: (value) {
                                                print(value);
                                                Future.microtask(() {
                                                  if (mounted) {
                                                    setState(() {
                                                      isSaveAsBeneficiarySelected =
                                                          value;
                                                      // print(isPaymentAllowed);
                                                    });
                                                  }
                                                });
                                              },
                                              number: _beneficiaryController.text,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 200,
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
                                          //       //               selectedCableProviderPrice),
                                          //       //           _beneficiaryController
                                          //       //               .text,
                                          //       //           selectedCableProviderId,
                                          //       //           transactionPin,false));
                                          //       // }
                                          //     }
                                          //   },
                                          //   disableButton: (!isPaymentAllowed &&
                                          //       _beneficiaryController
                                          //           .text.isNotEmpty),
                                          //   // selectedCableProviderId.isNotEmpty &&
                                          //   //     _beneficiaryController.text=='',
                                          //   text: 'Purchase Cable',
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
            padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
            child: FormButton(
              onPressed: () async {
                print(_selectedPaymentMethod);
                //print(selectedCableProviderPrice);
                print(_beneficiaryController.text.isNotEmpty);
                print(!isPaymentAllowed);

                if (_formKey.currentState!.validate()) {
                  if (_selectedPaymentMethod != 'wallet') {
                    var transactionPin = '';
                    widget.category.requiredFields.amount =
                        _selectedAmtController.text;
                    widget.category.requiredFields.cardNumber =
                        _beneficiaryController.text;
                    // widget.category.requiredFields
                    //     .phoneNumber =
                    //     _beneficiaryController.text;

                    purchaseProductBloc.add(PurchaseProductEvent(
                        context,
                        widget.category.requiredFields,
                        selectedCablePlanId,
                        transactionPin,
                        true,
                        isSaveAsBeneficiarySelected,
                        beneficiaryName));
                  } else {
                    var transactionPin = '';
                    transactionPin = await modalSheet.showMaterialModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(top: 200.0),
                          child: ConfirmWithPin(
                            context: context,
                            title: 'Input your transaction pin to continue',
                          ),
                        ));
                    print(transactionPin);
                    if (transactionPin != '') {
                      setState(() {
                        widget.category.requiredFields.amount =
                            _selectedAmtController.text;
                        widget.category.requiredFields.cardNumber =
                            _beneficiaryController.text;
                      });

                      purchaseProductBloc.add(PurchaseProductEvent(
                          context,
                          widget.category.requiredFields,
                          selectedCablePlanId,
                          transactionPin,
                          false,
                          isSaveAsBeneficiarySelected,
                          beneficiaryName));
                    }
                  }
                }
              },
              disableButton:
              (!isPaymentAllowed || _beneficiaryController.text.length < 10),
              text: 'Purchase Cable',
              borderColor: AppColors.darkGreen,
              bgColor: AppColors.darkGreen,
              textColor: AppColors.white,
              borderRadius: 10,
            ),
          )
        ],
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
  final String _selectedProvider = '';

  //final String beneficiaryName = '';

  //final _beneficiaryController = TextEditingController();
}

class CableProvider extends StatelessWidget {
  final String categoryId;
  final String serviceId;
  final AdaptiveThemeMode theme;
  final Function(String, String, String) onCableProviderSelected;

  const CableProvider(
      {Key? key,
      required this.serviceId,
      required this.categoryId,
      required this.onCableProviderSelected,
      required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => ProductBloc(),
        child: Scaffold(
          backgroundColor: theme.isDark
              ? AppColors.darkModeBackgroundColor
              : AppColors.white,
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
                              textValue: 'Cable Providers',
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
                            GestureDetector(
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
                child: CableProviderList(
                  onCableProviderSelected: onCableProviderSelected,
                  serviceId: serviceId,
                  categoryId: categoryId,
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CableProviderList extends StatefulWidget {
  final String categoryId;
  final String serviceId;
  final AdaptiveThemeMode theme;
  final Function(String, String, String) onCableProviderSelected;

  const CableProviderList(
      {Key? key,
      required this.serviceId,
      required this.categoryId,
      required this.onCableProviderSelected,
      required this.theme})
      : super(key: key);

  @override
  _CableProviderListState createState() => _CableProviderListState();
}

class _CableProviderListState extends State<CableProviderList> {
  final TextEditingController _searchController = TextEditingController();
  int page = 1;
  ProductBloc productListBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _fetchCableProvider('', page, widget.categoryId, widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          CustomTextFormField(
            hint: 'Search Cable Provider',
            label: '',
            controller: _searchController,
            validator: AppValidator.validateAccountNumberfield,
            widget: const Icon(Icons.search),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              bloc: productListBloc,
              builder: (context, state) {
                if (state is ServiceLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServiceSuccessState) {
                  final ServiceSuccessState = state;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of items per row
                      crossAxisSpacing: 8.0, // Spacing between columns
                      mainAxisSpacing: 8.0, // Spacing between rows
                    ),
                    itemCount:
                        ServiceSuccessState.serviceModel.data.services.length,
                    itemBuilder: (context, index) {
                      final singleService =
                          ServiceSuccessState.serviceModel.data.services[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.onCableProviderSelected(
                              singleService.name,
                              singleService.image,
                              singleService.id,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.theme.isDark
                                  ? const Color(0xFF092514)
                                  : AppColors.grey,
                              //border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  singleService.image,
                                  height: 40,
                                  width: 40,
                                ),
                                const SizedBox(height: 5),
                                CustomText(
                                  text: singleService.name,
                                  size: 12,
                                  weight: FontWeight.w700,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  color: widget.theme.isDark
                                      ? AppColors.lightPrimary
                                      : AppColors.textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ServiceErrorState) {
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
    );
  }

  void _onSearchChanged() {
    page = 1; // Reset page number to 1 when search query changes
    _fetchCableProvider(
        _searchController.text, page, widget.categoryId, widget.serviceId);
  }

  void _fetchCableProvider(String query, int pageNo, categoryId, serviceId) {
    // productListBloc
    //     .add(FetchProduct(query, pageNo.toString(), 20, categoryId, serviceId));
    productListBloc.add(ListServiceEvent(pageNo.toString(), '20', categoryId));

    page++; // Increment page number after making the request
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CablePlan extends StatelessWidget {
  final String categoryId;
  final String serviceId;
  final AdaptiveThemeMode theme;
  final Function(String, String, String) onCablePlanSelected;

  const CablePlan(
      {Key? key,
      required this.serviceId,
      required this.categoryId,
      required this.onCablePlanSelected,
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
                            GestureDetector(
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
                child: CablePlanList(
                  onCablePlanSelected: onCablePlanSelected,
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

class CablePlanList extends StatefulWidget {
  final String categoryId;
  final String serviceId;
  final Function(String, String, String) onCablePlanSelected;

  const CablePlanList({
    Key? key,
    required this.serviceId,
    required this.categoryId,
    required this.onCablePlanSelected,
  }) : super(key: key);

  @override
  _CablePlanListState createState() => _CablePlanListState();
}

class _CablePlanListState extends State<CablePlanList> {
  final TextEditingController _searchController = TextEditingController();
  int page = 1;
  ProductBloc productListBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchCablePlan('', page, widget.categoryId, widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            onTap: () {
                              widget.onCablePlanSelected(
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
                              side: const BorderSide(color: Colors.grey),
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
    );
  }

  void _onSearchChanged() {
    page = 1; // Reset page number to 1 when search query changes
    _fetchCablePlan(
        _searchController.text, page, widget.categoryId, widget.serviceId);
  }

  void _fetchCablePlan(String query, int pageNo, categoryId, serviceId) {
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
