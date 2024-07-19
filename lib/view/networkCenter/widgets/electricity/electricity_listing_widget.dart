import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_electricity_success_rate_entity.dart';
import 'package:teller_trust/view/networkCenter/widgets/electricity/custom_electricity_item.dart';

class ElectricityListingWidget extends StatefulWidget {
  const ElectricityListingWidget({super.key});

  @override
  State<ElectricityListingWidget> createState() => _ElectricityListingWidgetState();
}

class _ElectricityListingWidgetState extends State<ElectricityListingWidget> {
  List<NetworkElectricitySuccessRateEntity> electricityListing = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: electricityListing.length,
      itemBuilder: (context, index) {
        NetworkElectricitySuccessRateEntity electricitySuccessRateEntity = electricityListing[index];
        return CustomElectricityItem(
          electricityItemName: electricitySuccessRateEntity.networkElectricityProvider,
          navigationFunctionality: () {},
          progressPercent: electricitySuccessRateEntity.networkElectricityPercent.toDouble(),
        );
      },
    );
  }
}
