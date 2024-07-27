import 'package:flutter/material.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/recent_transfer_view.dart';

class RecentTransferListPage extends StatelessWidget {
  const RecentTransferListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: RecentTransferView(),
    );
  }
}
