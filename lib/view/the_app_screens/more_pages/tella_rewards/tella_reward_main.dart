import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_manage_point.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_points_history.dart';
import 'package:teller_trust/view/the_app_screens/sevices/card_request.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';


import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../../../res/app_icons.dart';
import '../../../../utills/custom_theme.dart';

class TellaPointMainPage extends StatefulWidget {
  const TellaPointMainPage({super.key});

  @override
  State<TellaPointMainPage> createState() => _TellaPointMainPageState();
}

class _TellaPointMainPageState extends State<TellaPointMainPage> {
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
              height: 170,
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
                  text: 'Manage Points',
                ),
                Tab(
                  text: 'Points History',
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppUtils.deviceScreenSize(context).height-150, // Set an appropriate height
            width: AppUtils.deviceScreenSize(context).width,
            child: TabBarView(
              children: [TellaManagePoint(), TellaPointsHistory()],
            ),
          )
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
          TextStyles.textHeadings(textValue: "Tella Point",
            textColor: AppColors.white,
            textSize: 20,
           ),

          GestureDetector(
            onTap: () {
               Navigator.pop(context);
            },
            child: SvgPicture.asset(
              AppIcons.cancel2,
              // color: AppColors.green,
              //theme: const SvgTheme(currentColor: AppColors.lightgreen2),
            ),
          )
        ],
      ),
    );
  }


}
