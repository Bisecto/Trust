import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/electricity/electricity_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class ElectricityScaffoldWidget extends StatefulWidget {
  const ElectricityScaffoldWidget({super.key});

  @override
  State<ElectricityScaffoldWidget> createState() => _ElectricityScaffoldWidgetState();
}

class _ElectricityScaffoldWidgetState extends State<ElectricityScaffoldWidget> {
  final TextEditingController electricitySearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: electricitySearchController,
            title: 'Electricity Success Rate',
            searchFunctionality: (value){
              debugPrint('Electricity search value is $value');
            },
          ),
          const Expanded(
            child: ElectricityListingWidget(),
          ),
        ],
      ),
    );
  }
}
