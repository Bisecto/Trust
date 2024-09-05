import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/auth/sign_in_screen.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/get_help.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/legal.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/notification.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/profile_details.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/security_page.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_manage_point.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/tella_rewards/tella_reward_main.dart';

import '../../bloc/app_bloc/app_bloc.dart';
import '../../model/customer_account_model.dart';
import '../../model/personal_profile.dart';
import '../../res/app_colors.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/app_navigator.dart';
import '../../utills/custom_theme.dart';
import '../../utills/shared_preferences.dart';
import '../widgets/app_custom_text.dart';
import 'more_pages/account_settings.dart';
import 'more_pages/tella_rewards/tella_point_product_container.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    super.key,
  });

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  String firstname = "";
  String lastname = "";

  @override
  void initState() {
    // TODO: implement initState
    getName();

    super.initState();
  }

  Future<void> getName() async {
    firstname = await SharedPref.getString(SharedPrefKey.firstNameKey);
    lastname = await SharedPref.getString(SharedPrefKey.lastNameKey);
  }

  CustomerAccountModel? customerAccountModel;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 225,
              decoration: BoxDecoration(
                  color: theme.isDark
                      ? AppColors.darkGreen
                      : AppColors.lightShadowGreenColor,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    height: 160,
                    width: AppUtils.deviceScreenSize(context).width,
                    decoration: BoxDecoration(
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundColor
                            : const Color.fromRGBO(227, 255, 214, 100),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(30))),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //SvgPicture.asset(AppIcons.profiletext),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17),
                              child: TextStyles.textHeadings(
                                  textValue: 'Profile',
                                  textColor: AppColors.darkGreen)),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: profileContainer(theme),
                          ),
                          //SvgPicture.asset(AppIcons.profileLabel)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    //height: 42,

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CustomText(
                                text: "KYC Level",
                                size: 12,
                                color: !theme.isDark
                                    ? AppColors.textColor2
                                    : AppColors.white,
                              ),
                              Container(
                                  //height: 40,
                                  //width: AppUtils.deviceScreenSize(context).width / 2,
                                  decoration: BoxDecoration(
                                      color: AppColors.lightgreen2,
                                      border: Border.all(
                                          color: AppColors.lightPrimaryGreen),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 5, 10, 5),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.aboutTellaTrust,
                                          width: 15,
                                          height: 15,
                                        ),
                                        CustomText(
                                          text: " Level 0",
                                          weight: FontWeight.bold,
                                          size: 12,
                                          color: theme.isDark
                                              ? AppColors.green
                                              : AppColors.green,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              CustomText(
                                text: "Daily Transaction Limit",
                                size: 12,
                                color: !theme.isDark
                                    ? AppColors.textColor2
                                    : AppColors.white,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(AppIcons.naira,
                                      color: AppColors.lightGreen),
                                  TextStyles.textHeadings(
                                      textValue: "0.00 ",
                                      textSize: 16,
                                      textColor: theme.isDark
                                          ? AppColors.white
                                          : AppColors.black),
                                  TextStyles.textHeadings(
                                      textValue: "/",
                                      textSize: 16,
                                      textColor: AppColors.lightGreen),
                                  SvgPicture.asset(AppIcons.naira,
                                      color: theme.isDark
                                          ? AppColors.white
                                          : AppColors.textColor2),
                                  CustomText(
                                      text: "0.00",
                                      size: 16,
                                      color: theme.isDark
                                          ? AppColors.white
                                          : AppColors.textColor2),

                                  // TextStyle.(
                                  //   text: "Daily Transaction Limit",
                                  //   size: 12,
                                  //   color: !theme.isDark
                                  //       ? AppColors.textColor2
                                  //       : AppColors.white,
                                  // ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 42,
                  //
                  //   child: SvgPicture.asset(AppIcons.dailyLimit),
                  // )
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    // AppNavigator.pushAndStackPage(context,
                    //     page: TellaPointMainPage());
                  },
                  child: TellaPointProductContainer(),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: AccountSetting(
                            customerAccount: customerAccountModel,
                          ));
                    },
                    child: itemContainer(
                        AppIcons.accounsetting, 'Account Settings', theme)),
                // SvgPicture.asset(AppIcons.accounsetting)),
                InkWell(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: const Security());
                    },
                    child: itemContainer(AppIcons.security, 'Security', theme)),
                itemContainer(AppIcons.statement, 'Statement', theme),
                InkWell(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: const NotificationSetting());
                    },
                    child: itemContainer(
                        AppIcons.notificationSetting, 'Notifications', theme)),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Divider(),
                ),
                InkWell(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: const GetHelp());
                    },
                    child: itemContainer(AppIcons.getHelp, 'Get Help', theme)),
                InkWell(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: const Legal());
                    },
                    child: itemContainer(AppIcons.legal, 'Legal', theme)),
                itemContainer(
                    AppIcons.aboutTellaTrust, 'About Tellatrust', theme),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Divider(),
                ),
                InkWell(
                    onTap: () async {
                      await AppUtils().logout(context);
                      await FirebaseMessaging.instance.deleteToken();
                      AppNavigator.pushAndRemovePreviousPages(context,
                          page: const SignInScreen());
                    },
                    child: SvgPicture.asset(AppIcons.logOut)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget itemContainer(String icon, String title, AdaptiveThemeMode theme) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(icon),
                const SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: title,
                  size: 14,
                  weight: FontWeight.w600,
                  color: theme.isDark ? AppColors.textColor2 : AppColors.black,
                )
              ],
            ),
            const Icon(Icons.navigate_next_outlined)
          ],
        ),
      ),
    );
  }

  Widget profileContainer(AdaptiveThemeMode theme) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is SuccessState) {
          PersonalInfo personalInfo = state.customerProfile.personalInfo;
          customerAccountModel = state.customerProfile.customerAccount;

          print(json.encode(state.customerProfile));
          // Use user data here
          return InkWell(
            onTap: () {
              AppNavigator.pushAndStackPage(context, page: const ProfileDetails());
              //print(json.encode(state.customerProfile));
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
                        backgroundImage: NetworkImage(
                          personalInfo.imageUrl,
                        ),
                        // child: SvgPicture.network(
                        //   personalInfo.imageUrl,
                        //   height: 32,
                        //   width: 32,
                        // ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text:
                                "${AppUtils.formatString(data: personalInfo.lastName)} ${AppUtils.formatString(data: personalInfo.firstName)}",
                            weight: FontWeight.bold,
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundMainTextColor
                                : AppColors.textColor,
                            size: 14,
                          ),
                          //if (customerAccount != null)
                          Row(
                            children: [
                              TextStyles.textSubHeadings(
                                textValue: 'USERNAME:  ',
                                textColor: theme.isDark
                                    ? AppColors.darkModeBackgroundSubTextColor
                                    : AppColors.textColor2,
                                textSize: 12,
                              ),
                              GestureDetector(
                                onTap: (){
                                  AppUtils().copyToClipboard(personalInfo.userName, context);
                                },
                                child: CustomText(
                                  text: personalInfo.userName,
                                  color: theme.isDark
                                      ? AppColors.darkModeBackgroundSubTextColor
                                      : AppColors.textColor2,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const Icon(Icons.navigate_next_outlined)
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
}
