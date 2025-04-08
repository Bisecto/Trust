part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

//class InitialEvent extends ProductEvent {}
class ListCategoryEvent extends ProductEvent {
  final String page;
  final String pageSize;

  ListCategoryEvent(this.page, this.pageSize);
}

class GetProductBeneficiaryEvent extends ProductEvent {
  final String productId;

  GetProductBeneficiaryEvent(this.productId);
}

class DeleteBeneficiaryEvent extends ProductEvent {
  final String beneficiaryId;
  final String productId;

  DeleteBeneficiaryEvent(this.beneficiaryId, this.productId);
}

class ListServiceEvent extends ProductEvent {
  final String page;
  final String pageSize;
  final String categoryId;

  ListServiceEvent(this.page, this.pageSize, this.categoryId);
}

class ListGiftCardProducts extends ProductEvent {
  final String query;
  final String page;
  final int pageSize;
  final String categoryId;
  final String serviceId;

  ListGiftCardProducts(
      this.query, this.page, this.pageSize, this.categoryId, this.serviceId);
}

class FetchProduct extends ProductEvent {
  final String query;
  final String page;
  final int pageSize;
  final String categoryId;
  final String serviceId;

  FetchProduct(
      this.query, this.page, this.pageSize, this.categoryId, this.serviceId);
}

class VerifyEntityNumberEvent extends ProductEvent {
  final String producId;
  final String entityNumber;

  VerifyEntityNumberEvent(this.producId, this.entityNumber);
}

class PurchaseProductEvent extends ProductEvent {
  final BuildContext context;
  final RequiredFields requiredFields;
  final String productId;
  final String accessPIN;
  final bool isQuickPay;
  final bool isSaveAsBeneficiarySelected;
  final String beneficiaryName;

  PurchaseProductEvent(
      this.context,
      this.requiredFields,
      this.productId,
      this.accessPIN,
      this.isQuickPay,
      this.isSaveAsBeneficiarySelected,
      this.beneficiaryName);
}

class PurchaseGiftCardEvent extends ProductEvent {
  final BuildContext context;
  final String giftCardTypeId;
  final String accessPIN;
  final bool isQuickPay;
  final String quantity;
  final String recipientEmail;
  final String denominationUSD;

  PurchaseGiftCardEvent(
    this.context,
    this.accessPIN,
    this.isQuickPay,
    this.giftCardTypeId,
    this.quantity,
    this.recipientEmail, this.denominationUSD,
  );
}

class GetA2CDetailsEvent extends ProductEvent {
  final BuildContext context;
  final String productId;
  final String accessPIN;
  final String amount;

  GetA2CDetailsEvent(
    this.context,
    this.productId,
    this.accessPIN,
    this.amount,
  );
}

class ReportTransferEvent extends ProductEvent {
  final BuildContext context;
  final String transactionId;
  final String accessPIN;
  final XFile? proofImage;

  ReportTransferEvent(
    this.context,
    this.transactionId,
    this.accessPIN,
    this.proofImage,
  );
}

class CreateA2CDetailsEvent extends ProductEvent {
  final BuildContext context;
  final String productId;
  final String accessPIN;
  final String amount;

  CreateA2CDetailsEvent(
    this.context,
    this.productId,
    this.accessPIN,
    this.amount,
  );
}
