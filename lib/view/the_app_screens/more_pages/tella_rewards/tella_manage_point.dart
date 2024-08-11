import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';

import '../../../../res/app_colors.dart';
import '../../../../res/app_icons.dart';

class TellaManagePoint extends StatefulWidget {
  const TellaManagePoint({super.key});

  @override
  State<TellaManagePoint> createState() => _TellaManagePointState();
}

class _TellaManagePointState extends State<TellaManagePoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            height: 70,
            width: AppUtils.deviceScreenSize(context).width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.lightGreen),
                color: AppColors.lightgreen2,
                image: DecorationImage(
                    image: AssetImage(AppImages.tellaPointBannerBackground),
                    fit: BoxFit.cover)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lightPrimary,
                  child: SvgPicture.asset(AppIcons.badge),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "Tella Point: 231",
                    ),
                    TextStyles.textHeadings(
                        textValue: 'Cash value: N231.00', textSize: 13,textColor: Colors.grey)
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextStyles.textHeadings(
              textValue: 'Tella Point Rules', textSize: 15,textColor: Colors.black)
        ],
      ),
    );
  }
}
