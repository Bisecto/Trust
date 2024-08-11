import 'package:flutter/material.dart';

import '../../../utills/app_navigator.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';
import 'change_password.dart';
import 'change_pin/old_pin.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool isSwitched = false
  ;

  void _toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          const CustomAppBar(title: "Security",),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    AppNavigator.pushAndStackPage(context,
                        page: const ChangePassword());
                  },
                  child: const CustomContainerFirTitleDesc(
                      title: "Change Password",
                      description: "Secure access to your account"),
                ),
                InkWell(
                  onTap: () {
                    AppNavigator.pushAndStackPage(context,
                        page: const OldPin());
                  },
                  child: const CustomContainerFirTitleDesc(
                      title: "Change 4-Digit Access PIN",
                      description:
                      "Secure alternative account\nAccess account"),
                ),
                // CustomContainerForToggle(
                //   title: "Face ID",
                //   description:
                //   "Account name, email, phone",
                //   isSwitched: isSwitched,
                //   toggleSwitch: _toggleSwitch,
                // ),

              ],
            ),
          )

        ],
      ),
    );
  }
}
