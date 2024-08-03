import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/view/widgets/form_input.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/app_custom_text.dart';

class BeneficiaryCustomAppBar extends StatelessWidget {
  final String title;
  final Color mainColor;
  final Color subColor;
  final CustomTextFormField textFormField;

  const BeneficiaryCustomAppBar(
      {super.key,
      required this.title,
      this.subColor = AppColors.appBarSubColor,
      this.mainColor = AppColors.appBarMainColor,required this.textFormField});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      height: 160,
      decoration: const BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextStyles.textHeadings(textValue: title, textSize: 20,textColor: theme.isDark?AppColors.darkModeBackgroundMainTextColor:AppColors.white),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    AppIcons.cancel2,
                    // color: AppColors.green,
                    //theme: const SvgTheme(currentColor: AppColors.lightgreen2),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            const CustomText(
              text: '',
              color: AppColors.white,
              size: 12,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.lightgreen2,
                  borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Search",
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                      },
                      child: Icon(Icons.search)
                    )
                  ],
                ),
              ),
            )
            //SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
}
