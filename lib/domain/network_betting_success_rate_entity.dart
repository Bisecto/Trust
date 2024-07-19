import 'package:equatable/equatable.dart';

class NetworkBettingSuccessRateEntity extends Equatable {
  final String networkBettingProvider;
  final num networkBettingPercent;

  const NetworkBettingSuccessRateEntity({
    required this.networkBettingProvider,
    required this.networkBettingPercent,
  });

  @override
  List<Object?> get props => [
        networkBettingProvider,
        networkBettingPercent,
      ];
}
