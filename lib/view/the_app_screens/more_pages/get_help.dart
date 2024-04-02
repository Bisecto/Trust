import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../res/app_icons.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';

class GetHelp extends StatefulWidget {
  const GetHelp({super.key});

  @override
  State<GetHelp> createState() => _GetHelpState();
}

class _GetHelpState extends State<GetHelp> {
  bool isSwitched = false;

  void _toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: AppIcons.getHelpAppBar,
            mainColor: AppColors.lightPurple,
            subColor: AppColors.purple,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomContainerFirTitleDescIcon(
                  title: "Have feedback or need support?\n Send us an Email",
                  description: "Support@tellatrust.com",
                  iconData:SvgPicture.asset(AppIcons.person,color: Colors.purple,),
                ),
                CustomContainerFirTitleDescIcon(
                  title: "Our agent are available 9am-5pm",
                  description: "0804747483 0907474832",
                  iconData:SvgPicture.asset(AppIcons.phone,color: Colors.purple,),
                ), CustomContainerFirTitleDescIcon(
                  title: "Whatsapp supports is available 24/7",
                  description: "0804747483",
                  iconData:SvgPicture.asset(AppIcons.phone,color: Colors.purple,),
                ), CustomContainerFirTitleDescIcon(
                  title: "Visit us at our Office Address",
                  description: "Somewhere within Abuja",
                  iconData:SvgPicture.asset(AppIcons.phone,color: Colors.purple,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
