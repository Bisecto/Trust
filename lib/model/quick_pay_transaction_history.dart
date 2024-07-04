import 'dart:convert';

class PaymentReceipt {
  String message;
  Data data;

  PaymentReceipt({
    required this.message,
    required this.data,
  });

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) => PaymentReceipt(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  int amount;
  String type;
  String reference;
  String description;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String customerId;
  String orderId;
  Customer customer;
  Order order;

  Data({
    required this.id,
    required this.amount,
    required this.type,
    required this.reference,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.customerId,
    required this.orderId,
    required this.customer,
    required this.order,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    amount: json["amount"],
    type: json["type"],
    reference: json["reference"],
    description: json["description"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
    customerId: json["customerId"],
    orderId: json["orderId"],
    customer: Customer.fromJson(json["customer"]),
    order: Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "type": type,
    "reference": reference,
    "description": description,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deletedAt": deletedAt,
    "customerId": customerId,
    "orderId": orderId,
    "customer": customer.toJson(),
    "order": order.toJson(),
  };
}

class Customer {
  String id;
  String firstName;
  String lastName;
  String email;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
  };
}

class Order {
  String id;
  String customerId;
  String productId;
  RequiredFields requiredFields;
  Response response;

  Order({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.requiredFields,
    required this.response,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    customerId: json["customerId"],
    productId: json["productId"],
    requiredFields: RequiredFields.fromJson(json["requiredFields"]),
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "productId": productId,
    "requiredFields": requiredFields.toJson(),
    "response": response.toJson(),
  };
}

class RequiredFields {
  String phoneNumber;
  int amount;
  dynamic cardNumber;
  dynamic meterNumber;

  RequiredFields({
    required this.phoneNumber,
    required this.amount,
    this.cardNumber,
    this.meterNumber,
  });

  factory RequiredFields.fromJson(Map<String, dynamic> json) => RequiredFields(
    phoneNumber: json["phoneNumber"],
    amount: json["amount"],
    cardNumber: json["cardNumber"],
    meterNumber: json["meterNumber"],
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "amount": amount,
    "cardNumber": cardNumber,
    "meterNumber": meterNumber,
  };
}

class Response {
  String clientId;
  String serviceCategoryId;
  String reference;
  String status;
  int amount;
  String id;

  Response({
    required this.clientId,
    required this.serviceCategoryId,
    required this.reference,
    required this.status,
    required this.amount,
    required this.id,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    clientId: json["clientId"],
    serviceCategoryId: json["serviceCategoryId"],
    reference: json["reference"],
    status: json["status"],
    amount: json["amount"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "clientId": clientId,
    "serviceCategoryId": serviceCategoryId,
    "reference": reference,
    "status": status,
    "amount": amount,
    "id": id,
  };
}
