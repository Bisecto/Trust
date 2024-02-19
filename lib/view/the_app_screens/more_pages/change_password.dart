import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/custom_container.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: AppIcons.changePassword,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomText(
                    text: "Let's help you restore your password",
                    weight: FontWeight.w600,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomContainerWithIcon(
                    title: 'Cprecious0310@gmail.com',
                    iconData: SvgPicture.asset(AppIcons.email),
                  ),
                ),

              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: FormButton(
                  onPressed: () {},
                  text: "Request OTP",
                  bgColor: AppColors.green,
                  borderRadius: 12),
            )
          ],
        ),
      ),
    );
  }
}
