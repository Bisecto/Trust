import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/airtime/airtime_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class AirtimeScaffoldWidget extends StatefulWidget {
  const AirtimeScaffoldWidget({super.key});

  @override
  State<AirtimeScaffoldWidget> createState() => _AirtimeScaffoldWidgetState();
}

class _AirtimeScaffoldWidgetState extends State<AirtimeScaffoldWidget> {
  final TextEditingController airtimeSearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: airtimeSearchController,
            title: 'Network',
            searchFunctionality: (value){
              debugPrint('Network search value is $value');
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const AirtimeListingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
