class CustomerAccountModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String nin;
  final String? phone;
  final String nuban;
  final String? bankCode;
  final String dvaNuban;
  final String dvaAccountName;
  final String dvaBankName;
  final bool isDvaNubanActive;
  final String provider;
  final bool isSubAccount;
  final DateTime createdAt;
  final String customerId;

  CustomerAccountModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.nin,
    this.phone,
    required this.nuban,
    this.bankCode,
    required this.dvaNuban,
    required this.dvaAccountName,
    required this.dvaBankName,
    required this.isDvaNubanActive,
    required this.provider,
    required this.isSubAccount,
    required this.createdAt,
    required this.customerId,
  });

  factory CustomerAccountModel.fromJson(Map<String, dynamic> json) {
    return CustomerAccountModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      nin: json['nin'] ?? '',
      phone: json['phone'] ?? '',
      nuban: json['nuban'] ?? '',
      bankCode: json['bankCode'] ?? '',
      dvaNuban: json['dvaNuban'] ?? '',
      dvaAccountName: json['dvaAccountName'] ?? '',
      dvaBankName: json['dvaBankName'] ?? '',
      isDvaNubanActive: json['isDvaNubanActive'],
      provider: json['provider'] ?? '',
      isSubAccount: json['isSubAccount'],
      createdAt: DateTime.parse(json['createdAt']),
      customerId: json['customerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'nin': nin,
      'phone': phone,
      'nuban': nuban,
      'bankCode': bankCode,
      'dvaNuban': dvaNuban,
      'dvaAccountName': dvaAccountName,
      'dvaBankName': dvaBankName,
      'isDvaNubanActive': isDvaNubanActive,
      'provider': provider,
      'isSubAccount': isSubAccount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
