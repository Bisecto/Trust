import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/category_model.dart' as mainCategory;
import 'package:teller_trust/model/quick_access_model.dart';
import 'package:teller_trust/view/important_pages/dialog_box.dart';
import 'package:teller_trust/view/widgets/drop_down.dart';

import '../../../bloc/product_bloc/product_bloc.dart';
import '../../../model/service_model.dart';
import '../../../repository/app_repository.dart';
import '../../../res/apis.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
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
import 'build_payment_method.dart';
import 'make_bank_transfer/bank_transfer.dart';
import '../../../model/product_model.dart' as productMode;

class ElectricityPurchase extends StatefulWidget {
  final mainCategory.Category category;

  const ElectricityPurchase({super.key, required this.category});

  @override
  State<ElectricityPurchase> createState() => _ElectricityPurchaseState();
}

class _ElectricityPurchaseState extends State<ElectricityPurchase> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();
  ProductBloc verifyEntityNumberProductBloc = ProductBloc();
  String selectedElectricityProvider = 'Choose Provider';
  String selectedElectricityProviderImage = '';
  String selectedElectricityProviderId = '';
  String selectedServiceId = '';
  String serviceID = '';
  bool isPaymentAllowed = false;
  final _selectedAmtController = TextEditingController();
  bool isShow=false;
  Future<String> handleNetworkSelect(String? selectedServiceId) async {
    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
    String apiUrl =
        '${AppApis.listProduct}?page=1&pageSize=10&categoryId=${widget.category.id}&serviceId=$selectedServiceId';

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
          serviceID = productModel.data.items[0].id;
        });
        print(productModel);
        print(serviceID);

        return serviceID;
        // Process the data as needed
      } else {
        print("Error: ${listServiceResponse.statusCode}");
        return '';

        // Handle error
      }
    } catch (e) {
      return '';

      print("Network request failed: $e");
      // Handle exception
    }
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: AppUtils.deviceScreenSize(context).height - 100,
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
              children: [
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 60,
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
                                            child: Center(
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
                                            textValue: 'Electricity',
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
                              ),
                            ),

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
                            //       //Use user Electricity here
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
                                      child: ElectricityProvider(
                                        onElectricityProviderSelected:
                                            (String name, String imageUrl,
                                                String id) async {
                                          setState(() {
                                            selectedElectricityProvider = name;
                                            selectedElectricityProviderImage =
                                                imageUrl;
                                            selectedElectricityProviderId = id;
                                          });
                                          print(selectedElectricityProviderId);
                                          Navigator.pop(context); // Close modal
                                          String mainServiceId =
                                              await handleNetworkSelect(
                                                  selectedElectricityProviderId);
                                          if (_beneficiaryController
                                                      .text.length >
                                                  9 &&
                                              mainServiceId != '') {
                                            verifyEntityNumberProductBloc.add(
                                                VerifyEntityNumberEvent(
                                                    mainServiceId,
                                                    _beneficiaryController
                                                        .text));
                                          }
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
                                        if (selectedElectricityProvider !=
                                            "Choose Provider")
                                          Image.network(
                                            selectedElectricityProviderImage,
                                            height: 24,
                                            width: 24,
                                          ),
                                        if (selectedElectricityProvider !=
                                            "Choose Provider")
                                          SizedBox(
                                            width: 10,
                                          ),
                                        Expanded(
                                          child: CustomText(
                                            text: selectedElectricityProvider,
                                            size: 14,
                                            color:
                                                selectedElectricityProvider !=
                                                        "Choose Provider"
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

                            Padding(
                              padding: const EdgeInsets.all(10.0),
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
                                        ),
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
                                          //selectAmount("1000", theme),
                                          selectAmount("2000", theme),
                                          selectAmount("3000", theme),
                                          selectAmount("4000", theme),
                                          selectAmount("5000", theme),
                                        ],
                                      ),
                                      CustomTextFormField(
                                        hint: 'Enter your meter number',
                                        label: 'Meter Number',
                                        controller: _beneficiaryController,
                                        textInputType: TextInputType.number,
                                        onChanged: (value) async {
                                          print(_beneficiaryController
                                              .text.length);
                                          print(selectedElectricityProviderId);
                                          if (_beneficiaryController
                                                      .text.length >
                                                  9 &&
                                              selectedElectricityProviderId
                                                  .isNotEmpty) {
                                            String mainServiceId =
                                                await handleNetworkSelect(
                                                    selectedElectricityProviderId);

                                            verifyEntityNumberProductBloc.add(
                                              VerifyEntityNumberEvent(
                                                  mainServiceId,
                                                  _beneficiaryController.text),
                                            );
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your SmartCard number';
                                          } else if (value.length < 9) {
                                            return 'Invalid SmartCard number';
                                          }
                                          return null;
                                        },
                                        borderColor: _beneficiaryController
                                                .text.isNotEmpty
                                            ? AppColors.green
                                            : AppColors.grey,
                                      ),
                                      if (_beneficiaryController.text.length >
                                              9 &&
                                          selectedElectricityProviderId != '')
                                        BlocConsumer<ProductBloc, ProductState>(
                                            bloc: verifyEntityNumberProductBloc,
                                            // listenWhen: (previous, current) =>
                                            //     current is! InitialSuccessState,
                                            // buildWhen: (previous, current) =>
                                            // current is! GetDataPlanLoadingState,
                                            listener: (context, state) {
                                              if (state
                                                  is EntityNumberErrorState) {
                                                // MSG.warningSnackBar(context, state.error);
                                              }
                                            },
                                            builder: (context, state) {
                                              if (_beneficiaryController
                                                          .text.length >
                                                      9 &&
                                                  selectedElectricityProviderId !=
                                                      '') {
                                                if (state
                                                    is EntityNumberSuccessState) {
                                                  final res = state
                                                      as EntityNumberSuccessState;
                                                  // setState(() {
                                                  //   enableButton=true;
                                                  //
                                                  // });
                                                  return Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 10, 10, 25.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: AppColors
                                                                        .lightgreen2,
                                                                    border: Border.all(
                                                                        color: AppColors
                                                                            .darkGreen),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child:
                                                                      CustomText(
                                                                    text: res
                                                                        .electricityVerifiedData.name,
                                                                    color: AppColors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap:(){
                                                                  setState((){
                                                                    isShow=!isShow;
                                                                  });

                                              },
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        //color: AppColors.lightgreen2,
                                                                        border: Border.all(color: AppColors.darkGreen),
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              5.0),
                                                                      child:isShow?CustomText(
                                                                        text:
                                                                        "hide order review",
                                                                        color: AppColors
                                                                            .green,
                                                                      ):
                                                                          CustomText(
                                                                        text:
                                                                            "show order review",
                                                                        color: AppColors
                                                                            .green,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          if(isShow)

                                                            SizedBox(height:10),
                                                          if(isShow)
                                                          DottedBorder(
                                                            borderType:
                                                                BorderType
                                                                    .RRect,
                                                            radius: const Radius
                                                                .circular(10),
                                                            dashPattern: [
                                                              10,
                                                              10
                                                            ],
                                                            color: AppColors
                                                                .lightgrey,
                                                            strokeWidth: 2,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                'Meter Number',
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                res.electricityVerifiedData.meterNo,
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                'Name',
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                               res.electricityVerifiedData.name,
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                'Meter Type',
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                res.electricityVerifiedData.vendType,
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                'Outstanding',
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                res.electricityVerifiedData.outstanding.toString(),
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                'Address',
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                res.electricityVerifiedData.address.toString(),
                                                                            size:
                                                                                10,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            color:
                                                                                AppColors.lightgrey,
                                                                            weight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                } else if (state
                                                    is EntityNumberErrorState) {
                                                  return Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 10, 25.0),
                                                      child: CustomText(
                                                        text:
                                                            "Invalid Meter number",
                                                        size: 14,
                                                        color: AppColors.red,
                                                      ));
                                                } else {
                                                  return Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 10, 10, 25.0),
                                                      child: CustomText(
                                                        text:
                                                            "Verifying user.....",
                                                        size: 14,
                                                        color: theme.isDark
                                                            ? AppColors.white
                                                            : AppColors.black,
                                                      ));
                                                }
                                              } else {
                                                return const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 25.0),
                                                    child: CustomText(
                                                      text: "",
                                                      size: 14,
                                                      color: AppColors.red,
                                                    ));
                                              }
                                            }),
                                      Container(
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
                                        ),
                                      ),
                                      FormButton(
                                        onPressed: () async {
                                          print(_selectedPaymentMethod);
                                          //print(selectedElectricityProviderPrice);
                                          print(_beneficiaryController
                                              .text.isNotEmpty);
                                          print(!isPaymentAllowed);

                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (_selectedPaymentMethod !=
                                                'wallet') {
                                              var transactionPin = '';
                                              widget.category.requiredFields
                                                      .amount =
                                                  _selectedAmtController.text;
                                              widget.category.requiredFields
                                                      .meterNumber =
                                                  _beneficiaryController.text;
                                              widget.category.requiredFields
                                                      .phoneNumber =
                                                  _beneficiaryController.text;

                                              purchaseProductBloc.add(
                                                  PurchaseProductEvent(
                                                      context,
                                                      widget.category
                                                          .requiredFields,
                                                      serviceID,
                                                      transactionPin,
                                                      true));
                                            } else {
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
                                                            child:
                                                                ConfirmWithPin(
                                                              context: context,
                                                              title:
                                                                  'Input your transaction pin to continue',
                                                            ),
                                                          ));
                                              print(transactionPin);
                                              if (transactionPin != '') {
                                                setState(() {
                                                  widget.category.requiredFields
                                                          .amount =
                                                      _selectedAmtController
                                                          .text;
                                                  widget.category.requiredFields
                                                          .meterNumber =
                                                      _beneficiaryController
                                                          .text;
                                                });

                                                purchaseProductBloc.add(
                                                    PurchaseProductEvent(
                                                        context,
                                                        widget.category
                                                            .requiredFields,
                                                        serviceID, //selectedElectricityProviderId,
                                                        transactionPin,
                                                        false));
                                              }
                                            }
                                          }
                                        },
                                        disableButton: (!isPaymentAllowed ||
                                            _beneficiaryController.text.length <
                                                10),
                                        text: 'Purchase Electricity',
                                        borderColor: AppColors.darkGreen,
                                        bgColor: AppColors.darkGreen,
                                        textColor: AppColors.white,
                                        borderRadius: 10,
                                      ),
                                      SizedBox(
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
                                      //       //               selectedElectricityProviderPrice),
                                      //       //           _beneficiaryController
                                      //       //               .text,
                                      //       //           selectedElectricityProviderId,
                                      //       //           transactionPin,false));
                                      //       // }
                                      //     }
                                      //   },
                                      //   disableButton: (!isPaymentAllowed &&
                                      //       _beneficiaryController
                                      //           .text.isNotEmpty),
                                      //   // selectedElectricityProviderId.isNotEmpty &&
                                      //   //     _beneficiaryController.text=='',
                                      //   text: 'Purchase Electricity',
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
    );
  }

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

  String selectedNetwork = "";
  final _beneficiaryController = TextEditingController();
}

