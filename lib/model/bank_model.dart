// To parse this JSON BankModel, do
//
//     final banks = banksFromJson(jsonString);

import 'dart:convert';


class BankModel {
  int totalItems;
  int totalPages;
  int currentPage;
  List<Item> items;

  BankModel({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.items,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  String bankCode;
  String bankName;
  dynamic bankType;

  Item({
    required this.bankCode,
    required this.bankName,
    required this.bankType,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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
