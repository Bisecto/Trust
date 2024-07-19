import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/cable/cable_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class CableScaffoldWidget extends StatefulWidget {
  const CableScaffoldWidget({super.key});

  @override
  State<CableScaffoldWidget> createState() => _AirtimeScaffoldWidgetState();
}

class _AirtimeScaffoldWidgetState extends State<CableScaffoldWidget> {
  final TextEditingController cableSearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: cableSearchController,
            title: 'Cable TV Success Rate',
            searchFunctionality: (value){
              debugPrint('Cable search value is $value');
            },
          ),
          const Expanded(
            child: CableListingWidget(),
          ),
        ],
      ),
    );
  }
}
