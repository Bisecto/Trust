import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/model/customer_account_model.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/auth/sign_in_screen.dart';
import 'package:teller_trust/view/the_app_screens/kyc_verification/kyc_intro_page.dart';

import '../../../res/apis.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_router.dart';
import '../../../res/sharedpref_key.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../../utills/shared_preferences.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';

class AccountSetting extends StatefulWidget {
  CustomerAccountModel? customerAccount;

  AccountSetting({super.key, this.customerAccount});

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
  bool isNotificationEnabled = false;
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
    bool biometricEnabled =
        await SharedPref.getBool(SharedPrefKey.biometricKey) ?? false;
    bool notificationEnabled =
        await SharedPref.getBool(SharedPrefKey.notificationKey) ?? true;
    setState(() {
      isBiometricEnabled = biometricEnabled;
      isNotificationEnabled = notificationEnabled;
      print("notificationEnabled");
      print(isNotificationEnabled);
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
                    if (widget.customerAccount == null)
                      InkWell(
                        onTap: () {
                          AppNavigator.pushAndStackPage(context,
                              page: const KYCIntro());
                        },
                        child: const CustomContainerFirTitleDesc(
                            title: "KYC",
                            description: "Complete this to unlock features"),
                      ),

                    // CustomContainerForToggle(
                    //   title: "Use 4-Digit Access Pin",
                    //   description:
                    //       "If you disable this, you will be\nrequired to login using your\npassword on every entry",
                    //   isSwitched: isSwitched,
                    //   toggleSwitch: _toggleSwitch,
                    // ),
                    const AppSpacer(
                      height: 15,
                    ),
                    BuildListTile(
                      icon: AppIcons.notification,
                      title: "Enable Notification",
                      onPressed: () {},
                      trailingWidget: CupertinoSwitch(
                        value: isNotificationEnabled,
                        onChanged: (value) async {
                          setState(() {
                            print(value);
                            isNotificationEnabled = value;
                            SharedPref.putBool(
                                SharedPrefKey.notificationKey, value);
                          });
                          String accessToken = await SharedPref.getString(
                              SharedPrefKey.accessTokenKey);
                          AppRepository appRepository = AppRepository();
                          String? token =
                              await FirebaseMessaging.instance.getToken();
                          var respons = await appRepository.appPutRequest({
                            "fcmToken": token,
                            "isSubscribe": value
                          }, "${AppApis.appBaseUrl}/user/c/enable-push-message",
                              accessToken: accessToken);
                          print(respons.body);
                        },
                        activeColor: AppColors.darkGreen,
                      ),
                    ),
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
                                  SharedPref.putBool(
                                      SharedPrefKey.biometricKey, value);
                                });
                              },
                              activeColor: AppColors.darkGreen,
                            ),
                          )
                        : const SizedBox(),
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
                    InkWell(
                      onTap: () async {
                        Future<bool?> showAccountDeletionModal({
                          required BuildContext context,
                          required VoidCallback onConfirm,
                        }) {
                          final theme = Provider.of<CustomThemeState>(context,
                                  listen: false)
                              .adaptiveThemeMode;

                          return showDialog<bool>(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 50, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundContainerColor
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Are you sure you want to close your account as this action cannot be reversed?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          fontFamily: 'CeraPro',
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.white,
                                                foregroundColor:
                                                    AppColors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              child: const Text(
                                                "No",
                                                style: TextStyle(
                                                  color: AppColors.black,
                                                  fontFamily: 'CeraPro',
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context,
                                                    true); // returns true
                                                onConfirm();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.green,
                                                foregroundColor:
                                                    AppColors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              child: const Text(
                                                "Yes, I want to",
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontFamily: 'CeraPro',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        final confirmed = await showAccountDeletionModal(
                          context: context,
                          onConfirm: () async {
                            final repository = AppRepository();
                            final userId = await SharedPref.getString(
                                SharedPrefKey.userIdKey);
                            final accessToken = await SharedPref.getString(
                                SharedPrefKey.accessTokenKey);

                            await repository.appPutRequest(
                              {"consent": "DELETE"},
                              AppApis.deactivate + userId,
                              accessToken: accessToken,
                            );

                            // await FirebaseMessaging.instance
                            //     .unsubscribeFromTopic(userId);
                            await clearAllSharedPrefs();
                            AppNavigator.pushAndRemovePreviousPages(context,
                                page: const SignInScreen());
                          },
                        );

                        if (confirmed == true) {
                          // Optionally handle any additional cleanup here
                        }
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "Close Account",
                          description: "Deactivate your Tella Trust account"),
                    ),
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
