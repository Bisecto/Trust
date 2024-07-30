import 'package:equatable/equatable.dart';

class VerifyReceiptentAccountRequest extends Equatable {
  final String bankCode;
  final String accountNumber;

  const VerifyReceiptentAccountRequest({
    required this.bankCode,
    required this.accountNumber,
  });

  @override
  List<Object?> get props => [
        bankCode,
        accountNumber,
      ];

  factory VerifyReceiptentAccountRequest.fromJson(Map<String, dynamic> json) =>
      VerifyReceiptentAccountRequest(
        bankCode: json["bankCode"],
        accountNumber: json["accountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "bankCode": bankCode,
        "accountNumber": accountNumber,
      };
}
