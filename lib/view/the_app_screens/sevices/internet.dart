import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/model/category_model.dart' as mainCategory;
import 'package:teller_trust/view/important_pages/dialog_box.dart';

import '../../../bloc/product_bloc/product_bloc.dart';
import '../../../model/service_model.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../../utills/shared_preferences.dart';
import '../../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../widgets/show_toast.dart';

class InternetPurchase extends StatefulWidget {
  final mainCategory.Category category;

  const InternetPurchase({super.key, required this.category});

  @override
  State<InternetPurchase> createState() => _InternetPurchaseState();
}

class _InternetPurchaseState extends State<InternetPurchase> {
  ProductBloc productBloc = ProductBloc();
  ProductBloc purchaseProductBloc = ProductBloc();
  String selectedInternetPlan = 'Choose Plan';
  String selectedInternetPlanPrice = '';
  String selectedInternetPlanId = '';
  String selectedServiceId = '';

  @override
  void initState() {
    // TODO: implement initState
    print(widget.category.name);
    print(widget.category.name);
    print(widget.category.name);
    print(widget.category.name);
    productBloc.add(ListServiceEvent("1", "4", widget.category.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: AppUtils.deviceScreenSize(context).height - 100,
        decoration: const BoxDecoration(
            color: AppColors.white,
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
                              height: 100,
                              decoration: const BoxDecoration(
                                  color: AppColors.darkGreen,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomText(
                                      text: "Internet purchase",
                                      color: AppColors.white,
                                      weight: FontWeight.bold,
                                      size: 18,
                                    ),
                                    Container(
                                      height: 30,
                                    ),
                                    // FormButton(
                                    //   onPressed: () {
                                    //     print(1234);
                                    //     Navigator.of(context).pop();
                                    //   },
                                    //   //text: 'X',
                                    //   height: 50,
                                    //   width: 50,
                                    //   isIcon: true,
                                    //   iconWidget: Icons.cancel,
                                    // ),
                                    GestureDetector(
                                      onTap: () {
                                        print(1234);
                                        Navigator.of(context).pop();
                                        //Navigator.pop(context);
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        //color: AppColors.red,
                                        width: 50,
                                        child: Center(
                                          child: Icon(
                                            Icons.cancel,
                                            size: 40,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocConsumer<ProductBloc, ProductState>(
                              bloc: productBloc,
                              builder: (context, state) {
                                if (state is ServiceSuccessState) {
                                  ServiceModel serviceItem = state.serviceModel;
                                  List<Service> services =
                                      serviceItem.data.services;
                                  //Use user Internet here
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
                                                services[index].id));
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
                                        padding:
                                            const EdgeInsets.only(top: 200.0),
                                        child: InternetPlan(
                                          onInternetPlanSelected: (String name,
                                              String price, String id) {
                                            setState(() {
                                              selectedInternetPlan = name;
                                              selectedInternetPlanPrice = price;
                                              selectedInternetPlanId = id;
                                            });
                                            Navigator.pop(
                                                context); // Close modal
                                          },
                                          categoryId: widget.category.id,
                                          serviceId: selectedServiceId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
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
                                            text: selectedInternetPlan,
                                            size: 14,
                                            color: selectedInternetPlan !=
                                                    "Choose Plan"
                                                ? Colors.black
                                                : AppColors.lightDivider,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (selectedInternetPlanPrice.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: amount(selectedInternetPlanPrice),
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
                                        widget: SvgPicture.asset(AppIcons.naira),
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
                                            // transactionPin = await modalSheet
                                            //     .showMaterialModalBottomSheet(
                                            //         backgroundColor:
                                            //             Colors.transparent,
                                            //         shape:
                                            //             const RoundedRectangleBorder(
                                            //           borderRadius:
                                            //               BorderRadius.vertical(
                                            //                   top: Radius
                                            //                       .circular(
                                            //                           20.0)),
                                            //         ),
                                            //         context: context,
                                            //         builder: (context) =>
                                            //             Padding(
                                            //               padding:
                                            //                   const EdgeInsets
                                            //                       .only(
                                            //                       top: 200.0),
                                            //               child: ConfirmWithPin(
                                            //                 context: context,
                                            //                 title:
                                            //                     'Input your transaction pin to continue',
                                            //               ),
                                            //             ));
                                            print(transactionPin);
                                            // if (transactionPin != '') {
                                            //   purchaseProductBloc.add(
                                            //       PurchaseProductEvent(
                                            //           context,
                                            //           double.parse(
                                            //               selectedInternetPlanPrice),
                                            //           _beneficiaryController
                                            //               .text,
                                            //           selectedInternetPlanId,
                                            //           transactionPin));
                                            // }
                                          }
                                        },
                                        disableButton: selectedInternetPlanId
                                                .isNotEmpty &&
                                            _beneficiaryController.text == '',
                                        text: 'Purchase Internet',
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

  Widget amount(String amt) {
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGreen)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomText(
              text: "₦ $amt",
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

  Widget networkProviderItem(String name, String image, String id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: AppUtils.deviceScreenSize(context).width / 5,
        width: AppUtils.deviceScreenSize(context).width / 5,
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
                selectedServiceId = id;
                selectedInternetPlanPrice = '';
                selectedInternetPlanId = '';
                selectedInternetPlan = 'Choose Plan';
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
                CustomText(
                  text: name,
                  color: AppColors.black,
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

class InternetPlan extends StatelessWidget {
  final String categoryId;
  final String serviceId;
  final Function(String, String, String) onInternetPlanSelected;

  const InternetPlan({
    Key? key,
    required this.serviceId,
    required this.categoryId,
    required this.onInternetPlanSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => ProductBloc(),
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 50,
                decoration: const BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Internet Plans",
                        color: AppColors.white,
                        weight: FontWeight.w600,
                        size: 18,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 40,
                            color: AppColors.lightShadowGreenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InternetPlanList(
                  onInternetPlanSelected: onInternetPlanSelected,
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

class InternetPlanList extends StatefulWidget {
  final String categoryId;
  final String serviceId;
  final Function(String, String, String) onInternetPlanSelected;

  const InternetPlanList({
    Key? key,
    required this.serviceId,
    required this.categoryId,
    required this.onInternetPlanSelected,
  }) : super(key: key);

  @override
  _InternetPlanListState createState() => _InternetPlanListState();
}

class _InternetPlanListState extends State<InternetPlanList> {
  final TextEditingController _searchController = TextEditingController();
  int page = 1;
  ProductBloc productListBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchInternetPlan('', page, widget.categoryId, widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          CustomTextFormField(
            hint: 'Search Internet plan',
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
                      return ListTile(
                        onTap: () {
                          widget.onInternetPlanSelected(
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
                        subtitle: CustomText(
                          text: singleProduct.buyerPrice.toString(),
                          size: 14,
                          weight: FontWeight.w400,
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
    _fetchInternetPlan(
        _searchController.text, page, widget.categoryId, widget.serviceId);
  }

  void _fetchInternetPlan(String query, int pageNo, categoryId, serviceId) {
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
