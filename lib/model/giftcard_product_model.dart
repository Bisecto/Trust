// import 'package:teller_trust/model/category_model.dart';
// import 'package:teller_trust/model/product_model.dart';
//
// class GiftCardPrductModel {
//   final String image;
//   final String id;
//   final String reference;
//   final String name;
//   final int buyerPrice;
//   final int sellerCost;
//   final Category category;
//   final Service service;
//
//   GiftCardPrductModel({
//     required this.image,
//     required this.id,
//     required this.reference,
//     required this.name,
//     required this.buyerPrice,
//     required this.sellerCost,
//     required this.category,
//     required this.service,
//   });
//
//   factory GiftCardPrductModel.fromJson(Map<String, dynamic> json) {
//     return GiftCardPrductModel(
//       image: json['image'],
//       id: json['id'],
//       reference: json['reference'],
//       name: json['name'],
//       buyerPrice: json['buyerPrice'],
//       sellerCost: json['sellerCost'],
//       category: Category.fromJson(json['category']),
//       service: Service.fromJson(json['service']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'image': image,
//       'id': id,
//       'reference': reference,
//       'name': name,
//       'buyerPrice': buyerPrice,
//       'sellerCost': sellerCost,
//       'category': category.toJson(),
//       'service': service.toJson(),
//     };
//   }
// }