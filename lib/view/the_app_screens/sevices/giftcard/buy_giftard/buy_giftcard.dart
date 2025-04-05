import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/model/product_model.dart';
import 'package:teller_trust/utills/constants/loading_dialog.dart';
import 'package:teller_trust/view/widgets/drop_down.dart';
import '../../../../../model/wallet_info.dart';
import '../../../../../model/category_model.dart' as categoryModel;
import 'package:teller_trust/model/service_model.dart' as serviceModel;

import '../../../../../repository/app_repository.dart';
import '../../../../../res/apis.dart';
import '../../../../../res/app_colors.dart';
import '../../../../../res/app_icons.dart';
import '../../../../../res/sharedpref_key.dart';
import '../../../../../utills/app_navigator.dart';
import '../../../../../utills/app_utils.dart';
import '../../../../../utills/app_validator.dart';
import '../../../../../utills/custom_theme.dart';
import '../../../../../utills/enums/toast_mesage.dart';
import '../../../../../utills/shared_preferences.dart';
import '../../../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../../../widgets/app_custom_text.dart';
import '../../../../widgets/form_button.dart';
import '../../../../widgets/form_input.dart';
import '../../../../widgets/show_toast.dart';
import '../../../../widgets/transaction_receipt.dart';
import '../../make_bank_transfer/bank_transfer.dart';

class BuyGiftcard extends StatefulWidget {
  final categoryModel.Category category;
  final WalletInfo? walletInfo;
  final ProductBloc productBloc;
  final Item product;

  const BuyGiftcard(
      {super.key,
      required this.category,
      required this.walletInfo,
      required this.productBloc,
      required this.product});

  @override
  State<BuyGiftcard> createState() => _BuyGiftcardState();
}

class _BuyGiftcardState extends State<BuyGiftcard> {
  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();
  }

  bool isPricesLoading = true;
  String selectedValue = '';
  List<dynamic> prices = [];

  void fetch() async {
    AppRepository appRepository = AppRepository();
    String accessToken =
        await SharedPref.getString(SharedPrefKey.accessTokenKey);

    try {
      var getPrices = await appRepository.appGetRequest(
        "${AppApis.getPrices + widget.product.reference}",
        accessToken: accessToken,
      );

      if (getPrices.statusCode == 200) {
        // print(json.decode(getPrices.body));
        // print(json.decode(getPrices.body));
        print(json.decode(getPrices.body));

        setState(() {
          prices = json.decode(getPrices.body)['data']['denominations'];
          isPricesLoading = false;
        });
        print(prices);
        print(prices);
        print(prices);
      } else {
        print("Error: ${getPrices.statusCode}");
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
                          bloc: widget.productBloc,
                          listenWhen: (previous, current) =>
                              current is! ProductInitial,
                          listener: (context, state) async {
                            print(state);
                            if (state is PurchaseSuccess) {
                              //_searchController.clear();
                              state.transaction.order!.product!.name ==
                                  widget.category.name;
                              AppNavigator.pushAndStackPage(context,
                                  page: TransactionReceipt(
                                      transaction: state.transaction));
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
                              physics: const NeverScrollableScrollPhysics(),
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
                                                  textValue: widget.product.name
                                                      .toUpperCase(),
                                                  textColor:
                                                      AppColors.darkGreen,
                                                  // w: FontWeight.w600,
                                                  textSize: 14,
                                                ),
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
                                            if (isPricesLoading)
                                              LoadingDialog(''),
                                            if (!isPricesLoading)
                                              DropDown(
                                                selectedValue: selectedValue,
                                                label: "Card category",
                                                hint: "Eg. \$10",
                                                items: prices
                                                    .map((e) => e.toString())
                                                    .toList(),
                                                onChanged: (val) {
                                                  setState(() {
                                                    selectedValue = val;
                                                  });
                                                },
                                              ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomTextFormField(
                                              hint: 'Eg. 1',
                                              label: 'How Many',
                                              controller: _qtytController,
                                              textInputType:
                                                  TextInputType.number,
                                              validator: AppValidator
                                                  .validateTextfield,
                                              borderColor: _qtytController
                                                      .text.isNotEmpty
                                                  ? AppColors.green
                                                  : AppColors.grey,
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomTextFormField(
                                              hint: 'Eg. you@gmail.com',
                                              label: 'Recipient Email Address',
                                              controller: _emailController,
                                              textInputType: TextInputType.text,
                                              validator:
                                                  AppValidator.validateEmail,
                                              // widget: SvgPicture.asset(
                                              //   AppIcons.naira,
                                              //   color: _qtytController
                                              //           .text.isNotEmpty
                                              //       ? AppColors.darkGreen
                                              //       : AppColors.grey,
                                              //   height: 22,
                                              //   width: 22,
                                              // ),
                                              borderColor: _emailController
                                                      .text.isNotEmpty
                                                  ? AppColors.green
                                                  : AppColors.grey,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            // SizedBox(
                                            //   height: 310,
                                            //   child: PaymentMethodScreen(
                                            //     amtToPay: _qtytController
                                            //             .text.isEmpty
                                            //         ? '0'
                                            //         : _qtytController
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
              padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: FormButton(
                onPressed: () async {},
                topPadding: 10,
                // disableButton: selectedIndex == -1 || selectedCard.isEmpty,
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
  final _qtytController = TextEditingController();
  final _emailController = TextEditingController();
}
