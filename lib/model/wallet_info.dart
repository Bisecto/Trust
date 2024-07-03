class WalletInfo {
  String id;
  double balance;
  int points;
  DateTime createdAt;
  String customerId;

  WalletInfo({
    required this.id,
    required this.balance,
    required this.points,
    required this.createdAt,
    required this.customerId,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) => WalletInfo(
    id: json["id"],
    balance: double.parse(json["balance"].toString()),
    points: json["points"],
    createdAt: DateTime.parse(json["createdAt"]),
    customerId: json["customerId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "balance": balance,
    "points": points,
    "createdAt": createdAt.toIso8601String(),
    "customerId": customerId,
  };
}
