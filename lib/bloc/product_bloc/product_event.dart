part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

//class InitialEvent extends ProductEvent {}
class ListCategoryEvent extends ProductEvent {
  final String page;
  final String pageSize;

  ListCategoryEvent(this.page, this.pageSize);
}

class ListServiceEvent extends ProductEvent {
  final String page;
  final String pageSize;
  final String categoryId;

  ListServiceEvent(this.page, this.pageSize, this.categoryId);
}class ListProductEvent extends ProductEvent {
  final String page;
  final String pageSize;
  final String categoryId;
  final String serviceId;

  ListProductEvent(this.page, this.pageSize, this.categoryId,this.serviceId);
}

class PurchaseProductEvent extends ProductEvent {
  final BuildContext context;
  final String productId;
  final String phone;
  final String accessPIN;
  final double amount;

  PurchaseProductEvent(this.context,this.amount, this.phone, this.productId,this.accessPIN);
}
