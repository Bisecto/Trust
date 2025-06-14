import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../res/app_icons.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/appBar_widget.dart';
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
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      body: Column(
        children: [
          const CustomAppBar(
            title: "Get Help",
            mainColor: AppColors.lightPurple,
            subColor: AppColors.purple,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomContainerFirTitleDescIcon(
                  title: "Have feedback or need support?\nSend us an Email",
                  description: "Tellatrust@gmail.com",
                  iconData: SvgPicture.asset(
                    AppIcons.person,
                    color: Colors.purple,
                  ),
                ),
                CustomContainerFirTitleDescIcon(
                  title: "Our agent are available 9am-5pm",
                  description: "09069496990",
                  iconData: SvgPicture.asset(
                    AppIcons.phone,
                    color: Colors.purple,
                  ),
                ),
                CustomContainerFirTitleDescIcon(
                  title: "Whatsapp supports is available 24/7",
                  description: "09069496990",
                  iconData: SvgPicture.asset(
                    AppIcons.phone,
                    color: Colors.purple,
                  ),
                ),
                CustomContainerFirTitleDescIcon(
                  title: "Visit us at our Office Address",
                  description:
                      "No 9B Seguela Street, Wuse Zone 2, British\nVillage,"
                      " Off IBB Boulevard Abuja, Nigeria",
                  iconData: SvgPicture.asset(
                    AppIcons.phone,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
