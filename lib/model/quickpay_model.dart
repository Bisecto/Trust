// To parse this JSON data, do
//
//     final quickPayModel = quickPayModelFromJson(jsonString);

import 'dart:convert';

QuickPayModel quickPayModelFromJson(String str) => QuickPayModel.fromJson(json.decode(str));

String quickPayModelToJson(QuickPayModel data) => json.encode(data.toJson());

class QuickPayModel {
  String environment;
  String clientId;
  String referenceCode;
  Customer customer;
  String currency;
  int amount;
  SettlementAccount settlementAccount;
  String webhookUrl;

  QuickPayModel({
    required this.environment,
    required this.clientId,
    required this.referenceCode,
    required this.customer,
    required this.currency,
    required this.amount,
    required this.settlementAccount,
    required this.webhookUrl,
  });

  factory QuickPayModel.fromJson(Map<String, dynamic> json) => QuickPayModel(
    environment: json["environment"],
    clientId: json["clientId"],
    referenceCode: json["referenceCode"],
    customer: Customer.fromJson(json["customer"]),
    currency: json["currency"],
    amount: json["amount"],
    settlementAccount: SettlementAccount.fromJson(json["settlementAccount"]),
    webhookUrl: json["webhookUrl"],
  );

  Map<String, dynamic> toJson() => {
    "environment": environment,
    "clientId": clientId,
    "referenceCode": referenceCode,
    "customer": customer.toJson(),
    "currency": currency,
    "amount": amount,
    "settlementAccount": settlementAccount.toJson(),
    "webhookUrl": webhookUrl,
  };
}

class Customer {
  String firstName;
  String lastName;
  String emailAddress;
  String phoneNumber;

  Customer({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    firstName: json["firstName"],
    lastName: json["lastName"],
    emailAddress: json["emailAddress"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "emailAddress": emailAddress,
    "phoneNumber": phoneNumber,
  };
}

class SettlementAccount {
  String accountNumber;

  SettlementAccount({
    required this.accountNumber,
  });

  factory SettlementAccount.fromJson(Map<String, dynamic> json) => SettlementAccount(
    accountNumber: json["accountNumber"],
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber,
  };
}
