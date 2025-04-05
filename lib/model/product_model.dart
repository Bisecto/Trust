// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String message;
  Data data;

  ProductModel({
    required this.message,
    required this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
  String image;
  String id;
  String name;
  double buyerPrice;
  dynamic sellerCost;
  String reference;
  Service service;
  Category category;

  Item({
    required this.image,
    required this.id,
    required this.name,
    required this.buyerPrice,
     this.sellerCost,
    required this.reference,
    required this.service,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    image: json["image"],
    id: json["id"],
    name: json["name"],
    buyerPrice: double.parse(json["buyerPrice"].toString())??0.0,
    sellerCost:json["sellerCost"]??0.0,
    reference: json["reference"],
    service: Service.fromJson(json["service"]),
    category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "id": id,
    "name": name,
    "buyerPrice": buyerPrice,
    "sellerCost": sellerCost,
    "reference": reference,
    "service": service.toJson(),
    "category": category.toJson(),
  };
}

class Category {
  String id;
  String name;
  String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
  };
}


class Service {
  String id;
  String name;

  Service({
    required this.id,
    required this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
