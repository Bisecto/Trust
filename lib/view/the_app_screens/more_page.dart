import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/auth/sign_in_screen.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/get_help.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/legal.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/notification.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/security_page.dart';

import '../../model/user.dart';
import '../../res/app_colors.dart';
import '../../utills/app_navigator.dart';
import '../../utills/shared_preferences.dart';
import 'more_pages/account_settings.dart';

class MorePage extends StatefulWidget {
  User user;

  MorePage({super.key, required this.user});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 235,
              decoration: BoxDecoration(
                  color: AppColors.lightShadowGreenColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    height: 175,
                    width: AppUtils.deviceScreenSize(context).width,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(227, 255, 214, 100),
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(30))),
                    child: SafeArea(
                      child: Column(
                        children: [
                          SvgPicture.asset(AppIcons.profiletext),
                          SvgPicture.asset(AppIcons.profileLabel)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 42,
                    child: SvgPicture.asset(AppIcons.dailyLimit),
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SvgPicture.asset(AppIcons.tellaRewards),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: AccountSetting(
                            user: widget.user,
                          ));
                    },
                    child: SvgPicture.asset(AppIcons.accounsetting)),
                GestureDetector(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context, page: Security());
                    },
                    child: SvgPicture.asset(AppIcons.security)),
                SvgPicture.asset(AppIcons.statement),
                GestureDetector(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: NotificationSetting());
                    },
                    child: SvgPicture.asset(AppIcons.notificationSetting)),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Divider(),
                ),
                GestureDetector(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context, page: GetHelp());
                    },
                    child: SvgPicture.asset(AppIcons.getHelp)),
                GestureDetector(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context, page: Legal());
                    },
                    child: SvgPicture.asset(AppIcons.legal)),
                SvgPicture.asset(AppIcons.aboutTellaTrust),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Divider(),
                ),
                GestureDetector(
                    onTap: () {
                      SharedPref.remove("password");
                      SharedPref.remove("email");
                      SharedPref.remove("phone");
                      SharedPref.remove("accessPin");
                      SharedPref.remove("userId");
                      SharedPref.remove("firstname");
                      SharedPref.remove("lastname");
                      SharedPref.remove("userData");
                      SharedPref.remove("userId");

                      SharedPref.remove("refresh-token");
                      SharedPref.remove("access-token");
                      AppNavigator.pushAndRemovePreviousPages(context, page: SignInScreen());
                    }, child: SvgPicture.asset(AppIcons.logOut)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
