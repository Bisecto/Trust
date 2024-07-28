import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';

class RecentTransferItemWidget extends StatelessWidget {
  final bool isItTheLastTxnItem;
  final String transferTo;
  final String amountTransferred;
  final VoidCallback refreshTxnCallback;
  const RecentTransferItemWidget({
    super.key,
    required this.isItTheLastTxnItem,
    required this.transferTo,
    required this.refreshTxnCallback,
    required this.amountTransferred,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
            const AppSpacer(
              width: 2,
            ),
            Container(
              height: 15,
              padding: const EdgeInsets.all(
                5.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.recentTxnNameBgColor,
                borderRadius: BorderRadius.circular(
                  2.5,
                ),
                border: Border.all(
                  color: AppColors.recentTxnNameBorderColor,
                ),
              ),
              child: Center(
                child: Text(
                  transferTo,
                  style: const TextStyle(
                    color: AppColors.recentTxnNameTxtColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const AppSpacer(
              width: 2,
            ),
            Container(
              height: 15,
              padding: const EdgeInsets.all(
                3.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.recentTxnAmountBgColor,
                borderRadius: BorderRadius.circular(
                  2.5,
                ),
                border: Border.all(
                  color: AppColors.recentTxnAmountBorderColor,
                ),
              ),
              child: Center(
                child: Text(
                  amountTransferred,
                  style: const TextStyle(
                    color: AppColors.recentTxnAmountTxtColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.center,
                child: InkWell(
                  onTap: refreshTxnCallback,
                  child: SvgPicture.asset(
                    'assets/icons/sendBeneficiary/refresh.svg',
                  ),
                ),
              ),
            ),
          ],
        ),
        if (!isItTheLastTxnItem)
          const Divider(
            color: AppColors.sendStrokeColor,
          )
      ],
    );
  }
}
