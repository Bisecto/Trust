// To parse this JSON data, do
//
//     final walletHistoryModel = walletHistoryModelFromJson(jsonString);

import 'dart:convert';

WalletHistoryModel walletHistoryModelFromJson(String str) => WalletHistoryModel.fromJson(json.decode(str));

String walletHistoryModelToJson(WalletHistoryModel data) => json.encode(data.toJson());

class WalletHistoryModel {
  String message;
  Data data;

  WalletHistoryModel({
    required this.message,
    required this.data,
  });

  factory WalletHistoryModel.fromJson(Map<String, dynamic> json) => WalletHistoryModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int totalItems;
  int totalPages;
  int currentPage;
  List<Wallet> items;

  Data({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    items: List<Wallet>.from(json["items"].map((x) => Wallet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Wallet {
  String id;
  int amountBefore;
  int amount;
  int amountAfter;
  DateTime createdAt;
  String walletId;
  String transactionId;
  Transaction transaction;

  Wallet({
    required this.id,
    required this.amountBefore,
    required this.amount,
    required this.amountAfter,
    required this.createdAt,
    required this.walletId,
    required this.transactionId,
    required this.transaction,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    amountBefore: json["amountBefore"],
    amount: json["amount"],
    amountAfter: json["amountAfter"],
    createdAt: DateTime.parse(json["createdAt"]),
    walletId: json["walletId"],
    transactionId: json["transactionId"],
    transaction: Transaction.fromJson(json["transaction"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amountBefore": amountBefore,
    "amount": amount,
    "amountAfter": amountAfter,
    "createdAt": createdAt.toIso8601String(),
    "walletId": walletId,
    "transactionId": transactionId,
    "transaction": transaction.toJson(),
  };
}

class Transaction {
  String id;
  int amount;
  String type;
  String description;
  String status;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    amount: json["amount"],
    type: json["type"],
    description: json["description"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "type": type,
    "description": description,
    "status": status,
  };
}
