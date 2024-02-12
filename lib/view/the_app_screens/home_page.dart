import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/model/quick_access_model.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_list.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../res/app_images.dart';
import '../important_pages/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool selector = true;

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
          Container(
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
    return Container(
      height: 50,
      width: AppUtils.deviceScreenSize(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AppImages.profileAvatar),
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
                    text: "Okafor Precious",
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
                child: SvgPicture.asset(AppIcons.notification),
                backgroundColor: AppColors.lightPrimary,
              )
            ],
          )
        ],
      ),
    );
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: CustomText(
                text: "Quick Actions",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.grey)
                ),child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CustomText(text: "See All",),
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
              child: Container(
            height: 220,
            // color: AppColors.red,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.remove_red_eye,
                        color: AppColors.white,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.naira),
                      const CustomText(
                        text: "17,926,502.00",
                        size: 22,
                        weight: FontWeight.bold,
                        color: AppColors.white,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      childBalanceCardContainer(AppIcons.add, "Add Funds"),
                      childBalanceCardContainer(AppIcons.send, "Send"),
                      childBalanceCardContainer(
                          AppIcons.switch1, "Switch Account"),
                    ],
                  ),
                  SizedBox(height:10),
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
    return Container(
      height: 210,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 8, //AppList().serviceItems.length,
        itemBuilder: (context, index) {
          return quickActionsItem(AppList().serviceItems[index]);
        },
      ),
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
              Colors.blue.shade100
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
                    SizedBox(height: 15,),

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
                                  border: Border.all(color: AppColors.green)
                                ),child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(text: "08123457146",),
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)
                                ),child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CustomText(text: "N 1,500.00",),
                              ),

                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.restart_alt)
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
                    SizedBox(height: 15,),

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
                                  border: Border.all(color: AppColors.green)
                                ),child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(text: "08123457146",),
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)
                                ),child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CustomText(text: "N 1,500.00",),
                              ),

                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.restart_alt)
                      ],
                    ),
                    Divider()

                  ],
                ),
              ), Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(height: 15,),

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
                                  border: Border.all(color: AppColors.green)
                                ),child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(text: "08123457146",),
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)
                                ),child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CustomText(text: "N 1,500.00",),
                              ),

                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.restart_alt)
                      ],
                    ),
                    Divider()

                  ],
                ),
              ), Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(height: 15,),

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
                                  border: Border.all(color: AppColors.green)
                                ),child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomText(text: "08123457146",),
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.grey)
                                ),child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CustomText(text: "N 1,500.00",),
                              ),

                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.restart_alt)
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

  Widget quickActionsItem(Services service) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: service.backgroundColor,
          child: SvgPicture.asset(service.image),
        ),
        CustomText(
          text: service.title,
          color: AppColors.textColor,
        )
      ],
    );
  }

  Widget accountNumberContainer(String accNumber) {
    return Container(
      height:50,
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
                  size: 15,
                ),
                CustomText(
                  text: accNumber,
                  color: AppColors.black,
                  size: 15,
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
                  AppUtils().copyToClipboard(accNumber);
                  // MSG.infoSnackBar(context, "copied");
                },
                child: const Icon(Icons.copy))
          ],
        ),
      ),
    );
  }

}
