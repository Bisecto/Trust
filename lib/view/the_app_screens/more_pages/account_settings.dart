import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_password.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/change_pin/old_pin.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/kyc_verification.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/profile_details.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/withdrawal_account.dart';

import '../../../model/user.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_navigator.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';

class AccountSetting extends StatefulWidget {
  User user;
   AccountSetting({super.key, required this.user});

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
    return Scaffold(
      //appBar: CustomAppBar(title: 'Account Setting',),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(
              title: AppIcons.accountSettingAppBar,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page:  ProfileDetails(user: widget.user,));
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "Profile Details",
                          description: "Account name, email, phone"),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: const WithdrawalAccount());
                      },
                      child: const CustomContainerFirTitleDesc(
                          title: "Withdrawal Account", description: "View/Add Withdrawal account"),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: const KycVerification());
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
                          description: "Secure alternative account\nAccess account"),
                    ),
                    CustomContainerForToggle(
                      title: "Use 4-Digit Access Pin",
                      description:
                          "If you disable this, you will be\nrequired to login using your\npassword on every entry",
                      isSwitched: isSwitched,
                      toggleSwitch: _toggleSwitch,
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