class ElectricityProvider extends StatelessWidget {
  final String categoryId;
  final String serviceId;
  final AdaptiveThemeMode theme;
  final Function(String, String, String) onElectricityProviderSelected;

  ElectricityProvider(
      {Key? key,
      required this.serviceId,
      required this.categoryId,
      required this.onElectricityProviderSelected,
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
                    borderRadius: BorderRadius.only(
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
                              child: Center(child: CircularProgressIndicator()),
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
                              textValue: 'Electricity Providers',
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
                              child: Icon(
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
                child: ElectricityProviderList(
                  onElectricityProviderSelected: onElectricityProviderSelected,
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

class ElectricityProviderList extends StatefulWidget {
  final String categoryId;
  final String serviceId;
  final AdaptiveThemeMode theme;
  final Function(String, String, String) onElectricityProviderSelected;

  ElectricityProviderList(
      {Key? key,
      required this.serviceId,
      required this.categoryId,
      required this.onElectricityProviderSelected,
      required this.theme})
      : super(key: key);

  @override
  _ElectricityProviderListState createState() =>
      _ElectricityProviderListState();
}

class _ElectricityProviderListState extends State<ElectricityProviderList> {
  final TextEditingController _searchController = TextEditingController();
  int page = 1;
  ProductBloc productListBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _fetchElectricityProvider('', page, widget.categoryId, widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          CustomTextFormField(
            hint: 'Search Electricity Provider',
            label: '',
            controller: _searchController,
            validator: AppValidator.validateAccountNumberfield,
            widget: Icon(Icons.search),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            widget.onElectricityProviderSelected(
                              singleService.name,
                              singleService.image,
                              singleService.id,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.theme.isDark
                                  ? Color(0xFF092514)
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
                                SizedBox(height: 5),
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
    _fetchElectricityProvider(
        _searchController.text, page, widget.categoryId, widget.serviceId);
  }

  void _fetchElectricityProvider(
      String query, int pageNo, categoryId, serviceId) {
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
