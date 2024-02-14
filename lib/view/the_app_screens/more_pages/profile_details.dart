import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../res/app_icons.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: AppIcons.profileDetails,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomContainerWithIcon(
                  title: 'Okafor',
                  iconData: SvgPicture.asset(AppIcons.person),
                ),
                CustomContainerWithIcon(
                  title: 'Precious',
                  iconData: SvgPicture.asset(AppIcons.person),
                ),
                CustomContainerWithIcon(
                  title: 'Chiemerie',
                  iconData: SvgPicture.asset(AppIcons.person),
                ),
                CustomContainerWithIcon(
                  title: 'Cprecious038@gmail.com',
                  iconData: SvgPicture.asset(AppIcons.email),
                ),
                CustomContainerWithIcon(
                  title: '08123457146',
                  iconData: SvgPicture.asset(AppIcons.phone),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
