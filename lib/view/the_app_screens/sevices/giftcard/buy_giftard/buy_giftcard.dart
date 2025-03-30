import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/service_model.dart' as serviceModel;
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/view/the_app_screens/sevices/make_bank_transfer/bank_transfer.dart';
import 'package:teller_trust/view/the_app_screens/sevices/product_beneficiary/product_beneficiary.dart';



import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../../model/wallet_info.dart';
import '../../../../../res/app_colors.dart';
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
import '../../build_payment_method.dart';


class BuyGiftCard extends StatefulWidget {
  
  final WalletInfo? walletInfo;

  const BuyGiftCard({super.key,  required this.walletInfo});

  @override
  State<BuyGiftCard> createState() => _BuyGiftCardState();
}

class _BuyGiftCardState extends State<BuyGiftCard> {
  ProductBloc purchaseProductBloc = ProductBloc();
  String _selectedPaymentMethod = 'wallet';
  bool isPaymentAllowed = false;
  // final FlutterContactPicker _contactPicker = FlutterContactPicker();
  // Contact? contacts;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool isInitial = true;
  String productId = '';


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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (AppUtils.deviceScreenSize(context).height/ 1.2)-50,
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
                              // state.transaction.order!.product!.name ==
                              //     widget.category.name;
                              // AppNavigator.pushAndStackPage(context,
                              //     page: TransactionReceipt(
                              //         transaction: state.transaction));

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

                              // AppNavigator.pushAndStackPage(context,
                              //     page: MakePayment(
                              //       quickPayModel: state.quickPayModel,
                              //       accessToken: accessToken,
                              //     ));
                            } else if (state is AccessTokenExpireState) {
                              // showToast(
                              //     context: context,
                              //     title: 'Token expired',
                              //     subtitle: 'Login again.',
                              //     type: ToastMessageType.error);

                              //MSG.warningSnackBar(context, state.error);

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
                                              width:
                                              AppUtils.deviceScreenSize(context)
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
                                                  textValue: 'Buy GiftCard',
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

                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
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
                                              hint: 'Search...',
                                              label: '',
                                              controller: _selectedAmtController,
                                              textInputType: TextInputType.number,
                                              validator:
                                              AppValidator.validateTextfield,
                                              suffixIcon: const Icon(Icons.search),
                                              // widget: SvgPicture.asset(
                                              //   AppIcons.naira,
                                              //   color: _selectedAmtController
                                              //       .text.isNotEmpty
                                              //       ? AppColors.darkGreen
                                              //       : AppColors.grey,
                                              //   height: 22,
                                              //   width: 22,
                                              // ),
                                              borderColor: _selectedAmtController
                                                  .text.isNotEmpty
                                                  ? AppColors.green
                                                  : AppColors.grey,
                                            ),
                                            // CustomTextFormField(
                                            //   hint: '0.00',
                                            //   label: 'Select Amount',
                                            //   controller: _selectedAmtController,
                                            //   textInputType: TextInputType.number,
                                            //   validator:
                                            //   AppValidator.validateTextfield,
                                            //   widget: SvgPicture.asset(
                                            //     AppIcons.naira,
                                            //     color: _selectedAmtController
                                            //         .text.isNotEmpty
                                            //         ? AppColors.darkGreen
                                            //         : AppColors.grey,
                                            //     height: 22,
                                            //     width: 22,
                                            //   ),
                                            //   borderColor: _selectedAmtController
                                            //       .text.isNotEmpty
                                            //       ? AppColors.green
                                            //       : AppColors.grey,
                                            // ),
                                            const SizedBox(
                                              height: 10,
                                            ),


                                            const SizedBox(
                                              height: 0,
                                            )

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
              padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
              child: FormButton(
                onPressed: () async {

                  if (_formKey.currentState!.validate()) {

                  }
                },
                disableButton:
                (!isPaymentAllowed || !_beneficiaryController.text.isNotEmpty),
                text: 'Buy Gift Cards',
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

  String selectedNetwork = "";
  final _beneficiaryController = TextEditingController();
  final _selectedAmtController = TextEditingController();
  bool isSaveAsBeneficiarySelected = false;
  String beneficiaryName = '';





}
