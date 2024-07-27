import 'package:flutter/material.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/recent_tranfer_details_widget.dart';
import 'package:teller_trust/view/sendBeneficary/widgets/recentTransfer/recent_transfer_header_widget.dart';

class RecentTransferView extends StatefulWidget {
  const RecentTransferView({super.key});

  @override
  State<RecentTransferView> createState() => _RecentTransferViewState();
}

class _RecentTransferViewState extends State<RecentTransferView> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecentTransferHeaderWidget(
            searchController: searchController,
            searchFunctionality: (value) {},
          ),
          const Expanded(
            child: RecentTranferDetailsWidget(),
          ),
        ],
      ),
    );
  }
}
