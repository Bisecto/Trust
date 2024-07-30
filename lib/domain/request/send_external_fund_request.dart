import 'package:equatable/equatable.dart';

class SendExternalFundRequest extends Equatable {
  final String bankCode;
  final String accountNumber;
  final String sessionId;
  final String narration;
  final num amount;

  const SendExternalFundRequest({
    required this.bankCode,
    required this.accountNumber,
    required this.sessionId,
    required this.narration,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        bankCode,
        accountNumber,
        sessionId,
        narration,
        amount,
      ];

  factory SendExternalFundRequest.fromJson(Map<String, dynamic> json) =>
      SendExternalFundRequest(
        bankCode: json["bankCode"],
        accountNumber: json["accountNumber"],
        sessionId: json["sessionId"],
        narration: json["narration"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "bankCode": bankCode,
        "accountNumber": accountNumber,
        "sessionId": sessionId,
        "narration": narration,
        "amount": amount,
      };
}
