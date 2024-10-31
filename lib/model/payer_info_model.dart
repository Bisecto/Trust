class PayInfo {
  final String id;
  final int amount;
  final String provider;
  final String reference;
  final String channel;
  final String status;
  final DateTime? paidAt;
  final String senderNuban;
  final String senderAccountName;
  final String senderBank;
  final String narration;
  final String receiverNuban;
  final String receiverBank;
  final String authorizationCode;
  final String cardType;
  final String paymentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PayInfo({
    required this.id,
    required this.amount,
    required this.provider,
    required this.reference,
    required this.channel,
    required this.status,
    this.paidAt,
    required this.senderNuban,
    required this.senderAccountName,
    required this.senderBank,
    required this.narration,
    required this.receiverNuban,
    required this.receiverBank,
    required this.authorizationCode,
    required this.cardType,
    required this.paymentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PayInfo.fromJson(Map<String, dynamic> json) {
    return PayInfo(
      id: json['id'],
      amount: json['amount'],
      provider: json['provider'],
      reference: json['reference'],
      channel: json['channel'],
      status: json['status'],
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      senderNuban: json['senderNuban'],
      senderAccountName: json['senderAccountName'],
      senderBank: json['senderBank'],
      narration: json['narration'],
      receiverNuban: json['receiverNuban'],
      receiverBank: json['receiverBank'],
      authorizationCode: json['authorizationCode'],
      cardType: json['cardType'],
      paymentId: json['paymentId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'provider': provider,
      'reference': reference,
      'channel': channel,
      'status': status,
      'paidAt': paidAt?.toIso8601String(),
      'senderNuban': senderNuban,
      'senderAccountName': senderAccountName,
      'senderBank': senderBank,
      'narration': narration,
      'receiverNuban': receiverNuban,
      'receiverBank': receiverBank,
      'authorizationCode': authorizationCode,
      'cardType': cardType,
      'paymentId': paymentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
