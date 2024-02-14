import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../res/app_colors.dart';
import '../../res/app_icons.dart';
import '../../utills/app_utils.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: AppColors.lightShadowGreenColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Column(
        children: [
          Container(
            height: 100,
            width: AppUtils.deviceScreenSize(context).width,
            decoration: BoxDecoration(
                color: Color.fromRGBO(227, 255, 214, 100),
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
