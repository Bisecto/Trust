import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/service_model.dart' as serviceModel;
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/constants/loading_dialog.dart';
import 'package:teller_trust/view/the_app_screens/sevices/make_bank_transfer/bank_transfer.dart';
import 'package:teller_trust/view/the_app_screens/sevices/product_beneficiary/product_beneficiary.dart';
import 'package:teller_trust/view/widgets/purchase_receipt.dart';

import '../../../../bloc/product_bloc/product_bloc.dart';
import '../../../../model/a2c/a2c_create_transaction_model.dart';
import '../../../../model/a2c/a2c_detail_model.dart';
import '../../../../model/category_model.dart' as categoryModel;
import '../../../../model/product_model.dart' as productMode;
import '../../../../model/wallet_info.dart';
import '../../../../repository/app_repository.dart';
import '../../../../res/apis.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_images.dart';
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

class AirtimeToCash extends StatefulWidget {
  final categoryModel.Category category;
  final WalletInfo walletInfo;

  const AirtimeToCash(
      {super.key, required this.category, required this.walletInfo});

  @override
  State<AirtimeToCash> createState() => _AirtimeToCashState();
}

class _AirtimeToCashState extends State<AirtimeToCash> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();
  String _selectedPaymentMethod = 'wallet';
  bool isPaymentAllowed = false;
  late A2CDetailModel a2cDetailModel;
  XFile? proofImage;

  @override
  void initState() {
    // TODO: implement initState
    productBloc.add(ListServiceEvent("1", "4", widget.category.id));

    super.initState();
  }

  String productId = '';

  void _handleNetworkSelect(String? networkName) async {
    setState(() {
      productId = '';
    });
    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
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
      height: AppUtils.deviceScreenSize(context).height,
      decoration: BoxDecoration(
          color: theme.isDark
              ? AppColors.darkModeBackgroundColor
              : AppColors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                          width: AppUtils.deviceScreenSize(context).width,
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
                              textValue: 'Airtime to Cash',
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
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF3D5),
                        border: Border.all(color: const Color(0xFFFFBE62)),
                        // AppColors.lightOrange),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.info,
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width:
                                    AppUtils.deviceScreenSize(context).width /
                                        1.3,
                                child: const CustomText(
                                  text:
                                      "Please note that this requires manual verification which may take few minutes",
                                  weight: FontWeight.bold,
                                  maxLines: 3,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
              BlocConsumer<ProductBloc, ProductState>(
                  bloc: purchaseProductBloc,
                  listenWhen: (previous, current) => current is! ProductInitial,
                  listener: (context, state) async {
                    print(state);
                    if (state is A2CPurchaseSuccess) {
                      showToast(
                          context: context,
                          title: 'Transaction confirmation',
                          subtitle: 'We will get back to you.',
                          type: ToastMessageType.success);
                      //refresh();
                      //MSG.snackBar(context, state.msg);

                      // AppNavigator.pushAndRemovePreviousPages(context,
                      //     page: LandingPage(studentProfile: state.studentProfile));
                    } else if (state is QuickPayInitiated) {
                      String accessToken =
                          await SharedPref.getString("access-token");

                      AppNavigator.pushAndStackPage(context,
                          page: MakePayment(
                            quickPayModel: state.quickPayModel,
                            accessToken: accessToken,
                          ));
                    } else if (state is AccessTokenExpireState) {
                      showToast(
                          context: context,
                          title: 'Token expired',
                          subtitle: 'Login again.',
                          type: ToastMessageType.error);

                      //MSG.warningSnackBar(context, state.error);

                      String firstame = await SharedPref.getString('firstName');

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
                    if ((state is ProductInitial ||
                            state is PurchaseErrorState) ||
                        state is A2CPurchaseSuccess) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            BlocConsumer<ProductBloc, ProductState>(
                              bloc: productBloc,
                              builder: (context, state) {
                                if (state is ServiceSuccessState) {
                                  serviceModel.ServiceModel serviceItem =
                                      state.serviceModel;
                                  List<serviceModel.Service> services =
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
                                                        orElse: () =>
                                                            serviceModel.Service(
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
                                        label: 'Airtime Amount',
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
                                      FormButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (productId != '') {
                                              purchaseProductBloc.add(
                                                  GetA2CDetailsEvent(
                                                      context,
                                                      productId,
                                                      '',
                                                      _selectedAmtController
                                                          .text));
                                            } else {
                                              showToast(
                                                  context: context,
                                                  title: 'Info',
                                                  subtitle:
                                                      'Please select a network provider',
                                                  type: ToastMessageType.info);
                                            }
                                          }
                                        },
                                        disableButton: (!_selectedAmtController
                                            .text.isNotEmpty),
                                        text: 'Continue',
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
                    } else if (state is CreateA2cSuccess) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                  //height: 50,
                                  width:
                                      AppUtils.deviceScreenSize(context).width,
                                  decoration: BoxDecoration(
                                      color:
                                          AppColors.lightGreen.withOpacity(0.2),
                                      border: Border.all(
                                          color: AppColors.darkGreen, width: 2),
                                      // AppColors.lightOrange),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextStyles.textHeadings(
                                            textValue:
                                                "Phone Number you are sending the ${a2cDetailModel.data.recieverContact.name} airtime to:",
                                            fontWeight: FontWeight.bold,
                                            //maxLines: 3,
                                            textSize: 12,
                                            textColor: AppColors.darkGreen),
                                        TextStyles.textHeadings(
                                            textValue: a2cDetailModel.data
                                                .recieverContact.phoneNumber)
                                      ],
                                    ),
                                  )),
                            ),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 10],
                              color: AppColors.lightgrey,
                              strokeWidth: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount:
                                      a2cDetailModel.data.instructions.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (index == 0)
                                          TextStyles.textHeadings(
                                              textValue:
                                                  "Steps to transfer on ${a2cDetailModel.data.recieverContact.name}",
                                              fontWeight: FontWeight.bold,
                                              //maxLines: 3,
                                              textSize: 12,
                                              textColor: theme.isDark
                                                  ? AppColors.white
                                                  : AppColors.black),
                                        if (index == 0)
                                          SizedBox(
                                            height: 10,
                                          ),
                                        stepContainer(
                                            index,
                                            a2cDetailModel
                                                .data.instructions[index]),
                                        if (index ==
                                            a2cDetailModel
                                                    .data.instructions.length -
                                                1)
                                          SizedBox(
                                            height: 10,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            AppSpacer(height: 10),
                            CustomTextFormField(
                              hint: '',
                              label: 'Airtime Amount',
                              enabled: false,
                              controller: _selectedAmtController,
                              textInputType: TextInputType.number,
                              validator: AppValidator.validateTextfield,
                              widget: SvgPicture.asset(
                                AppIcons.naira,
                                color: _selectedAmtController.text.isNotEmpty
                                    ? AppColors.darkGreen
                                    : AppColors.grey,
                                height: 22,
                                width: 22,
                              ),
                              borderColor:
                                  _selectedAmtController.text.isNotEmpty
                                      ? AppColors.green
                                      : AppColors.grey,
                            ),
                            AppSpacer(height: 10),
                            CustomTextFormField(
                              hint: a2cDetailModel.data.amountToReceive
                                  .toString(),
                              label: 'Cash Back',
                              enabled: false,
                              controller: cashBackController,
                              textInputType: TextInputType.number,
                              validator: AppValidator.validateTextfield,
                              widget: SvgPicture.asset(
                                AppIcons.naira,
                                color: cashBackController.text.isNotEmpty
                                    ? AppColors.darkGreen
                                    : AppColors.grey,
                                height: 22,
                                width: 22,
                              ),
                              borderColor: cashBackController.text.isNotEmpty
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                            AppSpacer(height: 10),
                            GestureDetector(
                                onTap: () async {
                                  print(1234);
                                  final pickedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedImage != null) {
                                    setState(() {
                                      proofImage = pickedImage;
                                      imgController.text = proofImage!.name;
                                    });
                                  }
                                },
                                child: CustomTextFormField(
                                  hint: 'Proof of Transfer',
                                  label: 'Attach Proof of Transfer(Optional)',
                                  enabled: false,
                                  controller: imgController,
                                  textInputType: TextInputType.number,
                                  validator: AppValidator.validateTextfield,
                                  widget: Icon(
                                    Icons.image,
                                    color: imgController.text.isNotEmpty
                                        ? AppColors.darkGreen
                                        : AppColors.grey,
                                    size: 22,
                                  ),
                                  suffixIcon: Container(
                                    width: 70,
                                    //height :20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.lightgreen2,
                                    ),
                                    child: InkWell(
                                      child: Center(
                                        child: CustomText(
                                            text: 'Upload',
                                            size: 14,
                                            color: AppColors.black),
                                      ),
                                    ),
                                  ),
                                  borderColor: imgController.text.isNotEmpty
                                      ? AppColors.green
                                      : AppColors.grey,
                                )),
                            SizedBox(height: 10),
                            TextStyles.textHeadings(
                                textValue:
                                    'Please ensure you made the transfer to'
                                    ' the given number. Traded cash'
                                    ' would be added to your “Tellawallet”',
                                textSize: 14),
                            FormButton(
                              onPressed: () async {
                                setState(() {
                                  widget.category.requiredFields.amount =
                                      _selectedAmtController.text;
                                });
                                purchaseProductBloc.add(ReportTransferEvent(
                                    context,
                                    state.a2cCreateTransactionModel.id,
                                    '',proofImage));
                              },
                              disableButton:
                                  (!_selectedAmtController.text.isNotEmpty),
                              text: 'I have made this transfer',
                              borderColor: AppColors.darkGreen,
                              bgColor: AppColors.darkGreen,
                              textColor: AppColors.white,
                              borderRadius: 10,
                            ),
                            FormButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              text: 'Cancel',
                              borderColor: AppColors.grey,
                              bgColor: Colors.transparent,
                              textColor: !theme.isDark
                                  ? AppColors.textColor
                                  : AppColors.white,
                              borderRadius: 10,
                            )
                          ],
                        ),
                      );
                    } else if (state is A2cDetailSuccess) {
                      a2cDetailModel = state.a2cDetailModel;
                      cashBackController.text =
                          a2cDetailModel.data.amountToReceive.toString();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Container(
                                  //height: 50,
                                  width:
                                      AppUtils.deviceScreenSize(context).width,
                                  decoration: BoxDecoration(
                                      color:
                                          AppColors.lightGreen.withOpacity(0.2),
                                      border: Border.all(
                                          color: AppColors.darkGreen, width: 2),
                                      // AppColors.lightOrange),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextStyles.textHeadings(
                                            textValue:
                                                "Phone Number you are sending the ${a2cDetailModel.data.recieverContact.name} airtime to:",
                                            fontWeight: FontWeight.bold,
                                            //maxLines: 3,
                                            textSize: 12,
                                            textColor: AppColors.darkGreen),
                                        TextStyles.textHeadings(
                                            textValue: a2cDetailModel.data
                                                .recieverContact.phoneNumber)
                                      ],
                                    ),
                                  )),
                            ),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 10],
                              color: AppColors.lightgrey,
                              strokeWidth: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount:
                                      a2cDetailModel.data.instructions.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (index == 0)
                                          TextStyles.textHeadings(
                                              textValue:
                                                  "Steps to transfer on ${a2cDetailModel.data.recieverContact.name}",
                                              fontWeight: FontWeight.bold,
                                              //maxLines: 3,
                                              textSize: 12,
                                              textColor: theme.isDark
                                                  ? AppColors.white
                                                  : AppColors.black),
                                        if (index == 0)
                                          SizedBox(
                                            height: 10,
                                          ),
                                        stepContainer(
                                            index,
                                            a2cDetailModel
                                                .data.instructions[index]),
                                        if (index ==
                                            a2cDetailModel
                                                    .data.instructions.length -
                                                1)
                                          SizedBox(
                                            height: 10,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            AppSpacer(height: 10),
                            CustomTextFormField(
                              hint: '',
                              label: 'Airtime Amount',
                              enabled: false,
                              controller: _selectedAmtController,
                              textInputType: TextInputType.number,
                              validator: AppValidator.validateTextfield,
                              widget: SvgPicture.asset(
                                AppIcons.naira,
                                color: _selectedAmtController.text.isNotEmpty
                                    ? AppColors.darkGreen
                                    : AppColors.grey,
                                height: 22,
                                width: 22,
                              ),
                              borderColor:
                                  _selectedAmtController.text.isNotEmpty
                                      ? AppColors.green
                                      : AppColors.grey,
                            ),
                            AppSpacer(height: 10),
                            CustomTextFormField(
                              hint: a2cDetailModel.data.amountToReceive
                                  .toString(),
                              label: 'Cash Back',
                              enabled: false,
                              controller: cashBackController,
                              textInputType: TextInputType.number,
                              validator: AppValidator.validateTextfield,
                              widget: SvgPicture.asset(
                                AppIcons.naira,
                                color: cashBackController.text.isNotEmpty
                                    ? AppColors.darkGreen
                                    : AppColors.grey,
                                height: 22,
                                width: 22,
                              ),
                              borderColor: cashBackController.text.isNotEmpty
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                            FormButton(
                              onPressed: () async {
                                if (productId != '') {
                                  var transactionPin = '';
                                  transactionPin = await modalSheet
                                          .showMaterialModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              isDismissible: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20.0)),
                                              ),
                                              context: context,
                                              builder: (context) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 200.0),
                                                    child: ConfirmWithPin(
                                                      context: context,
                                                      title:
                                                          'Input your transaction pin to continue',
                                                    ),
                                                  )) ??
                                      "";
                                  print(transactionPin);
                                  if (transactionPin != '') {
                                    setState(() {
                                      widget.category.requiredFields.amount =
                                          _selectedAmtController.text;
                                    });
                                    purchaseProductBloc.add(
                                        CreateA2CDetailsEvent(
                                            context,
                                            productId,
                                            transactionPin,
                                            _selectedAmtController.text));
                                  }
                                }
                              },
                              disableButton:
                                  (!_selectedAmtController.text.isNotEmpty),
                              text: 'Continue',
                              borderColor: AppColors.darkGreen,
                              bgColor: AppColors.darkGreen,
                              textColor: AppColors.white,
                              borderRadius: 10,
                            ),
                            FormButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              text: 'Cancel',
                              borderColor: AppColors.grey,
                              bgColor: Colors.transparent,
                              textColor: !theme.isDark
                                  ? AppColors.textColor
                                  : AppColors.white,
                              borderRadius: 10,
                            )
                          ],
                        ),
                      );
                    } else {
                      return LoadingDialog('');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  String selectedNetwork = "";
  final _selectedAmtController = TextEditingController();
  final cashBackController = TextEditingController();
  final imgController = TextEditingController();

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

  Widget stepContainer(int index, String text) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: (index + 1).toString() + ") "),
          Container(
              width: AppUtils.deviceScreenSize(context).width / 1.3,
              child: CustomText(
                text: text,
                maxLines: 3,
              ))
        ],
      ),
    );
  }
}
