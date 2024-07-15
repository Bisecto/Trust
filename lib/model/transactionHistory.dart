import 'dart:convert';

class TransactionHistoryModel {
  String message;
  Data data;

  TransactionHistoryModel({
    required this.message,
    required this.data,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
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
  List<Transaction> items;

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
    items: List<Transaction>.from(
        json["items"].map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Transaction {
  final String id;
  final int amount;
  final String description;
  final String type;
  final String reference;
  final String status;
  final DateTime createdAt;
  final Order? order;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.type,
    required this.reference,
    required this.status,
    required this.createdAt,
    this.order,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      type: json['type'],
      reference: json['reference'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'type': type,
      'reference': reference,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'order': order?.toJson(),
    };
  }
}

class Order {
  final String id;
  final String status;
  final String? providerOrderId;
  final RequiredFields requiredFields;
  final Response? response;
  final Product product;

  Order({
    required this.id,
    required this.status,
    this.providerOrderId,
    required this.requiredFields,
    this.response,
    required this.product,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      providerOrderId: json['providerOrderId'],
      requiredFields: RequiredFields.fromJson(json['requiredFields']),
      response:
      json['response'] != null ? Response.fromJson(json['response']) : null,
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'providerOrderId': providerOrderId,
      'requiredFields': requiredFields.toJson(),
      'response': response?.toJson(),
      'product': product.toJson(),
    };
  }
}

class RequiredFields {
  final String? phoneNumber;
  final int amount;
  final String? cardNumber;
  final String? meterNumber;

  RequiredFields({
    required this.phoneNumber,
    required this.amount,
    this.cardNumber,
    this.meterNumber,
  });

  factory RequiredFields.fromJson(Map<String, dynamic> json) {
    return RequiredFields(
      phoneNumber: json['phoneNumber'],
      amount: json['amount'],
      cardNumber: json['cardNumber'],
      meterNumber: json['meterNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'amount': amount,
      'cardNumber': cardNumber,
      'meterNumber': meterNumber,
    };
  }
}

class Response {
  final String clientId;
  final String serviceCategoryId;
  final String reference;
  final String status;
  final int amount;
  final String utilityToken;
  final String id;

  Response({
    required this.clientId,
    required this.serviceCategoryId,
    required this.reference,
    required this.status,
    required this.amount,
    required this.utilityToken,
    required this.id,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      clientId: json['clientId'],
      serviceCategoryId: json['serviceCategoryId'],
      reference: json['reference'],
      status: json['status'],
      amount: json['amount'],
      utilityToken: json['utilityToken']??'',
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'serviceCategoryId': serviceCategoryId,
      'reference': reference,
      'status': status,
      'amount': amount,
      'utilityToken': utilityToken,
      'id': id,
    };
  }
}

class Product {
  final String image;
  final String id;
  final String name;
  final String description;

  Product({
    required this.image,
    required this.id,
    required this.name,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
