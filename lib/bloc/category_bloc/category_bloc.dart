import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/category_model.dart';
import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<ListCategoryEvent>(listCategoryEvent);
    // on<CategoryEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  Future<FutureOr<void>> listCategoryEvent(
      ListCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(
        CategoryLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
    try {
      var listCategoryResponse = await appRepository.appGetRequest(
        '${AppApis.listCategory}?page=${event.page}&pageSize=${event.pageSize}',
        accessToken: accessToken,
      );
      print(
          "ListCategoryResponse status Code ${listCategoryResponse.statusCode}");
      print("ListCategoryResponse Data ${listCategoryResponse.body}");
      if (listCategoryResponse.statusCode == 200 ||
          listCategoryResponse.statusCode == 201) {
        CategoryModel categoryModel =
            CategoryModel.fromJson(json.decode(listCategoryResponse.body));
        //updateData(customerProfile);
        emit(CategorySuccessState(
            categoryModel)); // Emit success state with data
      } else {
        emit(CategoryErrorState(AppUtils.convertString(
            json.decode(listCategoryResponse.body)['message'])));
        print(json.decode(listCategoryResponse.body));
      }
    } catch (e) {
      emit(CategoryErrorState("An error occurred while fetching categories."));
      print(e);
    }
  }
}
