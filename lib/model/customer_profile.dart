// To parse this JSON data, do
//
//     final customerProfile = customerProfileFromJson(jsonString);

import 'dart:convert';

import 'package:teller_trust/model/personal_profile.dart';
import 'package:teller_trust/model/wallet_info.dart';

import 'customer_account_model.dart';

CustomerProfile customerProfileFromJson(String str) => CustomerProfile.fromJson(json.decode(str));

String customerProfileToJson(CustomerProfile data) => json.encode(data.toJson());

class CustomerProfile {
  PersonalInfo personalInfo;
  WalletInfo walletInfo;
  CustomerAccountModel? customerAccount;

  CustomerProfile({
    required this.personalInfo,
    required this.walletInfo,
    required this.customerAccount,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) => CustomerProfile(
    personalInfo: PersonalInfo.fromJson(json["personalInfo"]),
    walletInfo: WalletInfo.fromJson(json["walletInfo"]),
    customerAccount: json['customerAccount'] != null
        ? CustomerAccountModel.fromJson(json['customerAccount'])
        : null,  );

  Map<String, dynamic> toJson() => {
    "personalInfo": personalInfo.toJson(),
    "walletInfo": walletInfo.toJson(),
    "customerAccount": customerAccount?.toJson(),
  };
}


