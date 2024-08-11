import 'package:equatable/equatable.dart';

class SendInternalFundRequest extends Equatable {
  final String receiverId;
  final String narration;
  final num amount;

  const SendInternalFundRequest({
    required this.receiverId,
    required this.narration,
    required this.amount,
  });

  @override
  List<Object?> get props => [
        receiverId,
        narration,
        amount,
      ];

  factory SendInternalFundRequest.fromJson(Map<String, dynamic> json) =>
      SendInternalFundRequest(
        receiverId: json["receiverId"],
        narration: json["narration"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "receiverId": receiverId,
        "narration": narration,
        "amount": amount,
      };
}
