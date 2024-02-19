import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';

import '../../../res/app_icons.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/custom_container.dart';

class KycVerification extends StatefulWidget {
  const KycVerification({super.key});

  @override
  State<KycVerification> createState() => _KycVerificationState();
}

class _KycVerificationState extends State<KycVerification> {
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
            title: AppIcons.kycVerification,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomContainerFirTitleDescIcon(
                  title: "BVN",
                  description: "Not Submitted",
                  iconData: Icon(
                    Icons.person,
                    color: AppColors.grey,
                  ),
                ),
                CustomContainerFirTitleDescIcon(
                  title: "Identity Document",
                  description: "Not Submitted",
                  iconData: Icon(Icons.verified, color: AppColors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
