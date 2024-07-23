import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/networkCenterMain/network_center_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class NetworkCenterScaffoldWidget extends StatefulWidget {
  const NetworkCenterScaffoldWidget({super.key});

  @override
  State<NetworkCenterScaffoldWidget> createState() =>
      _NetworkCenterScaffoldWidgetState();
}

class _NetworkCenterScaffoldWidgetState
    extends State<NetworkCenterScaffoldWidget> {
  final TextEditingController networkCenterSearchController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: networkCenterSearchController,
            title: 'Network',
            searchFunctionality: (value){
              debugPrint('The value is $value');
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const NetworkCenterListingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
