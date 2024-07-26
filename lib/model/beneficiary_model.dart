
import 'package:teller_trust/model/required_field_model.dart';

class BeneficiaryModel {
  int totalItems;
  int totalPages;
  int currentPage;
  List<Item> items;

  BeneficiaryModel({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.items,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) => BeneficiaryModel(
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
  String fullName;
  RequiredFields requiredFields;
  Product product;

  Item({
    required this.id,
    required this.fullName,
    required this.requiredFields,
    required this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    fullName: json["fullName"],
    requiredFields: RequiredFields.fromJson(json["requiredFields"]),
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "requiredFields": requiredFields.toJson(),
    "product": product.toJson(),
  };
}

class Product {
  String image;
  String id;
  String name;
  String description;
  int buyerPrice;

  Product({
    required this.image,
    required this.id,
    required this.name,
    required this.description,
    required this.buyerPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    image: json["image"],
    id: json["id"],
    name: json["name"],
    description: json["description"],
    buyerPrice: json["buyerPrice"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "id": id,
    "name": name,
    "description": description,
    "buyerPrice": buyerPrice,
  };
}

