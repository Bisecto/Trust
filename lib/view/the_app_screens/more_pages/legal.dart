
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../utills/custom_theme.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';

class Legal extends StatefulWidget {
  const Legal({super.key});

  @override
  State<Legal> createState() => _LegalState();
}

class _LegalState extends State<Legal> {
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
      backgroundColor: theme.isDark?AppColors.darkModeBackgroundColor:AppColors.white,
      body: Column(
        children: [
          const CustomAppBar(
            title: "Legal",
            mainColor: AppColors.lightOrange,
            subColor: AppColors.orange,
          ),
          InkWell(
            onTap: ()  async {
              await EasyLauncher.url(url: "http://tellatrust.com/legal/terms-and-conditions");            },
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CustomContainerWithRightIcon(
                      title: 'Terms & Conditions',
                      //: SvgPicture.asset(AppIcons.person),
                    ),
                  ),
                  InkWell(
                    onTap: ()  async {
                      await EasyLauncher.url(url: "http://tellatrust.com/legal/privacy-policy");            },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CustomContainerWithRightIcon(
                        title: 'Policies',
                        //: SvgPicture.asset(AppIcons.person),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CustomContainerWithRightIcon(
                      title: 'Disclaimer',
                      //: SvgPicture.asset(AppIcons.person),
                    ),
                  ),
                  InkWell(
                    onTap: ()  async {
                      await EasyLauncher.url(url: "http://tellatrust.com");            },

                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CustomContainerWithRightIcon(
                        title: 'FAQs',
                        //: SvgPicture.asset(AppIcons.person),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
