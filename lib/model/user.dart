class User {
  String firstName;
  String lastName;
  String middleName;
  String id;
  String email;
  String phone;
  dynamic emailVerified;
  bool phoneVerified;

  User({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.id,
    required this.email,
    required this.phone,
    required this.emailVerified,
    required this.phoneVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        middleName: json["middleName"],
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        emailVerified: json["emailVerified"],
        phoneVerified: json["phoneVerified"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "middleName": middleName,
        "id": id,
        "email": email,
        "phone": phone,
        "emailVerified": emailVerified,
        "phoneVerified": phoneVerified,
      };
}
