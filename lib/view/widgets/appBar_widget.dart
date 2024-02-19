import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/app_colors.dart';
import '../../res/app_icons.dart';
import '../../utills/app_utils.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Color mainColor;
  final Color subColor;

  const CustomAppBar({super.key, required this.title,this.subColor=AppColors.appBarSubColor,this.mainColor=AppColors.appBarMainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color:subColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Column(
        children: [
          Container(
            height: 100,
            width: AppUtils.deviceScreenSize(context).width,
            decoration: BoxDecoration(
                color: mainColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30))),
            child: Row(
              children: [
                SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                      onTap: () {Navigator.pop(context);}, child: SvgPicture.asset(title)),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
