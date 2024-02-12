import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../res/app_icons.dart';
import '../../res/app_images.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: AppUtils.deviceScreenSize(context).height * 0.4,
        width: AppUtils.deviceScreenSize(context).width,
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          // image: DecorationImage(image: AssetImage())
        ),
        child: Stack(
          children: [
            Positioned(
                child: Container(
                  child: SvgPicture.asset(
              AppIcons.looper1,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
                )),
            Positioned(
                child: Container(
                  child: Stack(
                    children: [
                      Positioned(child: cardTopContainer()),
                      Positioned.fill(top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: cardTabController()),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget cardTabController() {
    return DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: AppUtils.deviceScreenSize(context).width,
              decoration: BoxDecoration(
                  //color: Colors.grey[300],
                  border: Border.all(color: AppColors.lightPrimaryGreen),
                  borderRadius: BorderRadius.circular(20.0)),
              child: TabBar(
                indicator: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(25.0)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 0,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(
                    text: 'Physical',
                  ),
                  Tab(
                    text: 'Virtual',
                  ),
                ],
              ),
            ),
            Container(
              height: AppUtils.deviceScreenSize(context).height +
                  400, // Set an appropriate height
              width: AppUtils.deviceScreenSize(context).width,
              child: TabBarView(
                children: [Text("Debit"), const Text("Beneficiaries")],
              ),
            ),
            //quickActionsWidget(),
          ],
        ),
      ),
    );
  }

  Widget cardTopContainer() {
    return Container(
      height: 50,
      width: AppUtils.deviceScreenSize(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: "Card",
            color: AppColors.white,
            size: 24,
            weight: FontWeight.bold,
          ),
          CircleAvatar(
            child: SvgPicture.asset(AppIcons.notification),
            backgroundColor: AppColors.lightPrimary,
          )
        ],
      ),
    );
  }
}
