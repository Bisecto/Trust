import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/top_beneficiaries_item_widget.dart';

import '../../../../utills/custom_theme.dart';

class TopBeneficiariesWidget extends StatelessWidget {
  final List beneficiaries;
  final bool isItForTellaTrust;
  final bool isUserVerified;
  final String transferredToName;

  const TopBeneficiariesWidget({
    super.key,
    required this.beneficiaries,
    required this.isItForTellaTrust,
    required this.isUserVerified,
    required this.transferredToName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return
      // isUserVerified && isItForTellaTrust
      //   ? Container()
      //   :
    Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Send to',
                    style: TextStyle(
                      color: theme.isDark
                          ? AppColors.darkModeBackgroundMainTextColor
                          : AppColors.sendToLabelColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    transferredToName,
                    style: TextStyle(
                      color: theme.isDark
                          ? AppColors.darkModeBackgroundMainTextColor
                          : AppColors.sendToLabelColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (isItForTellaTrust)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSpacer(
                      height: 20.0,
                    ),
                     Text(
                      'Top Beneficiaries',
                      style: TextStyle(
                        color:theme.isDark?AppColors.darkModeBackgroundMainTextColor: AppColors.sendBodyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                    const AppSpacer(
                      height: 5.0,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...List.generate(
                            beneficiaries.length,
                            (index) {
                              String beneficiaryFullname = '';
                              String beneficiaryImagePath = '';
                              return TopBeneficiariesItemWidget(
                                beneficiaryFullname: beneficiaryFullname,
                                beneficiaryImagePath: beneficiaryImagePath,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const AppSpacer(
                      height: 10.0,
                    ),
                     Divider(color: theme.isDark?AppColors.darkModeBackgroundMainTextColor: null,),
                  ],
                ),
            ],
          );
  }
}
