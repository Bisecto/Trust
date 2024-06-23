import 'dart:convert';
import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/model/personal_profile.dart';
import 'package:teller_trust/model/quick_access_model.dart';
import 'package:teller_trust/model/wallet_info.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_list.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/utills/shared_preferences.dart';
import 'package:teller_trust/view/the_app_screens/sevices/add_fundz.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime.dart';
import 'package:teller_trust/view/the_app_screens/sevices/data.dart';
import 'package:teller_trust/view/the_app_screens/sevices/internet.dart';
import 'package:teller_trust/view/the_app_screens/sevices/make_bank_transfer/bank_transfer.dart';
import 'package:teller_trust/view/the_app_screens/sevices/send_funds.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../bloc/app_bloc/app_bloc.dart';
import '../../model/category_model.dart';
import '../../model/user.dart';
import '../../res/app_images.dart';
import '../../utills/custom_theme.dart';
import '../important_pages/dialog_box.dart';
import 'kyc_verification/kyc_intro_page.dart';
import 'more_pages/withdrawal_account.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool selector = true;
  bool isMoneyBlocked = false;
  String firstname = "";
  String lastname = "";

  @override
  void initState() {
    // TODO: implement initState
    getName();
    super.initState();
  }

  Future<void> getName() async {
    firstname = await SharedPref.getString('firstName');
    lastname = await SharedPref.getString('lastName');
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      body: SafeArea(
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
                          borderRadius: BorderRadius.circular(10.0)),
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
                          border:
                              Border.all(color: AppColors.textColor2),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CustomText(
                          text: "Beneficiaries",
                          weight: FontWeight.bold,
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
                          CustomText(
                            text:
                                "${personalInfo.lastName} ${personalInfo.firstName}",
                            weight: FontWeight.bold,
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundMainTextColor
                                : AppColors.textColor,
                            size: 14,

                          ),
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
                      child: SvgPicture.network(
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
                        CustomText(
                          text: "$lastname $firstname",
                          weight: FontWeight.bold,
                          color: theme.isDark
                              ? AppColors.darkModeBackgroundMainTextColor
                              : AppColors.textColor,
                          size: 14,

                        ),
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
        GestureDetector(
          onTap: () {
            AppNavigator.pushAndStackPage(context,
                page: BlocProvider.value(
                    value: context.read<AppBloc>(), child: const KYCIntro()));
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                //height: 70,
                decoration: BoxDecoration(
                    color: AppColors.lightOrange,
                    border: Border.all(color: AppColors.orange),
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: AppColors.orange,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            text: "Incomplete KYC",
                            weight: FontWeight.bold,
                            maxLines: 3,
                            size: 12,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "Learn more",
                            weight: FontWeight.bold,
                            maxLines: 3,
                            size: 12,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_upward,
                            color: AppColors.orange,
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
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
Widget advertWidget (AdaptiveThemeMode theme){
  return  SizedBox(
    height: 155,
    child: CarouselSlider.builder(
      key: _sliderKey,
      unlimitedMode: true,
      autoSliderDelay: const Duration(seconds: 3),
      enableAutoSlider:true,
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
              child:                     Container(
                width:
                AppUtils.deviceScreenSize(context).width,
                // Set the desired width of the container
                height:
                125,
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
      slideTransform: CubeTransform(),
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
      height: 200,
      decoration: BoxDecoration(
        //color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: theme.isDark
              ? [
            const Color(0x0C311A).withOpacity(1),
            const Color(0x0C311A).withOpacity(0.4),
            Colors.blue.shade900.withOpacity(0.1), //Color(0x122E5A),
            Colors.blue.shade900.withOpacity(0.3)
          ]
              : [

            const Color(0x0B321A).withOpacity(1),
            const Color(0x0B321A).withOpacity(1),
            const Color(0x0C662F).withOpacity(1),
            const Color(0x0C662F).withOpacity(1),

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
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          isMoneyBlocked
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.white,
                        )),
                  ),
                  if (!isMoneyBlocked)
                    BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        if (state is SuccessState) {
                          WalletInfo walletInfo =
                              state.customerProfile.walletInfo;
                          // Use user data here
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcons.naira,height: 20,width: 20,),
                              TextStyles.textHeadings(textValue: '192,600.00',textSize: 28,textColor: AppColors.white)

                              // CustomText(
                              //   text: walletInfo.balance.toString(),
                              //   size: 22,
                              //   weight: FontWeight.bold,
                              //   color: AppColors.white,
                              // )
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcons.naira,height: 20,width: 20,),
                              TextStyles.textHeadings(textValue: '0.00',textSize: 28,textColor: AppColors.white)
                              // const CustomText(
                              //   text: "0.00",
                              //   size: 25,
                              //   weight: FontWeight.bold,
                              //   color: AppColors.white,
                              // )
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
                      GestureDetector(
                          onTap: () {
                            modalSheet.showMaterialModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30.0)),
                              ),
                              context: context,
                              builder: (context) => const Padding(
                                padding: EdgeInsets.only(top: 100.0),
                                child: AddFunds(),
                              ),
                            );
                          },
                          child: childBalanceCardContainer(
                              AppIcons.add, "Add Funds")),
                      GestureDetector(
                          onTap: () {
                            AppNavigator.pushAndStackPage(context,
                                page: const SendFunds());
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
                            ? accountNumberContainer(" ********")
                            : accountNumberContainer(" 8765564367");
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
          //Use user data here
          return SizedBox(
            height:items.length>4? 150:80,
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
                        selectedAction = items[index].name;
                      });
                      switch (selectedAction)
                      {
                        case "Airtime":
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
                        case "Data":
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
                        case 'Cable TV':
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: InternetPurchase(category: items[index]),
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
                      }

                      //showAirtimeModal(context, AppList().serviceItems[index]);
                    },
                    child: quickActionsItem(items[index], theme));
              },
            ),
          );
        } else {
          return CustomText(
            text: "There",
            size: 15,
            weight: FontWeight.bold,
            color: theme.isDark
                ? AppColors.darkModeBackgroundSubTextColor
                : AppColors.textColor,
          ); // Show loading indicator or handle error state
        }
      },
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
                    const Color(0x0C311A).withOpacity(1),
                    const Color(0x0C311A).withOpacity(0.4),
                    Colors.blue.shade900.withOpacity(0.1), //Color(0x122E5A),
                    Colors.blue.shade900.withOpacity(0.3)
                  ]
                : [
                    const Color(0xE6FBEE).withOpacity(1),
                    const Color(0xE6FBEE).withOpacity(0.4),
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
              CustomText(
                text: "Top 5 Popular Purchases",
                color: theme.isDark
                    ? AppColors.darkModeBackgroundMainTextColor
                    : AppColors.textColor2,
                size: 12,
                weight: FontWeight.bold,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      text: "Airtime Purchase",
                      size: 12,
                      color: theme.isDark
                          ? AppColors.darkModeBackgroundSubTextColor
                          : AppColors.textColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(AppImages.airtel),
                            ),
                            //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors.darkGreen
                                        : AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundContainerColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    const Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      text: "Data Purchase",
                      size: 12,
                      color: theme.isDark
                          ? AppColors.darkModeBackgroundSubTextColor
                          : AppColors.textColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(AppImages.mtn),
                            ),
                            //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors.darkGreen
                                        : AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundContainerColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    const Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      text: "Data Purchase",
                      size: 12,
                      color: theme.isDark
                          ? AppColors.darkModeBackgroundSubTextColor
                          : AppColors.textColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(AppImages.glo),
                            ),
                            //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors.darkGreen
                                        : AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundContainerColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    const Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CustomText(
                      text: "Data Purchase",
                      size: 12,
                      color: theme.isDark
                          ? AppColors.darkModeBackgroundSubTextColor
                          : AppColors.textColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(AppImages.mobile),
                            ),
                            //SvgPicture.asset(AppImages.mtn,color: AppColors.white,height: 50,width: 50,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors.darkGreen
                                        : AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundContainerColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                    size: 12,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundMainTextColor
                                        : AppColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    //const Divider()
                  ],
                ),
              ),
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
        const SizedBox(height: 5,),
        CustomText(
          text: title,
          color: AppColors.white,
          size: 12,
        )
      ],
    );
  }

  Widget quickActionsItem(Category category, AdaptiveThemeMode theme) {
    return Column(
      children: [
        CircleAvatar(
          //radius: 24,
          //backgroundColor: service.backgroundColor,

          child: Image.network(category.image,),
        ),
        const SizedBox(height: 5,),
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
          color: AppColors.lightgreen2,
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
                const CustomText(
                  text: " Tellatrust Account Number ",
                  color: AppColors.darkGreen,
                  size: 12,
                ),
                CustomText(
                  text: accNumber,
                  color: AppColors.black,
                  size: 12,
                ),
              ],
            ),
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
                child: const Icon(
                  Icons.copy_all_rounded,
                  color: AppColors.lightgrey,
                ))
          ],
        ),
      ),
    );
  }
}
