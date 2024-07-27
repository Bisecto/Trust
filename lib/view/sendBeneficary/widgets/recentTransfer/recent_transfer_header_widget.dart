import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/send_search_widget.dart';

class RecentTransferHeaderWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) searchFunctionality;
  const RecentTransferHeaderWidget({
    super.key,
    required this.searchController,
    required this.searchFunctionality,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        bottom: 10.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.recentTxnInnerBgColor.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 30.0,
          bottom: 20.0,
        ),
        margin: const EdgeInsets.only(
          bottom: 12.0,
        ),
        decoration: const BoxDecoration(
          color: AppColors.recentTxnMainBgColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Transfers',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(
                          4.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.recentTxnCancelBtnBgColor
                              .withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/sendBeneficiary/circularCancelBtn.svg',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const AppSpacer(
              height: 30.0,
            ),
            SendSearchWidget(
              searchController: searchController,
              searchFunctionality: searchFunctionality,
            ),
          ],
        ),
      ),
    );
  }
}
