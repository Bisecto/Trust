// To parse this JSON data, do
//
//     final TransactionHistoryModel = TransactionHistoryModelFromJson(jsonString);

import 'dart:convert';

import 'category_model.dart';


class TransactionHistoryModel {
  String message;
  Data data;

  TransactionHistoryModel({
    required this.message,
    required this.data,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) => TransactionHistoryModel(
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
  List<Item> items;

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
  String id;
  int amount;
  String description;
  String type;
  String reference;
  String status;
  DateTime createdAt;
  Order order;

  Item({
    required this.id,
    required this.amount,
    required this.description,
    required this.type,
    required this.reference,
    required this.status,
    required this.createdAt,
    required this.order,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    amount: json["amount"],
    description: json["description"],
    type: json["type"],
    reference: json["reference"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    order: Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "description": description,
    "type": type,
    "reference": reference,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "order": order.toJson(),
  };
}

class Order {
  String id;
  String status;
  dynamic providerOrderId;
  RequiredFields requiredFields;
  Product product;

  Order({
    required this.id,
    required this.status,
    required this.providerOrderId,
    required this.requiredFields,
    required this.product,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    status: json["status"]??'',
    providerOrderId: json["providerOrderId"],
    requiredFields: RequiredFields.fromJson(json["requiredFields"]),
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "providerOrderId": providerOrderId,
    "requiredFields": requiredFields.toJson(),
    "product": product.toJson(),
  };
}

class Product {
  String image;
  String id;
  String name;
  String description;

  Product({
    required this.image,
    required this.id,
    required this.name,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    image: json["image"],
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "id": id,
    "name": name,
    "description": description,
  };
}

