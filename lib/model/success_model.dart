class SuccessModel {
  String message;
  dynamic data;

  SuccessModel({
    required this.message,
    required this.data,
  });

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data,
  };
}
