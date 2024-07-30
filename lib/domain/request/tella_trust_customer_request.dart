import 'package:equatable/equatable.dart';

class TellaTrustCustomerRequest extends Equatable {
  final String userData;

  const TellaTrustCustomerRequest({
    required this.userData,
  });

  @override
  List<Object?> get props => [
        userData,
      ];

  factory TellaTrustCustomerRequest.fromJson(Map<String, dynamic> json) =>
      TellaTrustCustomerRequest(
        userData: json["userData"],
      );

  Map<String, dynamic> toJson() => {"userData": userData};
}
