import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';

class CustomTransferWidget extends StatelessWidget {
  final bool isThisForDateWidget;
  final bool isItTheLastTxnItem;
  final String formattedDate;
  final String transferTo;
  final String amountTransferred;
  final VoidCallback refreshTxnCallback;
  const CustomTransferWidget({
    super.key,
    required this.isThisForDateWidget,
    required this.isItTheLastTxnItem,
    required this.amountTransferred,
    required this.formattedDate,
    required this.transferTo,
    required this.refreshTxnCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isThisForDateWidget ? 10 : null,
      width: isThisForDateWidget ? double.infinity : null,
      decoration: isThisForDateWidget
          ? BoxDecoration(
              color: AppColors.recentTxnDateBgColor,
              borderRadius: BorderRadius.circular(5.0))
          : const BoxDecoration(),
      padding: isThisForDateWidget
          ? null
          : const EdgeInsets.all(
              10.0,
            ),
      child: isThisForDateWidget
          ? Text(
              formattedDate,
              style: const TextStyle(
                color: AppColors.recentTxnDateTextColor,
                fontSize: 16.0,
              ),
            )
          : Column(
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
                        3.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.recentTxnNameBgColor,
                        border: Border.all(
                          color: AppColors.recentTxnNameBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          2.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          transferTo,
                          style: const TextStyle(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const AppSpacer(
                      width: 3,
                    ),
                    Container(
                      height: 15,
                      padding: const EdgeInsets.all(
                        3.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.recentTxnAmountBgColor,
                        border: Border.all(
                          color: AppColors.recentTxnAmountBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          2.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          amountTransferred,
                          style: const TextStyle(
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: InkWell(
                          onTap: refreshTxnCallback,
                          child: SvgPicture.asset(
                              'assets/icons/sendBeneficiary/refresh.svg'),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isItTheLastTxnItem)
                  const Divider(
                    color: AppColors.sendStrokeColor,
                  ),
              ],
            ),
    );
  }
}
