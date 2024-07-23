import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_bank_success_rate_entity.dart';
import 'package:teller_trust/view/networkCenter/widgets/airtime/custom_airtime_item.dart';

class BankListingWidget extends StatefulWidget {
  const BankListingWidget({super.key});

  @override
  State<BankListingWidget> createState() => _BankListingWidgetState();
}

class _BankListingWidgetState extends State<BankListingWidget> {
  List<NetworkBankSuccessRateEntity> bankListing = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: bankListing.length,
      itemBuilder: (context, index) {
        NetworkBankSuccessRateEntity bankSuccessRateEntity = bankListing[index];
        return CustomAirtimeItem(
          airtimeItemName: bankSuccessRateEntity.networkBankProvider,
          navigationFunctionality: () {},
          progressPercent: bankSuccessRateEntity.networkBankPercent.toDouble(),
        );
      },
    );
  }
}
