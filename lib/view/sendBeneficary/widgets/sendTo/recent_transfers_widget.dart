import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/recent_transfer_item_widget.dart';

class RecentTransfersWidget extends StatefulWidget {
  const RecentTransfersWidget({super.key});

  @override
  State<RecentTransfersWidget> createState() => _RecentTransfersWidgetState();
}

class _RecentTransfersWidgetState extends State<RecentTransfersWidget> {
  List recentTransfers = [];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.sendToRecentTransferBgColor,
          borderRadius: BorderRadius.circular(
            7.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transfers',
              style: TextStyle(
                color: AppColors.sendToRecentTransferTxtColor,
              ),
            ),
            const AppSpacer(
              height: 10.0,
            ),
            ListView.builder(
              itemCount: recentTransfers.length,
              itemBuilder: (context, index) {
                bool isItTheLastTxnItem = false;
                String transferTo = '';
                String amountTransferred = '';
                return RecentTransferItemWidget(
                  isItTheLastTxnItem: isItTheLastTxnItem,
                  transferTo: transferTo,
                  refreshTxnCallback: () {},
                  amountTransferred: amountTransferred,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
