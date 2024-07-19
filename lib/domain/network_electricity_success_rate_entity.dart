import 'package:equatable/equatable.dart';

class NetworkElectricitySuccessRateEntity extends Equatable {
  final String networkElectricityProvider;
  final num networkElectricityPercent;

  const NetworkElectricitySuccessRateEntity({
    required this.networkElectricityProvider,
    required this.networkElectricityPercent,
  });

  @override
  List<Object?> get props => [
        networkElectricityProvider,
        networkElectricityPercent,
      ];
}
