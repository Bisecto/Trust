import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_internet_success_entity.dart';
import 'package:teller_trust/view/networkCenter/widgets/internet/custom_internet_item.dart';

class InternetListingWidget extends StatefulWidget {
  const InternetListingWidget({super.key});

  @override
  State<InternetListingWidget> createState() => _InternetListingWidgetState();
}

class _InternetListingWidgetState extends State<InternetListingWidget> {
  List<NetworkInternetSuccessEntity> internetListing = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: internetListing.length,
      itemBuilder: (context, index) {
        NetworkInternetSuccessEntity electricitySuccessRateEntity = internetListing[index];
        return CustomInternetItem(
          internetItemName: electricitySuccessRateEntity.networkInternetProvider,
          navigationFunctionality: () {},
          progressPercent: electricitySuccessRateEntity.networkInternetPercent.toDouble(),
        );
      },
    );
  }
}
