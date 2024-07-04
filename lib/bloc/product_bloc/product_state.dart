part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

final class ProductInitial extends ProductState {}

class CategoryLoadingState extends ProductState {}

class ServiceLoadingState extends ProductState {}

class ServiceErrorState extends ProductState {
  final String error;

  ServiceErrorState(this.error);
}

class CategoryErrorState extends ProductState {
  final String error;

  CategoryErrorState(this.error);
}

class CategorySuccessState extends ProductState {
  final CategoryModel categoryModel;

  CategorySuccessState(this.categoryModel);
}

class ServiceSuccessState extends ProductState {
  final ServiceModel serviceModel;

  ServiceSuccessState(this.serviceModel);
}

class AccessTokenExpireState extends ProductState {}

class EntityNumberLoadingState extends ProductState {}


class PurchaseSuccess extends ProductState {
}

class QuickPayInitiated extends ProductState {
  final QuickPayModel quickPayModel;

  QuickPayInitiated(this.quickPayModel);
}

class PurchaseErrorState extends ProductState {
  final String error;

  PurchaseErrorState(this.error);
}

class ProductErrorState extends ProductState {
  final String error;

  ProductErrorState(this.error);
}

class ProductLoadingState extends ProductState {
  ProductLoadingState();
}

class ProductSuccessState extends ProductState {
  final ProductModel productModel;

  //final String msg;

  ProductSuccessState(this.productModel);
}

class EntityNumberSuccessState extends ProductState {
  final String name;

  //final String msg;

  EntityNumberSuccessState(this.name);
}
class EntityNumberErrorState extends ProductState{
  final String error;
  EntityNumberErrorState(this.error);
}
