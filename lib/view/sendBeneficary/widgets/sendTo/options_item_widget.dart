import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';

class OptionsItemWidget extends StatefulWidget {
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
  State<OptionsItemWidget> createState() => _OptionsItemWidgetState();
}

class _OptionsItemWidgetState extends State<OptionsItemWidget> {
  bool isOptionItemSelected = false;

  bool isItForTellaTrustTransferOption = false;

  @override
  void initState() {
    isItForTellaTrustTransferOption = widget.isItForTellaTrustTransferOption;
    isOptionItemSelected = widget.isOptionItemSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isItForTellaTrustTransferOption
            ? AppColors.white
            : AppColors.sendToBankBgColor.withOpacity(0.7),
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
          SvgPicture.asset(isItForTellaTrustTransferOption
              ? 'assets/icons/sendBeneficiary/tellaTrustGreen.svg'
              : 'assets/icons/sendBeneficiary/bank.svg'),
          const AppSpacer(
            width: 1.5,
          ),
          Text(
            isItForTellaTrustTransferOption
                ? 'Tella Trust Transfer'
                : 'Bank Transfer',
            style: const TextStyle(
              color: AppColors.sendBodyTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
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
        ],
      ),
    );
  }
}
