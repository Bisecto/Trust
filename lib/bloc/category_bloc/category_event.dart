part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

//class InitialEvent extends CategoryEvent {}
class ListCategoryEvent extends CategoryEvent {
  final String page;
  final String pageSize;

  ListCategoryEvent(this.page, this.pageSize);
}