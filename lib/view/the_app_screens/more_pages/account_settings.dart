import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/view/the_app_screens/more_pages/profile_details.dart';

import '../../../res/app_colors.dart';
import '../../../utills/app_navigator.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

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
      body: Column(
        children: [
          const CustomAppBar(
            title: AppIcons.accountSettingAppBar,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    AppNavigator.pushAndStackPage(context,
                        page: const ProfileDetails());
                  },
                  child: const CustomContainerFirTitleDesc(
                      title: "Profile Details",
                      description: "Account name, email, phone"),
                ),
                const CustomContainerFirTitleDesc(
                    title: "KYC", description: "Identification document"),
                const CustomContainerFirTitleDesc(
                    title: "Change Password",
                    description: "Secure access to your account"),
                const CustomContainerFirTitleDesc(
                    title: "Change 4-Digit Access PIN",
                    description: "Secure alternative account Access account"),
                CustomContainerForToggle(
                  title: "Use 4-Digit Access Pin",
                  description:
                      "If you disable this, you will be required to\nlogin using your password on every entry",
                  isSwitched: isSwitched,
                  toggleSwitch: _toggleSwitch,
                ),
                const CustomContainerFirTitleDesc(
                    title: "Close Account",
                    description: "Deactivate your Tella Trust account"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
