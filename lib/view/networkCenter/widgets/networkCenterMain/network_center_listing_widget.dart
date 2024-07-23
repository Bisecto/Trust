import 'package:flutter/material.dart';
import 'package:teller_trust/domain/network_center_entity.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/networkCenter/pages/airtime_purchase_page.dart';
import 'package:teller_trust/view/networkCenter/pages/bank_page.dart';
import 'package:teller_trust/view/networkCenter/pages/betting_page.dart';
import 'package:teller_trust/view/networkCenter/pages/cable_page.dart';
import 'package:teller_trust/view/networkCenter/pages/data_purchase_page.dart';
import 'package:teller_trust/view/networkCenter/pages/electricity_page.dart';
import 'package:teller_trust/view/networkCenter/pages/internet_page.dart';
import 'package:teller_trust/view/networkCenter/widgets/networkCenterMain/custom_network_center_item.dart';

class NetworkCenterListingWidget extends StatefulWidget {
  const NetworkCenterListingWidget({super.key});

  @override
  State<NetworkCenterListingWidget> createState() =>
      _NetworkCenterListingWidgetState();
}

class _NetworkCenterListingWidgetState
    extends State<NetworkCenterListingWidget> {
  List<NetworkCenterEntity> networkCenterListing = [
    NetworkCenterEntity(
      imagePath: 'assets/icons/networkCenter/airtime.svg',
      title: 'Airtime Purchase',
      navCallBack: (context) {
        AppNavigator.pushAndStackPage(context,
            page: const AirtimePurchasePage());
      },
    ),
    NetworkCenterEntity(
      imagePath: 'assets/icons/networkCenter/betting.svg',
      title: 'Betting',
      navCallBack: (context) {
        AppNavigator.pushAndStackPage(context, page: const BettingPage());
      },
    ),
    NetworkCenterEntity(
      imagePath: 'assets/icons/networkCenter/bank.svg',
      title: 'Bank Transfer',
      navCallBack: (context) {
        AppNavigator.pushAndStackPage(context, page: const BankPage());
      },
    ),
    NetworkCenterEntity(
      imagePath: 'assets/icons/networkCenter/cable.svg',
      title: 'CableTv',
      navCallBack: (context) {
        AppNavigator.pushAndStackPage(context, page: const CablePage());
      },
    ),
    NetworkCenterEntity(
      imagePath: 'assets/icons/networkCenter/dataTopUp.svg',
      title: 'Data Top-up',
      navCallBack: (context) {
        AppNavigator.pushAndStackPage(context, page: const DataPurchasePage());
      },
    ),
    NetworkCenterEntity(
      imagePath: 'assets/icons/networkCenter/electricity.svg',
      title: 'Electricity',
      navCallBack: (context) {
        AppNavigator.pushAndStackPage(context, page: const ElectricityPage());
      },
    ),
    NetworkCenterEntity(
      imagePath: 'assets/icons/networkCenter/internet.svg',
      title: 'Internet',
      navCallBack: (context) {
        AppNavigator.pushAndStackPage(context, page: const InternetPage());
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: networkCenterListing.length,
      itemBuilder: (context, index) {
        NetworkCenterEntity networkCenterEntity = networkCenterListing[index];
        return CustomNetworkCenterItem(
          imagePath: networkCenterEntity.imagePath,
          itemName: networkCenterEntity.title,
          navigationCallback: () => networkCenterEntity.navCallBack(context),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
