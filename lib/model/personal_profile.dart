class PersonalInfo {
  String imageUrl;
  String id;
  String firstName;
  String middleName;
  String lastName;
  String userName;
  String email;
  dynamic gender;
  String phone;
  bool emailVerified;
  bool phoneVerified;
  DateTime createdAt;

  PersonalInfo({
    required this.imageUrl,
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.emailVerified,
    required this.phoneVerified,
    required this.createdAt,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        imageUrl: json["imageUrl"],
        id: json["id"],
        firstName: json["firstName"] ?? '',
        middleName: json["middleName"] ?? '',
        lastName: json["lastName"] ?? '',
        userName: json["userName"] ?? '',
        email: json["email"] ?? '',
        gender: json["gender"],
        phone: json["phone"] ?? '',
        emailVerified: json["emailVerified"],
        phoneVerified: json["phoneVerified"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "id": id,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "userName": userName,
        "email": email,
        "gender": gender,
        "phone": phone,
        "emailVerified": emailVerified,
        "phoneVerified": phoneVerified,
        "createdAt": createdAt.toIso8601String(),
      };
}
