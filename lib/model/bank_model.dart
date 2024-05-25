// To parse this JSON BankModel, do
//
//     final banks = banksFromJson(jsonString);

import 'dart:convert';


class BankModel {
  int totalItems;
  int totalPages;
  int currentPage;
  List<Bank> banks;

  BankModel({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.banks,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    banks: List<Bank>.from(json["items"].map((x) => Bank.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(banks.map((x) => x.toJson())),
  };
}

class Bank {
  String bankCode;
  String bankName;
  dynamic bankType;

  Bank({
    required this.bankCode,
    required this.bankName,
    required this.bankType,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    bankCode: json["bankCode"],
    bankName: json["bankName"],
    bankType: json["bankType"],
  );

  Map<String, dynamic> toJson() => {
    "bankCode": bankCode,
    "bankName": bankName,
    "bankType": bankType,
  };
}
