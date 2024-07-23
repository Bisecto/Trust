import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_airtime_success_rate_entity.dart';
import 'package:teller_trust/view/networkCenter/widgets/airtime/custom_airtime_item.dart';

class AirtimeListingWidget extends StatefulWidget {
  const AirtimeListingWidget({super.key});

  @override
  State<AirtimeListingWidget> createState() => _AirtimeListingWidgetState();
}

class _AirtimeListingWidgetState extends State<AirtimeListingWidget> {
  List<NetworkAirtimeSuccessRateEntity> airtimeList = const [
    NetworkAirtimeSuccessRateEntity(
      networkAirtimePercent: 20,
      networkAirtimeProvider: 'Airtel',
    ),
    NetworkAirtimeSuccessRateEntity(
      networkAirtimePercent: 20,
      networkAirtimeProvider: 'MTN',
    ),
    NetworkAirtimeSuccessRateEntity(
      networkAirtimePercent: 20,
      networkAirtimeProvider: 'GLO',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: airtimeList.length,
      itemBuilder: (context, index) {
        NetworkAirtimeSuccessRateEntity airtimeSuccessRateEntity =
            airtimeList[index];
        return CustomAirtimeItem(
          airtimeItemName: airtimeSuccessRateEntity.networkAirtimeProvider,
          navigationFunctionality: () {},
          progressPercent:
              airtimeSuccessRateEntity.networkAirtimePercent.toDouble(),
        );
      },
    );
  }
}
