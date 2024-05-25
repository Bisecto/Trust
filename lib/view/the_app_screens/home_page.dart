import 'dart:convert';
import 'dart:developer';

import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
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
import 'package:teller_trust/view/the_app_screens/sevices/send_funds.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../bloc/app_bloc/app_bloc.dart';
import '../../model/category_model.dart';
import '../../model/user.dart';
import '../../res/app_images.dart';
import '../important_pages/dialog_box.dart';
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
    isMoneyBlocked = await SharedPref.getBool('isMoneyBlocked')??false;
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
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              homeProfileContainer(),
              const SizedBox(
                height: 20,
              ),
              balanceBeneficiarySelector(),
            ],
          ),
        ),
      )),
    );
  }

  Widget balanceBeneficiarySelector() {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: AppUtils.deviceScreenSize(context).width / 2,
            decoration: BoxDecoration(
                //color: Colors.grey[300],
                border: Border.all(color: AppColors.lightPrimaryGreen),
                borderRadius: BorderRadius.circular(20.0)),
            child: TabBar(
              indicator: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(25.0)),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(
                  text: 'Balance',
                ),
                Tab(
                  text: 'Beneficiary',
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppUtils.deviceScreenSize(context).height +
                400, // Set an appropriate height
            child: TabBarView(
              children: [homeBalance(), const Text("Beneficiaries")],
            ),
          ),
          //quickActionsWidget(),
        ],
      ),
    );
  }

  Widget homeProfileContainer() {
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
              height: 50,
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
                          height: 25,
                          width: 25,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Hello",
                          ),
                          CustomText(
                            text:
                                "${personalInfo.lastName} ${personalInfo.firstName}",
                            weight: FontWeight.w600,
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
                        backgroundColor: AppColors.lightPrimary,
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
            height: 50,
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
                        height: 25,
                        width: 25,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Hello",
                        ),
                        CustomText(
                          text: "$lastname $firstname",
                          weight: FontWeight.w600,
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
                      backgroundColor: AppColors.lightPrimary,
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

  Widget homeBalance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        balanceCardContainer(),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                AppNavigator.pushAndStackPage(context,
                    page: BlocProvider.value(
                        value: context.read<AppBloc>(),
                        child: WithdrawalAccount()));
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: AppColors.lightPrimary,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            //backgroundImage: AssetImage(AppImages.airtel),
                            child: Icon(
                              Icons.notification_important_rounded,
                              color: AppColors.green,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Add a withdrawal account",
                                weight: FontWeight.bold,
                                maxLines: 3,
                              ),
                              // CustomText(
                              //   text: "description",
                              //   maxLines: 3,
                              //   size: 14,
                              // )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: CustomText(
                text: "Quick Actions",
                weight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CustomText(
                    text: "See All",
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        quickActionsWidget(),
        const SizedBox(
          height: 20,
        ),
        popularPurchases()
      ],
    );
  }

  Widget balanceCardContainer() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(20),
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
            height: 220,
            // color: AppColors.red,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                              SvgPicture.asset(AppIcons.naira),
                              CustomText(
                                text: walletInfo.balance.toString(),
                                size: 22,
                                weight: FontWeight.bold,
                                color: AppColors.white,
                              )
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcons.naira),
                              const CustomText(
                                text: "0.00",
                                size: 22,
                                weight: FontWeight.bold,
                                color: AppColors.white,
                              )
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
                    height: 20,
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
                              builder: (context) => Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: AddFunds(),
                              ),
                            );
                          },
                          child: childBalanceCardContainer(
                              AppIcons.add, "Add Funds")),
                      GestureDetector(
                          onTap: () {
                            AppNavigator.pushAndStackPage(context,
                                page: SendFunds());
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
                      childBalanceCardContainer(
                          AppIcons.switch1, "Switch Account"),
                    ],
                  ),
                  SizedBox(height: 10),
                  accountNumberContainer("8765564367")
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget quickActionsWidget() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
          CategoryModel categoryModel = state.categoryModel;
          List<Category> items = categoryModel.data.categories;
          //Use user data here
          return SizedBox(
            height:  105 ,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 4, //AppList().serviceItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      String selectedAction='';
                      setState(() {
                        selectedAction=items[index].name;
                      });
                      switch (selectedAction) {
                        case "Airtime":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: AirtimePurchase(
                                  category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case "Data":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: DataPurchase(
                                  category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: DataPurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case 'Cable TV':
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: InternetPurchase(
                                  category: items[index]),
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
                    child: quickActionsItem(items[index]));
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
    );
  }

  Widget popularPurchases() {
    return SingleChildScrollView(
      child: Container(
        height: 500,
        width: AppUtils.deviceScreenSize(context).width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              Colors.blue.shade50,
              Colors.blue.shade50
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
              const CustomText(
                text: "Top 5 Popular Purchases",
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    const CustomText(
                      text: "Airtime Purchase",
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
                                    color: AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    const CustomText(
                      text: "Data Purchase",
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
                                    color: AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    const CustomText(
                      text: "Data Purchase",
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
                                    color: AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    const CustomText(
                      text: "Data Purchase",
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
                                    color: AppColors.lightShadowGreenColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.green)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "08123457146",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(
                                    text: "N 1,500.00",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AppIcons.reload)
                      ],
                    ),
                    Divider()
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
        CustomText(
          text: title,
          color: AppColors.white,
        )
      ],
    );
  }

  Widget quickActionsItem(Category category) {
    return Column(
      children: [
        CircleAvatar(
          //backgroundColor: service.backgroundColor,
          child: Image.network(category.image),
        ),
        CustomText(
          text: category.name,
          color: AppColors.textColor,
        )
      ],
    );
  }

  Widget accountNumberContainer(String accNumber) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: AppColors.lightgreen2,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  AppImages.logo,
                  height: 20,
                  width: 20,
                ),
                const CustomText(
                  text: " Tella Trust Account Number ",
                  color: AppColors.darkGreen,
                  size: 13,
                ),
                CustomText(
                  text: accNumber,
                  color: AppColors.black,
                  size: 14,
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
                child: const Icon(Icons.copy))
          ],
        ),
      ),
    );
  }
}
