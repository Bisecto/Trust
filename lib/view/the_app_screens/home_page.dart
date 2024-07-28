import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/model/personal_profile.dart';
import 'package:teller_trust/model/wallet_info.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/utills/constants/loading_dialog.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/networkCenter/pages/network_center_main_page.dart';
import 'package:teller_trust/view/the_app_screens/sevices/add_fundz.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime_purchase/airtime.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime_to_cash_purchase/airtime_to_cash.dart';
import 'package:teller_trust/view/the_app_screens/sevices/cable_purchase/cable_purchase.dart';
import 'package:teller_trust/view/the_app_screens/sevices/data_purchase/data.dart';
import 'package:teller_trust/view/the_app_screens/sevices/electricity_purchase/electricity_purchase.dart';
import 'package:teller_trust/view/the_app_screens/transaction_history/transaction_history.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:teller_trust/view/widgets/purchase_receipt.dart';

import '../../bloc/app_bloc/app_bloc.dart';
import '../../model/category_model.dart';
import '../../model/customer_account_model.dart';
import '../../res/app_images.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../widgets/show_toast.dart';
import 'kyc_verification/kyc_intro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool selector = true;
  bool isMoneyBlocked = false;
  String firstname = "";

  //String lastname = "";

  @override
  void initState() {
    // TODO: implement initState
    getName();
    super.initState();
  }

  Future<void> getName() async {
    firstname = await SharedPref.getString('firstName');
    //lastname = await SharedPref.getString('lastName');
    isMoneyBlocked = await SharedPref.getBool('isMoneyBlocked') ?? false;
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
    print(isMoneyBlocked);
  }

  Future<void> _handleRefresh() async {
    context.read<AppBloc>().add(InitialEvent());
    context.read<ProductBloc>().add(ListCategoryEvent("1", "8"));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homeProfileContainer(theme),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        //height: 40,
                        //width: AppUtils.deviceScreenSize(context).width / 2,
                        decoration: BoxDecoration(
                            color: AppColors.darkGreen,
                            // border:
                            //     Border.all(color: AppColors.lightPrimaryGreen),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CustomText(
                            text: "Balance",
                            weight: FontWeight.bold,
                            size: 12,
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundMainTextColor
                                : AppColors.white,
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        //height: 40,
                        //width: AppUtils.deviceScreenSize(context).width / 2,
                        decoration: BoxDecoration(

                            ///color: AppColors.darkGreen,
                            border: Border.all(color: AppColors.textColor2),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CustomText(
                            text: "Beneficiaries",
                            weight: FontWeight.normal,
                            size: 12,
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundMainTextColor
                                : AppColors.textColor,
                          ),
                        )),
                  ],
                ),
                homeBalance(theme),
              ],
            ),
          ),
        )),
      ),
    );
  }

  // Widget balanceBeneficiarySelector() {
  //   return DefaultTabController(
  //     length: 2,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           height: 30,
  //           width: AppUtils.deviceScreenSize(context).width / 2,
  //           decoration: BoxDecoration(
  //               //color: Colors.grey[300],
  //               border: Border.all(color: AppColors.lightPrimaryGreen),
  //               borderRadius: BorderRadius.circular(20.0)),
  //           child: TabBar(
  //             indicator: BoxDecoration(
  //                 color: AppColors.darkGreen,
  //                 borderRadius: BorderRadius.circular(25.0)),
  //             indicatorSize: TabBarIndicatorSize.tab,
  //             indicatorWeight: 0,
  //             labelColor: Colors.white,
  //             unselectedLabelColor: Colors.black,
  //             tabs: const [
  //               Tab(
  //                 text: 'Balance',
  //               ),
  //               Tab(
  //                 text: 'Beneficiary',
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: AppUtils.deviceScreenSize(context).height +
  //               400, // Set an appropriate height
  //           child: TabBarView(
  //             children: [homeBalance(), const Text("Beneficiaries")],
  //           ),
  //         ),
  //         //quickActionsWidget(),
  //       ],
  //     ),
  //   );
  // }

  Widget homeProfileContainer(AdaptiveThemeMode theme) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is SuccessState) {
          PersonalInfo personalInfo = state.customerProfile.personalInfo;
          print(json.encode(state.customerProfile));
          // Use user data here
          return GestureDetector(
            onTap: () {
              print(json.encode(state.customerProfile));
            },
            child: SizedBox(
              height: 40,
              width: AppUtils.deviceScreenSize(context).width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        //backgroundImage: NetworkImage(),
                        child: SvgPicture.network(
                          personalInfo.imageUrl,
                          height: 32,
                          width: 32,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Hello",
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundSubTextColor
                                : AppColors.textColor2,
                            size: 12,
                          ),
                          TextStyles.textHeadings(
                              textValue:
                                  "${AppUtils.formatString(data: personalInfo.firstName)}",
                              textColor: theme.isDark
                                  ? AppColors.darkModeBackgroundMainTextColor
                                  : AppColors.textColor,
                              textSize: 14,
                              fontWeight: FontWeight.w400),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          AppNavigator.pushAndStackPage(
                            context,
                            page: const NetworkCenterMainPage(),
                          );
                        },
                        child: SvgPicture.asset(AppIcons.network),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(AppIcons.qrCode),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.lightgreen2,
                        child: SvgPicture.asset(AppIcons.notification),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 40,
            width: AppUtils.deviceScreenSize(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      //backgroundImage: NetworkImage(),
                      child: SvgPicture.asset(
                        AppIcons.person,
                        height: 32,
                        width: 32,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Hello",
                          color: theme.isDark
                              ? AppColors.darkModeBackgroundSubTextColor
                              : AppColors.textColor2,
                          size: 12,
                        ),
                        TextStyles.textHeadings(
                            textValue:
                                "${AppUtils.formatString(data: firstname)}",
                            textColor: theme.isDark
                                ? AppColors.darkModeBackgroundMainTextColor
                                : AppColors.textColor,
                            textSize: 14,
                            fontWeight: FontWeight.w400)
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(AppIcons.qrCode),
                    const SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.lightgreen2,
                      child: SvgPicture.asset(AppIcons.notification),
                    )
                  ],
                )
              ],
            ),
          ); // Show loading indicator or handle error state
        }
      },
    );
    // } catch (e) {
    //   print('Error loading image: $e');
    //   // Handle the error gracefully, such as displaying a placeholder image or error message
    //  // return Placeholder(); // Placeholder widget as an example
    // }
  }

  Widget homeBalance(AdaptiveThemeMode theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is SuccessState) {
              CustomerAccountModel? customerAccount =
                  state.customerProfile.customerAccount;
              //print(customerAccount!.id);
              if (customerAccount != null) {
                return const SizedBox();
              } else {
                return GestureDetector(
                  onTap: () {
                    AppNavigator.pushAndStackPage(context,
                        page: BlocProvider.value(
                            value: context.read<AppBloc>(),
                            child: const KYCIntro()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                        height: 40,
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
                                  SvgPicture.asset(AppIcons.info),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const CustomText(
                                    text: "Incomplete KYC",
                                    weight: FontWeight.bold,
                                    maxLines: 3,
                                    size: 12,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const CustomText(
                                    text: "Learn more",
                                    weight: FontWeight.bold,
                                    maxLines: 3,
                                    size: 12,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SvgPicture.asset(AppIcons.arrowSlant),
                                  // Icon(
                                  //   Icons.arrow_upward,
                                  //   color: AppColors.orange,
                                  // ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),

        balanceCardContainer(theme),
        const SizedBox(
          height: 10,
        ),
        // GestureDetector(
        //   onTap: () {
        //     AppNavigator.pushAndStackPage(context,
        //         page: BlocProvider.value(
        //             value: context.read<AppBloc>(), child: const KYCIntro()));
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Container(
        //         height: 70,
        //         decoration: BoxDecoration(
        //             color: AppColors.lightPrimary,
        //             borderRadius: BorderRadius.circular(20)),
        //         child: const Padding(
        //           padding: EdgeInsets.all(10.0),
        //           child: Row(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               CircleAvatar(
        //                 //backgroundImage: AssetImage(AppImages.airtel),
        //                 child: Icon(
        //                   Icons.notification_important_rounded,
        //                   color: AppColors.green,
        //                 ),
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   CustomText(
        //                     text: "Add a withdrawal account",
        //                     weight: FontWeight.bold,
        //                     maxLines: 3,
        //                   ),
        //                   // CustomText(
        //                   //   text: "description",
        //                   //   maxLines: 3,
        //                   //   size: 14,
        //                   // )
        //                 ],
        //               )
        //             ],
        //           ),
        //         )),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomText(
                text: "Quick Actions",
                weight: FontWeight.bold,
                color: theme.isDark
                    ? AppColors.darkModeBackgroundSubTextColor
                    : AppColors.textColor2,
                size: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    //color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.textColor2)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                  child: CustomText(
                    text: "See All",
                    size: 12,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundSubTextColor
                        : AppColors.textColor2,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        quickActionsWidget(theme),
        const SizedBox(
          height: 10,
        ),
        advertWidget(theme),
        const SizedBox(
          height: 20,
        ),
        popularPurchases(theme)
      ],
    );
  }

  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  final GlobalKey _sliderKey = GlobalKey();
  final List<String> advertImages = [
    AppImages.advertCard1,
    AppImages.advertCard2,
    AppImages.advertCard3,
    AppImages.advertCard4,
  ];

  Widget advertWidget(AdaptiveThemeMode theme) {
    return SizedBox(
      height: 155,
      child: CarouselSlider.builder(
        key: _sliderKey,
        unlimitedMode: true,
        autoSliderDelay: const Duration(seconds: 3),
        enableAutoSlider: true,
        controller: carouselSliderController,
        // onSlideChanged: (index) {
        //   setState(() {
        //     print(index);
        //     currentIndex = index;
        //   });
        // },
        slideBuilder: (index) {
          return Center(
            child: SizedBox(
              // Set the desired width of the container
              height: 150,

              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: AppUtils.deviceScreenSize(context).width,
                  // Set the desired width of the container
                  height: 125,
                  // Set the desired height of the container
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(advertImages[index]),
                      // Replace with your actual image file path
                      fit: BoxFit
                          .cover, // You can adjust the fit property to cover, contain, or others
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        slideTransform: const CubeTransform(),
        slideIndicator: SequentialFillIndicator(
          indicatorRadius: 5,
          itemSpacing: 20,

          // alignment: Alignment.topCenter,
          indicatorBackgroundColor: AppColors.grey,
          currentIndicatorColor: AppColors.green,
          padding: const EdgeInsets.only(bottom: 0),
        ),
        itemCount: advertImages.length,
        onSlideEnd: () {
          print("ended");
        },
      ),
    );
  }

  Widget balanceCardContainer(theme) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        //color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: theme.isDark
              ? [
                  const Color(0x000c311a).withOpacity(1),
                  const Color(0x000c311a).withOpacity(0.4),
                  Colors.blue.shade900.withOpacity(0.1), //Color(0x122E5A),
                  Colors.blue.shade900.withOpacity(0.3)
                ]
              : [
                  const Color(0x000b321a).withOpacity(1),
                  const Color(0x000b321a).withOpacity(1),
                  const Color(0x000c662f).withOpacity(1),
                  const Color(0x000c662f).withOpacity(1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),

        //image: DecorationImage(image: AssetImage())
      ),
      child: Stack(
        children: [
          Positioned(
              child: SvgPicture.asset(
            AppIcons.looper1,
            width: double.infinity,
            fit: BoxFit.fill,
          )),
          // Positioned(child: SvgPicture.asset(AppIcons.looper2)),
          Positioned(
              child: SizedBox(
            height: 210,
            // color: AppColors.red,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isMoneyBlocked = !isMoneyBlocked;
                        SharedPref.putBool('isMoneyBlocked', !isMoneyBlocked);
                        //isMoneyBlocked = await SharedPref.getBool('isMoneyBlocked') ?? false;
                      });
                      //await SharedPref.putBool("isMoneyblocked",!isMoneyBlocked);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            isMoneyBlocked
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.white,
                            size: 16,
                          )),
                    ),
                  ),
                  if (!isMoneyBlocked)
                    BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        if (state is SuccessState) {
                          WalletInfo walletInfo =
                              state.customerProfile.walletInfo;
                          // Use user data here
                          return Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.naira,
                                      height: 22,
                                      width: 22,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                                TextStyles.textHeadings(
                                    textValue: // "196,000.",
                                        "${AppUtils.convertPrice(walletInfo.balance.toString()).split('.')[0]}.",
                                    textSize: 28,
                                    textColor: AppColors.white),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  //mainAxisAlignment: MainAxisAlignment.,
                                  children: [
                                    TextStyles.textHeadings(
                                        textValue: AppUtils.convertPrice(
                                                walletInfo.balance.toString())
                                            .split('.')[1],
                                        textSize: 18,
                                        textColor: AppColors.white),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppIcons.naira,
                                height: 20,
                                width: 20,
                              ),
                              TextStyles.textHeadings(
                                  textValue: 'Loading...',
                                  textSize: 28,
                                  textColor: AppColors.white),
                              // TextStyles.textHeadings(
                              //     textValue: "",
                              //     //+walletInfo.balance.toString().split('.')[1],
                              //     textSize: 20,
                              //     textColor: AppColors.white)
                              // // const CustomText(
                              // //   text: "0.00",
                              // //   size: 25,
                              // //   weight: FontWeight.bold,
                              // //   color: AppColors.white,
                              // // )
                            ],
                          ); // Show loading indicator or handle error state
                        }
                      },
                    ),
                  if (isMoneyBlocked)
                    const CustomText(
                      text: "*******",
                      size: 22,
                      weight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<AppBloc, AppState>(
                        builder: (context, state) {
                          if (state is SuccessState) {
                            CustomerAccountModel? customerAccount =
                                state.customerProfile.customerAccount;
                            //print(customerAccount!.id);
                            if (customerAccount == null) {
                              return GestureDetector(
                                  onTap: () {
                                    showToast(
                                        context: context,
                                        title: 'Info',
                                        subtitle:
                                            'Oops! It looks like you have not done your KYC yet.',
                                        type: ToastMessageType.info);
                                  },
                                  child: childBalanceCardContainer(
                                      AppIcons.add, "Add Funds"));
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    modalSheet.showMaterialModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30.0)),
                                      ),
                                      context: context,
                                      builder: (context) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 100.0),
                                        child: AddFunds(
                                          customerAccountModel: customerAccount,
                                        ),
                                      ),
                                    );
                                  },
                                  child: childBalanceCardContainer(
                                      AppIcons.add, "Add Funds"));
                            }
                          } else {
                            return GestureDetector(
                                onTap: () {},
                                child: childBalanceCardContainer(
                                    AppIcons.add, "Add Funds"));
                          }
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            showToast(
                                context: context,
                                title: 'Info',
                                subtitle:
                                    'Oops! It looks like this service is still in the oven. We\'re baking up something great, so stay tuned! 🍰',
                                type: ToastMessageType.info);

                            // AppNavigator.pushAndStackPage(context,
                            //     page: const SendFunds());
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PinAuthentication(
                            //       onChanged: (v) {
                            //         if (kDebugMode) {
                            //           print(v);
                            //         }
                            //       },
                            //       onSpecialKeyTap: () {},
                            //       specialKey: const SizedBox(),
                            //       useFingerprint: true,
                            //       onbuttonClick: () {},
                            //       submitLabel: const Text(
                            //         'Submit',
                            //         style: TextStyle(color: Colors.white, fontSize: 20),
                            //       ),
                            //     ),
                            //   ),
                            // );
                          },
                          child:
                              childBalanceCardContainer(AppIcons.send, "Send")),
                      childBalanceCardContainer(AppIcons.switch1, "Withdraw"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) {
                      if (state is SuccessState) {
                        var customerAccount =
                            state.customerProfile.customerAccount;
                        // Use user data here
                        return customerAccount == null
                            ? accountNumberContainer("***")
                            : accountNumberContainer(
                                " ${customerAccount.nuban}");
                      } else {
                        return const SizedBox(); // Show loading indicator or handle error state
                      }
                    },
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget quickActionsWidget(AdaptiveThemeMode theme) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
          CategoryModel categoryModel = state.categoryModel;
          List<Category> items = categoryModel.data.categories;
          // items.sort((a, b) => a.name.compareTo(b.name));
          //Use user data here
          return SizedBox(
            height: items.length > 4 ? 160 : 80,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: items.length, //AppList().serviceItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      String selectedAction = '';
                      setState(() {
                        selectedAction = items[index].name.toLowerCase();
                      });
                      switch (selectedAction) {
                        case "airtime":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: AirtimePurchase(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case "airtime to cash":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: AirtimeToCash(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case "data":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: DataPurchase(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: DataPurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case "electricity":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child:
                                  ElectricityPurchase(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case 'cable tv':
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: CablePurchase(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: InternetPurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        // case 'Electricity':
                        //   modalSheet.showMaterialModalBottomSheet(
                        //     backgroundColor: Colors.transparent,
                        //     shape: const RoundedRectangleBorder(
                        //       borderRadius:
                        //           BorderRadius.vertical(top: Radius.circular(20.0)),
                        //     ),
                        //     context: context,
                        //     builder: (context) => Padding(
                        //       padding: const EdgeInsets.only(top: 100.0),
                        //       child: Electricity(
                        //           services: AppList().serviceItems[index]),
                        //     ),
                        //   );
                        //   // AppNavigator.pushAndStackPage(context, page: InternetPurchase(
                        //   //     services: AppList().serviceItems[index]));
                        //   return;
                        default:
                          showToast(
                              context: context,
                              title: 'Info',
                              subtitle:
                                  'Oops! It looks like this service is still in the oven. We\'re baking up something great, so stay tuned! 🍰',
                              type: ToastMessageType.info);
                      }

                      //showAirtimeModal(context, AppList().serviceItems[index]);
                    },
                    child: quickActionsItem(
                        items[index],
                        theme,
                        ['airtime', 'data', 'electricity', 'cable tv','airtime to cash']
                            .contains(items[index].name.toLowerCase())));
              },
            ),
          );
        } else {
          return SizedBox(
            height: 160,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: 8, //AppList().serviceItems.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)))),
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
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ); // Show loading indicator or handle error state
        }
      },
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

  Widget popularPurchases(AdaptiveThemeMode theme) {
    return SingleChildScrollView(
      child: Container(
        //height: 500,
        width: AppUtils.deviceScreenSize(context).width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: theme.isDark
                ? [
                    const Color(0x000c311a).withOpacity(1),
                    const Color(0x000c311a).withOpacity(0.4),
                    Colors.blue.shade900.withOpacity(0.1), //Color(0x122E5A),
                    Colors.blue.shade900.withOpacity(0.3)
                  ]
                : [
                    const Color(0x00e6fbee).withOpacity(1),
                    const Color(0x00e6fbee).withOpacity(0.4),
                    Colors.blue.shade900.withOpacity(0.1), //Color(0x122E5A),
                    Colors.blue.shade900.withOpacity(0.3)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Recent Transactions",
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundMainTextColor
                        : AppColors.textColor2,
                    size: 12,
                    weight: FontWeight.bold,
                  ),
                  GestureDetector(
                    onTap: (){AppNavigator.pushAndStackPage(context, page: const TransactionHistory());},

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            //color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.textColor2)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 5, 8, 5),
                          child: CustomText(
                            text: "See All",
                            size: 12,
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundSubTextColor
                                : AppColors.textColor2,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  if (state is SuccessState) {
                    var transactionHistory = state.transactionHistoryModel;
                    // Use user data here
                    print(transactionHistory);
                    print("transactionHistory");
                    print("transactionHistory");
                    return transactionHistory.data.items.isNotEmpty
                        ? SizedBox(
                            height: transactionHistory.data.items.length * 90,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactionHistory.data.items.length,
                              itemBuilder: (context, index) {
                                final transaction =
                                    transactionHistory.data.items[index];
                                final order = transaction.order;

                                return InkWell(
                                  onTap: () {
                                    print(transaction);
                                    AppNavigator.pushAndStackPage(
                                      context,
                                      page: TransactionReceipt(
                                          transaction: transaction),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: transaction
                                                  .order?.product?.name ??
                                              (transaction.type
                                                      .toLowerCase()
                                                      .contains('credit')
                                                  ? 'Credit'
                                                  : 'Debit'),
                                          size: 10,
                                          color: theme.isDark
                                              ? AppColors
                                                  .darkModeBackgroundSubTextColor
                                              : AppColors.textColor,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: order != null
                                                      ? NetworkImage(
                                                          order.product!.image)
                                                      : null,
                                                  child: order == null &&
                                                          (transaction.type
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'credit') ||
                                                              transaction.type
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'debit'))
                                                      ? Icon(
                                                          transaction.type
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'credit')
                                                              ? Icons
                                                                  .arrow_downward
                                                              : Icons
                                                                  .arrow_upward,
                                                          color: transaction
                                                                  .type
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'credit')
                                                              ? AppColors.green
                                                              : AppColors.red,
                                                        )
                                                      : const SizedBox(),
                                                ),
                                                //if(order!.requiredFields.phoneNumber.isNotEmpty||order.requiredFields.meterNumber!.isNotEmpty||order.requiredFields.cardNumber!.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: order
                                                                    ?.requiredFields
                                                                    .phoneNumber !=
                                                                null ||
                                                            order?.requiredFields
                                                                    .meterNumber !=
                                                                null ||
                                                            order?.requiredFields
                                                                    .cardNumber !=
                                                                null
                                                        ? 70
                                                        : 0,
                                                    decoration: BoxDecoration(
                                                      color: theme.isDark
                                                          ? AppColors.darkGreen
                                                          : AppColors
                                                              .lightShadowGreenColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color:
                                                              AppColors.green),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: CustomText(
                                                        text: order
                                                                ?.requiredFields
                                                                .meterNumber ??
                                                            order
                                                                ?.requiredFields
                                                                .cardNumber ??
                                                            order
                                                                ?.requiredFields
                                                                .phoneNumber ??
                                                            transaction.type,
                                                        size: 10,
                                                        color: theme.isDark
                                                            ? AppColors
                                                                .darkModeBackgroundMainTextColor
                                                            : AppColors
                                                                .textColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: theme.isDark
                                                          ? AppColors
                                                              .darkModeBackgroundContainerColor
                                                          : AppColors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color:
                                                              AppColors.grey),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: CustomText(
                                                        text: transaction.type
                                                                .toLowerCase()
                                                                .contains(
                                                                    'debit')
                                                            ? '-N${order?.requiredFields.amount ?? transaction.amount}'
                                                            : '+N${order?.requiredFields.amount ?? transaction.amount}',
                                                        size: 10,
                                                        color: theme.isDark
                                                            ? AppColors
                                                                .darkModeBackgroundMainTextColor
                                                            : AppColors
                                                                .textColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            CustomText(
                                              text: transaction.status
                                                          .toLowerCase() ==
                                                      "success"
                                                  ? "SUCCESSFUL"
                                                  : transaction.status
                                                      .toUpperCase(),
                                              color: transaction.status
                                                          .toLowerCase() ==
                                                      'success'
                                                  ? AppColors.green
                                                  : transaction.status
                                                              .toLowerCase() ==
                                                          'pending'
                                                      ? Colors.yellow.shade800
                                                      : AppColors.red,
                                              size: 10,
                                            )
                                          ],
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox();
                  } else {
                    return const LoadingDialog("Fetching recent transactions..."); // Show loading indicator or handle error state
                  }
                },
              ),

              // Container(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(
              //         height: 15,
              //       ),
              //       CustomText(
              //         text: "Airtime Purchase",
              //         size: 12,
              //         color: theme.isDark
              //             ? AppColors.darkModeBackgroundSubTextColor
              //             : AppColors.textColor,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               const CircleAvatar(
              //                 backgroundImage: AssetImage(AppImages.airtel),
              //               ),
              //               //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors.darkGreen
              //                           : AppColors.lightShadowGreenColor,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.green)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "08123457146",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundContainerColor
              //                           : AppColors.white,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.grey)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "N 1,500.00",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SvgPicture.asset(AppIcons.reload)
              //         ],
              //       ),
              //       const Divider()
              //     ],
              //   ),
              // ),
              // Container(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(
              //         height: 15,
              //       ),
              //       CustomText(
              //         text: "Data Purchase",
              //         size: 12,
              //         color: theme.isDark
              //             ? AppColors.darkModeBackgroundSubTextColor
              //             : AppColors.textColor,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               const CircleAvatar(
              //                 backgroundImage: AssetImage(AppImages.mtn),
              //               ),
              //               //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors.darkGreen
              //                           : AppColors.lightShadowGreenColor,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.green)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "08123457146",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundContainerColor
              //                           : AppColors.white,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.grey)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "N 1,500.00",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SvgPicture.asset(AppIcons.reload)
              //         ],
              //       ),
              //       const Divider()
              //     ],
              //   ),
              // ),
              // Container(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(
              //         height: 15,
              //       ),
              //       CustomText(
              //         text: "Data Purchase",
              //         size: 12,
              //         color: theme.isDark
              //             ? AppColors.darkModeBackgroundSubTextColor
              //             : AppColors.textColor,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               const CircleAvatar(
              //                 backgroundImage: AssetImage(AppImages.glo),
              //               ),
              //               //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors.darkGreen
              //                           : AppColors.lightShadowGreenColor,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.green)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "08123457146",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundContainerColor
              //                           : AppColors.white,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.grey)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "N 1,500.00",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SvgPicture.asset(AppIcons.reload)
              //         ],
              //       ),
              //       const Divider()
              //     ],
              //   ),
              // ),
              // Container(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(
              //         height: 15,
              //       ),
              //       CustomText(
              //         text: "Data Purchase",
              //         size: 12,
              //         color: theme.isDark
              //             ? AppColors.darkModeBackgroundSubTextColor
              //             : AppColors.textColor,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               const CircleAvatar(
              //                 backgroundImage: AssetImage(AppImages.mobile),
              //               ),
              //               //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors.darkGreen
              //                           : AppColors.lightShadowGreenColor,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.green)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "08123457146",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundContainerColor
              //                           : AppColors.white,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border: Border.all(color: AppColors.grey)),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: CustomText(
              //                       text: "N 1,500.00",
              //                       size: 12,
              //                       color: theme.isDark
              //                           ? AppColors
              //                               .darkModeBackgroundMainTextColor
              //                           : AppColors.textColor,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           SvgPicture.asset(AppIcons.reload)
              //         ],
              //       ),
              //       //const Divider()
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget childBalanceCardContainer(String icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.white,
          child: SvgPicture.asset(icon),
        ),
        const SizedBox(
          height: 5,
        ),
        CustomText(
          text: title,
          color: AppColors.white,
          size: 12,
        )
      ],
    );
  }

  Widget quickActionsItem(
      Category category, AdaptiveThemeMode theme, bool isPending) {
    return Column(
      children: [
        CircleAvatar(
          //radius: 24,
          //backgroundColor: service.backgroundColor,
          backgroundImage: NetworkImage(category.image),
          child: Align(
              alignment: Alignment.bottomRight,
              child: !isPending
                  ? const Icon(
                      Icons.access_time_outlined,
                      size: 10,
                      color: AppColors.yellow,
                    )
                  : const SizedBox()),
        ),
        const SizedBox(
          height: 5,
        ),
        CustomText(
          text: category.name,
          color: theme.isDark
              ? AppColors.darkModeBackgroundSubTextColor
              : AppColors.textColor,
          size: 12,
        )
      ],
    );
  }

  Widget accountNumberContainer(String accNumber) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
          color: accNumber == '***'
              ? AppColors.lightOrange
              : const Color(0xFFC2F6AE),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.logo,
                  height: 20,
                  width: 20,
                ),
                CustomText(
                  text: accNumber == '***'
                      ? " Complete KYC to get Safe Haven Account Number"
                      : " Safe Haven Account Number ",
                  color: AppColors.darkGreen,
                  size: 10,
                ),
                if (accNumber != '***')
                  CustomText(
                    text: accNumber,
                    color: AppColors.black,
                    size: 12,
                  ),
              ],
            ),
            if (accNumber != '***')
              GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: CustomText(
                      text: "Copied",
                      color: AppColors.white,
                    )));
                    AppUtils().copyToClipboard(accNumber, context);
                    // MSG.infoSnackBar(context, "copied");
                  },
                  child: SvgPicture.asset(
                    AppIcons.copy2,
                  ))
          ],
        ),
      ),
    );
  }
}
