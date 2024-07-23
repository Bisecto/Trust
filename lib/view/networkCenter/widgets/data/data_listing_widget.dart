import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_data_success_rate_entity.dart';
import 'package:teller_trust/view/networkCenter/widgets/data/custom_data_item.dart';

class DataListingWidget extends StatefulWidget {
  const DataListingWidget({super.key});

  @override
  State<DataListingWidget> createState() => _DataListingWidgetState();
}

class _DataListingWidgetState extends State<DataListingWidget> {
  List<NetworkDataSuccessRateEntity> dataListing = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: dataListing.length,
      itemBuilder: (context, index) {
        NetworkDataSuccessRateEntity dataSuccessRateEntity = dataListing[index];
        return CustomDataItem(
          dataItemName: dataSuccessRateEntity.networkDataProvider,
          navigationFunctionality: () {},
          progressPercent: dataSuccessRateEntity.networkDataPercent.toDouble(),
        );
      },
    );
  }
}
