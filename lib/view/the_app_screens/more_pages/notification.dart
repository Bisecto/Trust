import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../res/app_icons.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
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
          CustomAppBar(title: AppIcons.notificationAppBar,),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomContainerForToggle(
                  title: "Email Notifications",
                  description:
                  "",
                  isSwitched: isSwitched,
                  toggleSwitch: _toggleSwitch,
                ),CustomContainerForToggle(
                  title: "SMS Notifications",
                  description:
                  "",
                  isSwitched: isSwitched,
                  toggleSwitch: _toggleSwitch,
                ),

              ],
            ),
          )

        ],
      ),
    );
  }
}
