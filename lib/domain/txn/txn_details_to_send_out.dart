import 'package:equatable/equatable.dart';

class TxnDetailsToSendOut extends Equatable {
  late  String amount;

   TxnDetailsToSendOut({required this.amount});

  @override
  List<Object?> get props => [
        amount,
      ];
}
