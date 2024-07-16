class RequiredFields {
  String? phoneNumber;
  String? amount;
  String? cardNumber;
  String? meterNumber;

  RequiredFields({
    required this.phoneNumber,
    this.amount,
    this.cardNumber,
    this.meterNumber,
  });

  factory RequiredFields.fromJson(Map<String, dynamic> json) => RequiredFields(
        phoneNumber: json["phoneNumber"],
        amount: json["amount"].toString(),
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
