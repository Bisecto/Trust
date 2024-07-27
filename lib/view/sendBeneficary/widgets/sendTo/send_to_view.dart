import 'package:flutter/material.dart';
import 'package:teller_trust/domain/txn/txn_details_to_send_out.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/bg_logo_display_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_header_widget.dart';

class SendToView extends StatefulWidget {
  final TxnDetailsToSendOut txnDetails;
  const SendToView({
    super.key,
    required this.txnDetails,
  });

  @override
  State<SendToView> createState() => _SendToViewState();
}

class _SendToViewState extends State<SendToView> {
  late TxnDetailsToSendOut txnDetails;

  @override
  void initState() {
    txnDetails = widget.txnDetails;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BgLogoDisplayWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SendToHeaderWidget(
              amountTransferred: txnDetails.amount,
            ),
          ],
        ),
      ),
    );
  }
}
