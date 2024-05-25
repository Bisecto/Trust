part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

//class InitialEvent extends ProductEvent {}
class ListCategoryEvent extends ProductEvent {
  final String page;
  final String pageSize;

  ListCategoryEvent(this.page, this.pageSize);
}class ListServiceEvent extends ProductEvent {
  final String page;
  final String pageSize;
  final String categoryId;

  ListServiceEvent(this.page, this.pageSize,this.categoryId);
}