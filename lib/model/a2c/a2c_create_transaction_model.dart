class A2CCreateTransactionModel {
  String id;
  String status;
  String customerId;
  String orderId;
  int amount;
  String type;
  String description;
  String reference;
  DateTime updatedAt;
  DateTime createdAt;
  //dynamic deletedAt;

  A2CCreateTransactionModel({
    required this.id,
    required this.status,
    required this.customerId,
    required this.orderId,
    required this.amount,
    required this.type,
    required this.description,
    required this.reference,
    required this.updatedAt,
    required this.createdAt,
    //required this.deletedAt,
  });

  factory A2CCreateTransactionModel.fromJson(Map<String, dynamic> json) => A2CCreateTransactionModel(
    id: json["id"],
    status: json["status"],
    customerId: json["customerId"],
    orderId: json["orderId"],
    amount: json["amount"],
    type: json["type"],
    description: json["description"],
    reference: json["reference"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    //deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "customerId": customerId,
    "orderId": orderId,
    "amount": amount,
    "type": type,
    "description": description,
    "reference": reference,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    //"deletedAt": deletedAt,
  };
}
