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
}class FetchProduct extends ProductEvent {
  final String query;
  final String page;
  final int pageSize;
  final String categoryId;
  final String serviceId;

  FetchProduct(this.query,this.page, this.pageSize, this.categoryId,this.serviceId);
}

class PurchaseProductEvent extends ProductEvent {
  final BuildContext context;
  final RequiredFields requiredFields;
  final String productId;
  final String accessPIN;
  final bool isQuickPay;

  PurchaseProductEvent(this.context,this.requiredFields, this.productId,this.accessPIN,this.isQuickPay);
}


