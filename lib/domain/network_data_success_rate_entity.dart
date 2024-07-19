import 'package:equatable/equatable.dart';

class NetworkDataSuccessRateEntity extends Equatable {
  final String networkDataProvider;
  final num networkDataPercent;

  const NetworkDataSuccessRateEntity({
    required this.networkDataProvider,
    required this.networkDataPercent,
  });

  @override
  List<Object?> get props => [
        networkDataProvider,
        networkDataPercent,
      ];
}
