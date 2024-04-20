part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

final class CategoryInitial extends CategoryState {}
class CategoryLoadingState extends CategoryState {}

class CategoryErrorState extends CategoryState {
  final String error;

  CategoryErrorState(this.error);
}

class CategorySuccessState extends CategoryState {
  final CategoryModel categoryModel;

  CategorySuccessState(this.categoryModel);
}
