import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';

class OptionsItemWidget extends StatelessWidget {
  final bool isItForTellaTrustTransferOption;
  final bool isOptionItemSelected;
  final VoidCallback selectedCallback;
  const OptionsItemWidget({
    super.key,
    this.isItForTellaTrustTransferOption = true,
    this.isOptionItemSelected = false,
    required this.selectedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 7.0,
      ),
      decoration: BoxDecoration(
        color: isItForTellaTrustTransferOption
            ? AppColors.white
            : AppColors.sendToBankBgColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        border: Border.all(
          color: isItForTellaTrustTransferOption
              ? AppColors.sendToTellaBorderColor
              : AppColors.sendToBankBgColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isItForTellaTrustTransferOption
                ? 'assets/icons/sendBeneficiary/tellaTrustGreen.svg'
                : 'assets/icons/sendBeneficiary/bank.svg',
            height: 25.0,
          ),
          const AppSpacer(
            width: 3,
          ),
          FittedBox(
            child: Text(
              isItForTellaTrustTransferOption
                  ? 'Tella Trust Transfer'
                  : 'Bank Transfer',
              style: const TextStyle(
                color: AppColors.sendBodyTextColor,
                fontSize: 12.0,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: InkWell(
                onTap: selectedCallback,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isItForTellaTrustTransferOption
                            ? AppColors.sendToBorderColor
                            : AppColors.sendToBankBgColor,
                        width: 1.5,
                      )),
                  child: isOptionItemSelected
                      ? Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: isItForTellaTrustTransferOption
                                ? AppColors.sendToTellaColor
                                : AppColors.sendToBankBgColor,
                            shape: BoxShape.circle,
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
