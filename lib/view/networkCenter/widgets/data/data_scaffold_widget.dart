import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/data/data_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class DataScaffoldWidget extends StatefulWidget {
  const DataScaffoldWidget({super.key});

  @override
  State<DataScaffoldWidget> createState() => _DataScaffoldWidgetState();
}

class _DataScaffoldWidgetState extends State<DataScaffoldWidget> {
  final TextEditingController dataSearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: dataSearchController,
            title: 'Data Success Rate',
            searchFunctionality: (value){
              debugPrint('Data search value is $value');
            },
          ),
          const Expanded(
            child: DataListingWidget(),
          ),
        ],
      ),
    );
  }
}
