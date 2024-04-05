// To parse this JSON data, do
//
//     final customerProfile = customerProfileFromJson(jsonString);

import 'dart:convert';

import 'package:teller_trust/model/personal_profile.dart';
import 'package:teller_trust/model/wallet_info.dart';

CustomerProfile customerProfileFromJson(String str) => CustomerProfile.fromJson(json.decode(str));

String customerProfileToJson(CustomerProfile data) => json.encode(data.toJson());

class CustomerProfile {
  PersonalInfo personalInfo;
  WalletInfo walletInfo;
  dynamic customerAccount;

  CustomerProfile({
    required this.personalInfo,
    required this.walletInfo,
    required this.customerAccount,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) => CustomerProfile(
    personalInfo: PersonalInfo.fromJson(json["personalInfo"]),
    walletInfo: WalletInfo.fromJson(json["walletInfo"]),
    customerAccount: json["customerAccount"],
  );

  Map<String, dynamic> toJson() => {
    "personalInfo": personalInfo.toJson(),
    "walletInfo": walletInfo.toJson(),
    "customerAccount": customerAccount,
  };
}


