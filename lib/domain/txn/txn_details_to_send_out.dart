import 'package:equatable/equatable.dart';

class TxnDetailsToSendOut extends Equatable {
  final String amount;

  const TxnDetailsToSendOut({required this.amount});

  @override
  List<Object?> get props => [
        amount,
      ];
}
