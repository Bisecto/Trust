
class ElectricityVerifiedData {
  String discoCode;
  String vendType;
  String meterNo;
  int minVendAmount;
  int maxVendAmount;
  int outstanding;
  int debtRepayment;
  String name;
  String address;
  String orderId;

  ElectricityVerifiedData({
    required this.discoCode,
    required this.vendType,
    required this.meterNo,
    required this.minVendAmount,
    required this.maxVendAmount,
    required this.outstanding,
    required this.debtRepayment,
    required this.name,
    required this.address,
    required this.orderId,
  });

  factory ElectricityVerifiedData.fromJson(Map<String, dynamic> json) => ElectricityVerifiedData(
    discoCode: json["discoCode"]??'',
    vendType: json["vendType"]??'',
    meterNo: json["meterNo"]??'',
    minVendAmount: json["minVendAmount"]??0,
    maxVendAmount: json["maxVendAmount"]??0,
    outstanding: json["outstanding"]??0,
    debtRepayment: json["debtRepayment"]??0,
    name: json["name"]??'',
    address: json["address"]??'',
    orderId: json["orderId"]??'',
  );

  Map<String, dynamic> toJson() => {
    "discoCode": discoCode,
    "vendType": vendType,
    "meterNo": meterNo,
    "minVendAmount": minVendAmount,
    "maxVendAmount": maxVendAmount,
    "outstanding": outstanding,
    "debtRepayment": debtRepayment,
    "name": name,
    "address": address,
    "orderId": orderId,
  };
}
