import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/view/the_app_screens/kyc_verification/kyc_intro_page.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_password.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_pin/old_pin.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/kyc_verification.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/profile_details.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/withdrawal_account.dart';

import '../../../model/user.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_router.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({
    super.key,
  });

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  bool isSwitched = true;

  void _toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    _buildSwitchToggle() {
      return CupertinoSwitch(
          value: themeContext.adaptiveThemeMode.isDark,
          activeColor:
              theme.isDark ? AppColors.green : Colors.grey.withOpacity(0.3),
          thumbColor: theme.isDark ? Colors.white : Colors.white,
          onChanged: (value) {
            themeContext.changeTheme(context);
          });
    }

    return Scaffold(
      backgroundColor:
      theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      //appBar: CustomAppBar(title: 'Account Setting',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(
              title: "Account Settings",
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackNamed(context, name: AppRouter.profileDetailsPage);
                        // AppNavigator.pushAndStackPage(context,
                        //     page: ProfileDetails());
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "Profile Details",
                          description: "Account name, email, phone"),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     AppNavigator.pushAndStackPage(context,
                    //         page: const WithdrawalAccount());
                    //   },
                    //   child: const CustomContainerFirTitleDesc(
                    //       title: "Withdrawal Account",
                    //       description: "View/Add Withdrawal account"),
                    // ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: const KYCIntro());
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "KYC", description: "Identification document"),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: const ChangePassword());
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "Change Password",
                          description: "Secure access to your account"),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: const OldPin());
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "Change 4-Digit Access PIN",
                          description:
                              "Secure alternative account\nAccess account"),
                    ),
                    CustomContainerForToggle(
                      title: "Use 4-Digit Access Pin",
                      description:
                          "If you disable this, you will be\nrequired to login using your\npassword on every entry",
                      isSwitched: isSwitched,
                      toggleSwitch: _toggleSwitch,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BuildListTile(
                      icon: AppIcons.darkMode,
                      title: "Enable Dark Mode",
                      onPressed: null,
                      trailingWidget: _buildSwitchToggle(),
                    ),
                    const CustomContainerFirTitleDesc(
                        title: "Close Account",
                        description: "Deactivate your Tella Trust account"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BuildListTile extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final dynamic onPressed;
  final Widget? trailingWidget;

  const BuildListTile(
      {Key? key,
      required this.icon,
      this.subtitle,
      required this.title,
      this.onPressed,
      this.trailingWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context);
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey),
                //color: theme.adaptiveThemeMode.isDark ? AppColors.darkModeBackgroundContainerColor : AppColors.grey,
                borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: theme.adaptiveThemeMode.isDark
                    ? Colors.white
                        .withOpacity(0.06) //Tools.hexToColor("#403C3C")
                    : AppUtils.hexToColor("#FDF8F3"),
                child: SvgPicture.asset(
                  icon,
                  height: 18,
                  color: theme.adaptiveThemeMode.isDark
                      ? Colors.white
                      : AppColors.green,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: theme.adaptiveThemeMode.isDark
                      ? AppColors.white
                      : AppColors.black,
                  fontSize: 18,
                ),
              ),
              subtitle: subtitle != null
                  ? Text(
                      subtitle!,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                    )
                  : null,
              trailing: trailingWidget ??
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.adaptiveThemeMode.isDark
                        ? Colors.white
                        : AppColors.green,
                    size: 16,
                  ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
