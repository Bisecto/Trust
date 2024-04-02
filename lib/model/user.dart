// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);


class User {
  String firstName;
  String middleName;
  String lastName;
  String email;
  String phone;
  String userId;
  dynamic emailVerified;
  bool phoneVerified;
  String imageUrl;

  User({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.userId,
    required this.emailVerified,
    required this.phoneVerified,
    required this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["firstName"]??"",
    middleName: json["middleName"]??"",
    lastName: json["lastName"]??"",
    email: json["email"]??"",
    phone: json["phone"]??"",
    userId: json["userId"]??json["id"]??"",
    emailVerified: json["emailVerified"],
    phoneVerified: json["phoneVerified"]??true,
    imageUrl: json["imageUrl"]??"",
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "middleName": middleName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "userId": userId,
    "emailVerified": emailVerified,
    "phoneVerified": phoneVerified,
    "imageUrl": imageUrl,
  };
}
