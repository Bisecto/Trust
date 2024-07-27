import 'package:flutter/material.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/custom_transfer_widget.dart';

class RecentTranferDetailsWidget extends StatefulWidget {
  const RecentTranferDetailsWidget({super.key});

  @override
  State<RecentTranferDetailsWidget> createState() =>
      _RecentTranferDetailsWidgetState();
}

class _RecentTranferDetailsWidgetState
    extends State<RecentTranferDetailsWidget> {
  List recentTransactions = [];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        bool isThisForDateWidget = false;
        bool isItTheLastTxnItem = false;

        String amountTransferred = '';
        String formattedDate = '';
        String transferTo = '';

        return CustomTransferWidget(
          isThisForDateWidget: isThisForDateWidget,
          isItTheLastTxnItem: isItTheLastTxnItem,
          amountTransferred: amountTransferred,
          formattedDate: formattedDate,
          transferTo: transferTo,
          refreshTxnCallback: (){

          },
        );
      },
    );
  }
}
