// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String image;
  String id;
  String name;
  String description;
  int buyerPrice;
  String reference;
  Service service;
  Category category;

  ProductModel({
    required this.image,
    required this.id,
    required this.name,
    required this.description,
    required this.buyerPrice,
    required this.reference,
    required this.service,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    image: json["image"],
    id: json["id"],
    name: json["name"],
    description: json["description"],
    buyerPrice: json["buyerPrice"],
    reference: json["reference"],
    service: Service.fromJson(json["service"]),
    category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "id": id,
    "name": name,
    "description": description,
    "buyerPrice": buyerPrice,
    "reference": reference,
    "service": service.toJson(),
    "category": category.toJson(),
  };
}

class Category {
  String id;
  String name;
  String slug;
  RequiredFields requiredFields;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.requiredFields,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    requiredFields: RequiredFields.fromJson(json["requiredFields"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "requiredFields": requiredFields.toJson(),
  };
}

class RequiredFields {
  String phone;
  String amount;

  RequiredFields({
    required this.phone,
    required this.amount,
  });

  factory RequiredFields.fromJson(Map<String, dynamic> json) => RequiredFields(
    phone: json["phone"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "amount": amount,
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
