import 'package:equatable/equatable.dart';

class NetworkBankSuccessRateEntity extends Equatable {
  final String networkBankProvider;
  final num networkBankPercent;

  const NetworkBankSuccessRateEntity({
    required this.networkBankProvider,
    required this.networkBankPercent,
  });

  @override
  List<Object?> get props => [
        networkBankProvider,
        networkBankPercent,
      ];
}
