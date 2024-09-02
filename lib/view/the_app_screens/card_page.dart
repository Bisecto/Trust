import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/sevices/card_request.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../res/app_icons.dart';
import '../../res/app_images.dart';
import '../../utills/custom_theme.dart';
import '../widgets/form_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
      final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

      return Scaffold(
        backgroundColor:
        theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
        body: Container(
        height: AppUtils.deviceScreenSize(context).height,
        width: AppUtils.deviceScreenSize(context).width,
        color: AppColors.white,

        // decoration: BoxDecoration(
        //   color: AppColors.white,
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        //   // image: DecorationImage(image: AssetImage())
        // ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 230,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: SvgPicture.asset(
                  AppIcons.looper1,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    cardTopContainer(),
                    const SizedBox(height: 10), // Add some spacing
                    cardTabController(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardTabController() {
    return DefaultTabController(
      length: 2,
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
                borderRadius: BorderRadius.circular(16.0)),
            child: TabBar(
              indicator: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(16.0)),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.transparent,
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
          SizedBox(
            height: AppUtils.deviceScreenSize(context).height -
                200, // Set an appropriate height
            width: AppUtils.deviceScreenSize(context).width,
            child: TabBarView(
              children: [physicalCardContaner(), virtualCardContaner()],
            ),
          ),
          //quickActionsWidget(),
        ],
      ),
    );
  }

  Widget cardTopContainer() {
    return SizedBox(
      height: 40,
      width: AppUtils.deviceScreenSize(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(
            text: "Card",
            color: AppColors.white,
            size: 24,
            weight: FontWeight.bold,
          ),
          CircleAvatar(
            backgroundColor: AppColors.lightPrimary,
            child: SvgPicture.asset(AppIcons.notification),
          )
        ],
      ),
    );
  }

  Widget virtualCardContaner() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 350,
            width: 250,
            decoration: BoxDecoration(
                //color: Colors.grey[300],
                //border: Border.all(color: AppColors.lightPrimaryGreen),
                borderRadius: BorderRadius.circular(20.0),
                image: const DecorationImage(
                    image: AssetImage(AppImages.virtualCardStraight),
                    fit: BoxFit.cover)),
          ),
          SvgPicture.asset(
            AppIcons.virtualCard1,
            height: 70,
          ),
          SvgPicture.asset(
            AppIcons.virtualCard2,
            height: 70,
          ),
          SvgPicture.asset(
            AppIcons.virtualCard3,
            height: 70,
          ),
          FormButton(
            onPressed: () {},
            text: "Create my Virtual card",
            borderRadius: 15,
            height: 50,
            bgColor: AppColors.green,
          ),
        ],
      ),
    );
  }

  Widget physicalCardContaner() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 350,
            width: 250,
            decoration: BoxDecoration(
                //color: Colors.grey[300],
                //border: Border.all(color: AppColors.lightPrimaryGreen),
                borderRadius: BorderRadius.circular(20.0),
                image: const DecorationImage(
                    image: AssetImage(AppImages.physicalCardStraight),
                    fit: BoxFit.fill)),
          ),
          FormButton(
            onPressed: () {
              modalSheet.showMaterialModalBottomSheet(
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                context: context,
                builder: (context) => const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: TellaCardRequest(),
                ),
              );
            },
            text: "Request card",
            borderRadius: 15,
            height: 50,
            bgColor: AppColors.green,
          ),
        ],
      ),
    );
  }
}
