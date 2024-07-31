import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_icons.dart';

import '../../../utills/custom_theme.dart';
import '../../widgets/app_custom_text.dart';

class TransactionHistoryCustomAppBar extends StatelessWidget {
  final String title;

  const TransactionHistoryCustomAppBar({
    super.key,
    required this.title,
  });

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
              text: 'Showing',
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
                      text: "All transactions",
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        AppIcons.filter,
                        // color: AppColors.green,
                        //theme: const SvgTheme(currentColor: AppColors.lightgreen2),
                      ),
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
