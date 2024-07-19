import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/bank/bank_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class BankScaffoldWidget extends StatefulWidget {
  const BankScaffoldWidget({super.key});

  @override
  State<BankScaffoldWidget> createState() => _BankScaffoldWidgetState();
}

class _BankScaffoldWidgetState extends State<BankScaffoldWidget> {
  final TextEditingController bankSearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: bankSearchController,
            title: 'Bank Success Rate',
            searchFunctionality: (value){
              debugPrint('Bank search value is $value');
            },
          ),
          const Expanded(
            child: BankListingWidget(),
          ),
        ],
      ),
    );
  }
}
