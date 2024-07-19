import 'package:flutter/material.dart';
import 'package:teller_trust/view/networkCenter/widgets/betting/betting_listing_widget.dart';
import 'package:teller_trust/view/networkCenter/widgets/network_center_header_widget.dart';

class BettingScaffoldWidget extends StatefulWidget {
  const BettingScaffoldWidget({super.key});

  @override
  State<BettingScaffoldWidget> createState() => _BettingScaffoldWidgetState();
}

class _BettingScaffoldWidgetState extends State<BettingScaffoldWidget> {
  final TextEditingController bettingSearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkCenterHeaderWidget(
            searchController: bettingSearchController,
            title: 'Betting Success Rate',
            searchFunctionality: (value){
              debugPrint('Betting search value is $value');
            },
          ),
          const Expanded(
            child: BettingListingWidget(),
          ),
        ],
      ),
    );
  }
}
