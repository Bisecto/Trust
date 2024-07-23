import 'package:equatable/equatable.dart';

class NetworkInternetSuccessEntity extends Equatable {
  final String networkInternetProvider;
  final num networkInternetPercent;

  const NetworkInternetSuccessEntity({
    required this.networkInternetProvider,
    required this.networkInternetPercent,
  });

  @override
  List<Object?> get props => [
        networkInternetProvider,
        networkInternetPercent,
      ];
}
