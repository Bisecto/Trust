// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);


class ServiceModel {
  String message;
  Data data;

  ServiceModel({
    required this.message,
    required this.data,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
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
  List<Service> services;

  Data({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.services,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    services: List<Service>.from(json["items"].map((x) => Service.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  String image;
  String id;
  String name;
  String slug;
  Category category;


  Service({
    required this.image,
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    image: json["image"]??'',
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "id": id,
    "name": name,
    "slug": slug,
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
