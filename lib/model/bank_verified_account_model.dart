class BankVerifiedAccountModel {
  String accountName;
  String accountNumber;
  String sessionId;
  String bankCode;

  BankVerifiedAccountModel({
    required this.accountName,
    required this.accountNumber,
    required this.sessionId,
    required this.bankCode,
  });

  factory BankVerifiedAccountModel.fromJson(Map<String, dynamic> json) =>
      BankVerifiedAccountModel(
        accountName: json["accountName"],
        accountNumber: json["accountNumber"],
        sessionId: json["sessionId"],
        bankCode: json["bankCode"],
      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "accountNumber": accountNumber,
        "sessionId": sessionId,
        "bankCode": bankCode,
      };
}
