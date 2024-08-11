import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/the_app_screens/kyc_verification/kyc_intro_page.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_password.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_pin/old_pin.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_router.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/shared_preferences.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({
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

  bool isBiometricEnabled = false;
  bool canUseBiometrics = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    getCanUseBiometrics();
    getCanUseBiometrics2();
  }

  Future<void> getCanUseBiometrics2() async {
    var availableBiometrics = await auth.getAvailableBiometrics();
    print(availableBiometrics);
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    print(canCheckBiometrics);
    bool isDeviceSupported = await auth.isDeviceSupported();
    print(isDeviceSupported);
    setState(() {
      // Ensure each condition evaluates to a boolean
      canUseBiometrics = canCheckBiometrics && // Note the function call
          isDeviceSupported &&
          availableBiometrics.isNotEmpty;
    });
  }

  Future<void> getCanUseBiometrics() async {
    bool biometricEnabled = await SharedPref.getBool('biometric') ?? false;
    setState(() {
      isBiometricEnabled = biometricEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    buildSwitchToggle() {
      return CupertinoSwitch(
          value: themeContext.adaptiveThemeMode.isDark,
          activeColor:
              theme.isDark ? AppColors.green : Colors.grey.withOpacity(0.3),
          thumbColor: theme.isDark ? Colors.white : Colors.white,
          onChanged: (value) {
            themeContext.changeTheme(context);
          });
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: theme.isDark
          ? Brightness.light
          : Brightness
              .dark, // Brightness.light for white icons, Brightness.dark for dark icons
    ));
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
                    InkWell(
                      onTap: () {
                        AppNavigator.pushAndStackNamed(context,
                            name: AppRouter.profileDetailsPage);
                        // AppNavigator.pushAndStackPage(context,
                        //     page: ProfileDetails());
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "Profile Details",
                          description: "Account name, email, phone"),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     AppNavigator.pushAndStackPage(context,
                    //         page: const WithdrawalAccount());
                    //   },
                    //   child: const CustomContainerFirTitleDesc(
                    //       title: "Withdrawal Account",
                    //       description: "View/Add Withdrawal account"),
                    // ),
                    InkWell(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: const KYCIntro());
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "KYC", description: "Complete this to unlock features"),
                    ),

                    // CustomContainerForToggle(
                    //   title: "Use 4-Digit Access Pin",
                    //   description:
                    //       "If you disable this, you will be\nrequired to login using your\npassword on every entry",
                    //   isSwitched: isSwitched,
                    //   toggleSwitch: _toggleSwitch,
                    // ),
                    AppSpacer(height: 15,),
                    canUseBiometrics
                        ? BuildListTile(
                            icon: AppIcons.biometric,
                            title: "Enable Biometrics",
                            onPressed: () {},
                            trailingWidget: CupertinoSwitch(
                              value: isBiometricEnabled,
                              onChanged: (value) {
                                setState(() {
                                  isBiometricEnabled = value;
                                  SharedPref.putBool('biometric', value);
                                });
                              },
                              activeColor: AppColors.darkGreen,
                            ),
                          )
                        : SizedBox(),
                    // BuildListTile(
                    //   icon: AppIcons.darkMode,
                    //   title: "Enable Biometrics",
                    //   onPressed: () {},
                    //   trailingWidget: CupertinoSwitch(
                    //     value: isBiometricEnabled,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         isBiometricEnabled = value;
                    //         SharedPref.putBool('biometric', value);
                    //       });
                    //     },
                    //     activeColor: AppColors.green,
                    //   ),
                    // ),

                    // const SizedBox(
                    //   height: 10,
                    // ),
                    BuildListTile(
                      icon: AppIcons.darkMode,
                      title: "Enable Dark Mode",
                      onPressed: null,
                      trailingWidget: buildSwitchToggle(),
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
                      style: const TextStyle(
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
