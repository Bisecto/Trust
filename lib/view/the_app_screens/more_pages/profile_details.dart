import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../res/app_colors.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CustomAppBar(
                  title: AppIcons.profileDetails,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithIcon(
                    title: 'Okafor',
                    iconData: SvgPicture.asset(AppIcons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithIcon(
                    title: 'Precious',
                    iconData: SvgPicture.asset(AppIcons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithIcon(
                    title: 'Chiemerie',
                    iconData: SvgPicture.asset(AppIcons.person),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithIcon(
                    title: 'Cprecious0310@gmail.com',
                    iconData: SvgPicture.asset(AppIcons.email),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithIcon(
                    title: '010123457146',
                    iconData: SvgPicture.asset(AppIcons.phone),
                  ),
                ),
              ],
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(10,0,10,30),
              child: FormButton(
                onPressed: () {},
                text: "Update Profile",
                bgColor: AppColors.green,
                borderRadius:12
              ),
            )
          ],
        ),
      ),
    );
  }
}
