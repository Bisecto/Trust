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
  String slug;
  RequiredFields requiredFields;

  Item({
    required this.image,
    required this.id,
    required this.name,
    required this.slug,
    required this.requiredFields,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        image: json["image"],
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
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

class RequiredFields {
  String phone;
  String? amount;
  String? cardNumber;
  String? meterNumber;

  RequiredFields({
    required this.phone,
    this.amount,
    this.cardNumber,
    this.meterNumber,
  });

  factory RequiredFields.fromJson(Map<String, dynamic> json) => RequiredFields(
        phone: json["phone"],
        amount: json["amount"],
        cardNumber: json["cardNumber"],
        meterNumber: json["meterNumber"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "amount": amount,
        "cardNumber": cardNumber,
        "meterNumber": meterNumber,
      };
}
