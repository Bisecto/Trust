import 'package:equatable/equatable.dart';

class NetworkCableSuccessRateEntity extends Equatable {
  final String networkCableProvider;
  final num networkCablePercent;

  const NetworkCableSuccessRateEntity({
    required this.networkCableProvider,
    required this.networkCablePercent,
  });

  @override
  List<Object?> get props => [
        networkCableProvider,
        networkCablePercent,
      ];
}
