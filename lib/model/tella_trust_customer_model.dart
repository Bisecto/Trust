class TellaTrustCustomerModel {
  String imageUrl;
  String id;
  String firstName;
  String lastName;
  String middleName;
  String email;
  String phone;

  TellaTrustCustomerModel({
    required this.imageUrl,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.phone,
  });

  factory TellaTrustCustomerModel.fromJson(Map<String, dynamic> json) => TellaTrustCustomerModel(
    imageUrl: json["imageUrl"]??'',
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    middleName: json["middleName"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "middleName": middleName,
    "email": email,
    "phone": phone,
  };
}
