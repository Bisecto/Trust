import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../res/app_icons.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
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
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: AppIcons.legalAppBar,
            mainColor: AppColors.lightOrange,
            subColor: AppColors.orange,
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithRightIcon(
                    title: 'Terms & Conditions',
                    //: SvgPicture.asset(AppIcons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithRightIcon(
                    title: 'Policies',
                    //: SvgPicture.asset(AppIcons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithRightIcon(
                    title: 'Disclaimer',
                    //: SvgPicture.asset(AppIcons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithRightIcon(
                    title: 'FAQs',
                    //: SvgPicture.asset(AppIcons.person),
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
