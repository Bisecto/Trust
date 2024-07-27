import 'package:flutter/material.dart';
import 'package:teller_trust/domain/txn/txn_details_to_send_out.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/sendTo/send_to_view.dart';

class SendToPage extends StatelessWidget {
  final TxnDetailsToSendOut txnDetails;
  const SendToPage({
    super.key,
    required this.txnDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: SendToView(
        txnDetails: txnDetails,
      ),
    );
  }
}
