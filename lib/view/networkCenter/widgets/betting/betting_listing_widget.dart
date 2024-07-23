import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_betting_success_rate_entity.dart';
import 'package:teller_trust/view/networkCenter/widgets/betting/custom_betting_item.dart';

class BettingListingWidget extends StatefulWidget {
  const BettingListingWidget({super.key});

  @override
  State<BettingListingWidget> createState() => _BettingListingWidgetState();
}

class _BettingListingWidgetState extends State<BettingListingWidget> {
  List<NetworkBettingSuccessRateEntity> bettingListing = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: bettingListing.length,
      itemBuilder: (context, index) {
        NetworkBettingSuccessRateEntity bettingSuccessRateEntity = bettingListing[index];
        return CustomBettingItem(
          bettingItemName: bettingSuccessRateEntity.networkBettingProvider,
          navigationFunctionality: () {},
          progressPercent: bettingSuccessRateEntity.networkBettingPercent.toDouble(),
        );
      },
    );
  }
}
