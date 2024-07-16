
import 'package:teller_trust/model/quick_pay_transaction_history.dart';
import 'package:teller_trust/model/required_field_model.dart';

class CategoryModel {
  String message;
  Data data;

  CategoryModel({
    required this.message,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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
  List<Category> categories;

  Data({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.categories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    categories: List<Category>.from(json["items"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  String image;
  String id;
  String name;
  String slug;
  RequiredFields requiredFields;

  Category({
    required this.image,
    required this.id,
    required this.name,
    required this.slug,
    required this.requiredFields,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    image: json["image"],
    id: json["id"],
    name: json["name"],
    slug: json["slug"]??'',
   requiredFields: RequiredFields.fromJson(json["requiredFields"]),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "id": id,
    "name": name,
    "slug": slug,
    "requiredFields": requiredFields.toJson(),
  };
}

