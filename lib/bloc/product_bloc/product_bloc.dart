import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/category_model.dart';
import '../../model/service_model.dart';
import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ListCategoryEvent>(listCategoryEvent);
    on<ListServiceEvent>(listServiceEvent);
    // on<ProductEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  Future<FutureOr<void>> listCategoryEvent(
      ListCategoryEvent event, Emitter<ProductState> emit) async {
    emit(
        CategoryLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
    //try {
      var listProductResponse = await appRepository.appGetRequest(
        '${AppApis.listCategory}?page=${event.page}&pageSize=${event.pageSize}',
        accessToken: accessToken,
      );
      // var res = await appRepository.appGetRequest(
      //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
      //   accessToken: accessToken,
      // );
      //print(res.body);
      print(
          "ListProductResponse status Code ${listProductResponse.statusCode}");
      print("ListProductResponse Data ${listProductResponse.body}");
      print(json.decode(listProductResponse.body));
      if (listProductResponse.statusCode == 200 ||
          listProductResponse.statusCode == 201) {
        CategoryModel categoryModel =
            CategoryModel.fromJson(json.decode(listProductResponse.body));
        //updateData(customerProfile);
        print(categoryModel);
        emit(CategorySuccessState(
            categoryModel)); // Emit success state with data
      } else {
        emit(CategoryErrorState(AppUtils.convertString(
            json.decode(listProductResponse.body)['message'])));
        print(json.decode(listProductResponse.body));
      }
    // } catch (e) {
    //   emit(CategoryErrorState("An error occurred while fetching categories."));
    //   print(e);
    // }
  }

  FutureOr<void> listServiceEvent(ListServiceEvent event, Emitter<ProductState> emit) async {
    emit(
        ServiceLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
    try {
    var listServiceResponse = await appRepository.appGetRequest(
      '${AppApis.listService}?page=${event.page}&pageSize=${event.pageSize}',
      accessToken: accessToken,
    );
    // var res = await appRepository.appGetRequest(
    //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
    //   accessToken: accessToken,
    // );
    //print(res.body);
    print(
        "ListServiceResponse status Code ${listServiceResponse.statusCode}");
    print("ListServiceResponse Data ${listServiceResponse.body}");
    print(json.decode(listServiceResponse.body));
    if (listServiceResponse.statusCode == 200 ||
        listServiceResponse.statusCode == 201) {
      ServiceModel serviceModel =
      ServiceModel.fromJson(json.decode(listServiceResponse.body));
      //updateData(customerProfile);
      print(serviceModel);
      emit(ServiceSuccessState(
          serviceModel)); // Emit success state with data
    } else {
      emit(ServiceErrorState(AppUtils.convertString(
          json.decode(listServiceResponse.body)['message'])));
      print(json.decode(listServiceResponse.body));
    }
    } catch (e) {
      emit(ServiceErrorState("An error occurred while fetching categories."));
      print(e);
    }
  }
}
