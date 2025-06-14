part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class BeneficiaryLoadingState extends ProductState {}

final class GetBeneficiarySuccessState extends ProductState {
  final BeneficiaryModel beneficiaryModel;

  GetBeneficiarySuccessState(this.beneficiaryModel);
}

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
  Transaction transaction;

  PurchaseSuccess(this.transaction);
}class A2CPurchaseSuccess extends ProductState {

}

class A2cDetailSuccess extends ProductState {
  A2CDetailModel a2cDetailModel;

  A2cDetailSuccess(this.a2cDetailModel);
}

class CreateA2cSuccess extends ProductState {
  final A2CCreateTransactionModel a2cCreateTransactionModel;
  CreateA2cSuccess(this.a2cCreateTransactionModel);
}class ReportSuccess extends ProductState {
  final A2CCreateTransactionModel a2cCreateTransactionModel;
  ReportSuccess(this.a2cCreateTransactionModel);
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
  final ElectricityVerifiedData electricityVerifiedData;

  //final String msg;

  EntityNumberSuccessState(this.electricityVerifiedData);
}

class EntityNumberErrorState extends ProductState {
  final String error;

  EntityNumberErrorState(this.error);
}

class ErrorState extends ProductState {
  final String error;

  ErrorState(this.error);
}
