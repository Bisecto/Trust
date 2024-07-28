import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/sendBeneficary/pages/recent_transfer_list_page.dart';

class SendMainHeaderWidget extends StatelessWidget {
  final String balance;
  const SendMainHeaderWidget({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.sendBackBtnColor,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/sendBeneficiary/back.svg',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 3.5,
              ),
              decoration: BoxDecoration(
                color: AppColors.sendBackBalanceBgColor,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                border: Border.all(
                  color: AppColors.sendBackBalanceBorderColor,
                ),
              ),
              child: const Center(
                child: Text(
                  'Balance',
                  style: TextStyle(
                    color: AppColors.sendToBalanceColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const AppSpacer(
              width: 10.0,
            ),
            Text(
              balance,
              style: const TextStyle(
                color: AppColors.sendToBalanceValueColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        InkWell(
          onTap: () {
            AppNavigator.pushAndStackPage(
              context,
              page: const RecentTransferListPage(),
            );
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.recentTxnBtnColor,
            ),
            child: Card(
              elevation: 2.0,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(
                  17.0,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/sendBeneficiary/recentTxn.svg',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
