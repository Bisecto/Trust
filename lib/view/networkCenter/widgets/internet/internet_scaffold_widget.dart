import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/internet/internet_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class InternetScaffoldWidget extends StatefulWidget {
  const InternetScaffoldWidget({super.key});

  @override
  State<InternetScaffoldWidget> createState() => _InternetScaffoldWidgetState();
}

class _InternetScaffoldWidgetState extends State<InternetScaffoldWidget> {
  final TextEditingController internetSearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: internetSearchController,
            title: 'Internet Success Rate',
            searchFunctionality: (value){
              debugPrint('Internet search value is $value');
            },
          ),
          const Expanded(
            child: InternetListingWidget(),
          ),
        ],
      ),
    );
  }
}
