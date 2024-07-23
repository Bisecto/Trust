import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_cable_success_rate_entity.dart';
import 'package:teller_trust/view/networkCenter/widgets/cable/custom_cable_item.dart';

class CableListingWidget extends StatefulWidget {
  const CableListingWidget({super.key});

  @override
  State<CableListingWidget> createState() => _CableListingWidgetState();
}

class _CableListingWidgetState extends State<CableListingWidget> {
  List<NetworkCableSuccessRateEntity> cableListing = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: cableListing.length,
      itemBuilder: (context, index) {
        NetworkCableSuccessRateEntity cableSuccessRateEntity = cableListing[index];
        return CustomCableItem(
          cableItemName: cableSuccessRateEntity.networkCableProvider,
          navigationFunctionality: () {},
          progressPercent: cableSuccessRateEntity.networkCablePercent.toDouble(),
        );
      },
    );
  }
}
