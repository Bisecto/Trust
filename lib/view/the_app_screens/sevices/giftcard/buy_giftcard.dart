import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/service_model.dart' as serviceModel;
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/view/the_app_screens/sevices/make_bank_transfer/bank_transfer.dart';
import 'package:teller_trust/view/the_app_screens/sevices/product_beneficiary/product_beneficiary.dart';

import '../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../model/category_model.dart' as categoryModel;
import '../../../../model/product_model.dart' as productMode;
import '../../../../model/wallet_info.dart';
import '../../../../repository/app_repository.dart';
import '../../../../res/apis.dart';
import '../../../../res/app_colors.dart';
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

import '../../../widgets/show_toast.dart';
import '../../../widgets/transaction_receipt.dart';
import '../payment_method/payment_method.dart';

class GiftCardPurchase extends StatefulWidget {
  final categoryModel.Category category;
  final WalletInfo? walletInfo;

  const GiftCardPurchase(
      {super.key, required this.category, required this.walletInfo});

  @override
  State<GiftCardPurchase> createState() => _GiftCardPurchaseState();
}

class _GiftCardPurchaseState extends State<GiftCardPurchase> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();

  // final FlutterContactPicker _contactPicker = FlutterContactPicker();
  // Contact? contacts;

  @override
  void initState() {
    // TODO: implement initState
    productBloc.add(ListServiceEvent("1", "15", widget.category.id));

    super.initState();
  }

  bool isInitial = true;
  String productId = '';

  void _handleCardSelect(String? networkName) async {
    setState(() {
      productId = '';
    });
    AppRepository appRepository = AppRepository();
    String accessToken =
        await SharedPref.getString(SharedPrefKey.accessTokenKey);
    String apiUrl =
        '${AppApis.listProduct}?page=1&pageSize=10&categoryId=${widget.category.id}&serviceId=$networkName';

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
      print("Card request failed: $e");
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (AppUtils.deviceScreenSize(context).height / 1.2) - 57,
              child: SingleChildScrollView(
                //physics: NeverScrollableScrollPhysics(),
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
                              _searchController.clear();
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
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
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
                                            top: 10,
                                            // Adjust position as needed
                                            left: 10,
                                            right: 10,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextStyles.textHeadings(
                                                  textValue: 'GiftCard',
                                                  textColor:
                                                      AppColors.darkGreen,
                                                  // w: FontWeight.w600,
                                                  textSize: 14,
                                                ),
                                                // Text(
                                                //   "GiftCard purchase",
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
                                  //       billType: 'giftCard',
                                  //       onBeneficiarySelected: (phone) {
                                  //         setState(() {
                                  //           numberTextEditingControlller.text =
                                  //               phone; // Update the selected beneficiary's phone number
                                  //         });
                                  //       },
                                  //     )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildSelectableItem(
                                          0,
                                          "Buy Gift Cards",
                                          AppColors
                                              .darkModeBackgroundContainerColor,
                                          const Color(0xFFFEFFEB)),
                                      _buildSelectableItem(
                                          1,
                                          "Sell Gift Cards",
                                          AppColors
                                              .darkModeBackgroundContainerColor,
                                          const Color(0xFFFFF5F4)),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomTextFormField(
                                      hint: 'Search......',
                                      label: '',
                                      controller: _searchController,
                                      textInputType: TextInputType.text,
                                      validator: AppValidator.validateTextfield,
                                      onChanged: (val) {
                                        setState(() {
                                          _searchController.text = val;
                                        });
                                      },
                                      suffixIcon: const Icon(Icons.search),
                                      borderColor:
                                          _searchController.text.isNotEmpty
                                              ? AppColors.green
                                              : AppColors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 0,
                                  ),
                                  BlocConsumer<ProductBloc, ProductState>(
                                    bloc: productBloc,
                                    builder: (context, state) {
                                      if (state is ServiceSuccessState) {
                                        serviceModel.ServiceModel serviceItem =
                                            state.serviceModel;
                                        List<serviceModel.Service> services =
                                            serviceItem.data.services;
                                        if (isInitial) {}
                                        return SizedBox(
                                          height: services.length * 70,
                                          // Adjust height dynamically
                                          child: ListView.builder(
                                            physics: const ScrollPhysics(),
                                            itemCount: services.length,
                                            itemBuilder: (context, index) {
                                              if (services[index]
                                                  .name
                                                  .toLowerCase()
                                                  .contains(_searchController
                                                      .text
                                                      .toLowerCase())) {
                                                return GestureDetector(
                                                    onTap: () {
                                                      String selectedAction =
                                                          '';
                                                      setState(() {
                                                        //selectedAction=services[index].name;
                                                      });

                                                      //showGiftCardModal(context, AppList().serviceItems[index]);
                                                    },
                                                    child: sevicesItem(
                                                        services[index].name,
                                                        services[index].image,
                                                        theme,
                                                        () => _handleCardSelect(services
                                                            .firstWhere(
                                                                (service) =>
                                                                    service
                                                                        .name
                                                                        .toLowerCase() ==
                                                                    services[
                                                                            index]
                                                                        .name
                                                                        .toLowerCase(),
                                                                orElse: () => serviceModel.Service(
                                                                    image: '',
                                                                    id: '',
                                                                    name: '',
                                                                    slug: '',
                                                                    category: serviceModel.Category(
                                                                        id: '',
                                                                        name:
                                                                            '',
                                                                        slug:
                                                                            '')))
                                                            .id)));
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        );
                                      } else {
                                        return _loadingCard(); // Show loading indicator or handle error state
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
                                        child: const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // CustomTextFormField(
                                            //   hint: '0.00',
                                            //   label: 'Select Amount',
                                            //   controller:
                                            //       _selectedAmtController,
                                            //   textInputType:
                                            //       TextInputType.number,
                                            //   validator: AppValidator
                                            //       .validateTextfield,
                                            //   widget: SvgPicture.asset(
                                            //     AppIcons.naira,
                                            //     color: _selectedAmtController
                                            //             .text.isNotEmpty
                                            //         ? AppColors.darkGreen
                                            //         : AppColors.grey,
                                            //     height: 22,
                                            //     width: 22,
                                            //   ),
                                            //   borderColor:
                                            //       _selectedAmtController
                                            //               .text.isNotEmpty
                                            //           ? AppColors.green
                                            //           : AppColors.grey,
                                            // ),
                                            SizedBox(
                                              height: 10,
                                            ),

                                            // SizedBox(
                                            //   height: 310,
                                            //   child: PaymentMethodScreen(
                                            //     amtToPay: _selectedAmtController
                                            //             .text.isEmpty
                                            //         ? '0'
                                            //         : _selectedAmtController
                                            //             .text,
                                            //     onPaymentMethodSelected:
                                            //         (method) {
                                            //       // No need to use setState here directly as it might be called during the build phase
                                            //       Future.microtask(() {
                                            //         if (mounted) {
                                            //           setState(() {
                                            //             _selectedPaymentMethod =
                                            //                 method;
                                            //             //print(_selectedPaymentMethod);
                                            //           });
                                            //         }
                                            //       });
                                            //     },
                                            //     ispaymentAllowed: (allowed) {
                                            //       // Deferred update to avoid issues during the build phase
                                            //       Future.microtask(() {
                                            //         if (mounted) {
                                            //           setState(() {
                                            //             isPaymentAllowed =
                                            //                 allowed;
                                            //             // print(isPaymentAllowed);
                                            //           });
                                            //         }
                                            //       });
                                            //     },
                                            //     number:
                                            //         _beneficiaryController.text,
                                            //     name: (value) {
                                            //       print(value);
                                            //       Future.microtask(() {
                                            //         if (mounted) {
                                            //           setState(() {
                                            //             print(value);
                                            //             beneficiaryName = value;
                                            //             // print(isPaymentAllowed);
                                            //           });
                                            //         }
                                            //       });
                                            //     },
                                            //     isSaveAsBeneficiarySelected:
                                            //         (value) {
                                            //       print(value);
                                            //       Future.microtask(() {
                                            //         if (mounted) {
                                            //           setState(() {
                                            //             isSaveAsBeneficiarySelected =
                                            //                 value;
                                            //             // print(isPaymentAllowed);
                                            //           });
                                            //         }
                                            //       });
                                            //     },
                                            //   ),
                                            // ),
                                            // SizedBox(
                                            //   height: 0,
                                            // )

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
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: FormButton(
                onPressed: () async {
                  if(!(selectedIndex == -1 || selectedCard.isEmpty)){
                    print(selectedCard+"123456789");

                  } else if(selectedIndex==-1){
                    showToast(
                        context: context,
                        title: 'Info',
                        subtitle: 'Please select a service to proceed',
                        type: ToastMessageType.info);

                  } else if(selectedCard.isEmpty){
                    showToast(
                        context: context,
                        title: 'Info',
                        subtitle: 'Please select a valid card',
                        type: ToastMessageType.info);
                  }
                },
                topPadding: 10,
                disableButton: selectedIndex == -1 || selectedCard.isEmpty,
                text: 'Proceed',
                borderColor: AppColors.darkGreen,
                bgColor: AppColors.darkGreen,
                textColor: AppColors.white,
                borderRadius: 10,
                width: AppUtils.deviceScreenSize(context).width,
              ),
            )
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  String selectedCard = "";
  final _searchController = TextEditingController();

  int selectedIndex = -1;

  Widget _buildSelectableItem(
      int index, String title, Color darkColor, Color lightColor) {
    final theme = Theme.of(context);

    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index; // Update selected index on tap
        });
      },
      child: Stack(
        children: [
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? darkColor
                    : lightColor,
                borderRadius: BorderRadius.circular(10),
                border: isSelected
                    ? Border.all(
                        color: Colors.green,
                        width: 2) // Green border when selected
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcons.giftCard, height: 60, width: 60),
                  TextStyles.textSubHeadings(
                    textValue: title,
                    textSize: 12,
                    textColor: theme.brightness == Brightness.dark
                        ? AppColors.darkModeBackgroundSubTextColor
                        : AppColors.textColor,
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.check_circle,
                  color: Colors.green, size: 24), // Check icon
            ),
        ],
      ),
    );
  }

  Widget sevicesItem(
    String name,
    String image,
    AdaptiveThemeMode theme,
    void Function() onCardSelect, // Callback for network request
  ) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: AppUtils.deviceScreenSize(context).width,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: selectedCard == name.toLowerCase()
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
                selectedCard = name.toLowerCase();
              });
              onCardSelect(); // Trigger the network request
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(image),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (selectedCard == name.toLowerCase())
                  TextStyles.textHeadings(
                    textValue: name,
                    textSize: 12,
                    textColor: AppColors.darkGreen,
                  ),
                if (selectedCard != name.toLowerCase())
                  CustomText(
                    text: name,
                    size: 10,
                    weight: FontWeight.bold,
                    color: selectedCard == name.toLowerCase()
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

  Widget _loadingCard() {
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

// void showGiftCardModal(BuildContext context, Services services) {
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
