import 'package:equatable/equatable.dart';

class NetworkAirtimeSuccessRateEntity extends Equatable {
  final String networkAirtimeProvider;
  final num networkAirtimePercent;

  const NetworkAirtimeSuccessRateEntity({
    required this.networkAirtimeProvider,
    required this.networkAirtimePercent,
  });

  @override
  List<Object?> get props => [
        networkAirtimeProvider,
        networkAirtimePercent,
      ];
}
