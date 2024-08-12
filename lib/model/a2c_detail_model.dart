
class A2CDetailModel {
  String message;
  Data data;

  A2CDetailModel({
    required this.message,
    required this.data,
  });

  factory A2CDetailModel.fromJson(Map<String, dynamic> json) => A2CDetailModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  RecieverContact recieverContact;
  int amountToReceive;
  List<String> instructions;

  Data({
    required this.recieverContact,
    required this.amountToReceive,
    required this.instructions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    recieverContact: RecieverContact.fromJson(json["recieverContact"]),
    amountToReceive: json["amountToReceive"],
    instructions: List<String>.from(json["instructions"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "recieverContact": recieverContact.toJson(),
    "amountToReceive": amountToReceive,
    "instructions": List<dynamic>.from(instructions.map((x) => x)),
  };
}

class RecieverContact {
  String name;
  String phoneNumber;

  RecieverContact({
    required this.name,
    required this.phoneNumber,
  });

  factory RecieverContact.fromJson(Map<String, dynamic> json) => RecieverContact(
    name: json["name"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phoneNumber": phoneNumber,
  };
}
