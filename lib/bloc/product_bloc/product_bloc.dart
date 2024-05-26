import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:teller_trust/model/product_model.dart';

import '../../model/category_model.dart';
import '../../model/service_model.dart';
import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../utills/app_utils.dart';
import '../../utills/constants/loading_dialog.dart';
import '../../utills/shared_preferences.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ListCategoryEvent>(listCategoryEvent);
    on<ListServiceEvent>(listServiceEvent);
    on<FetchProduct>(fetchProduct);
    on<PurchaseProductEvent>(purchaseProductEvent);
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
    print("ListProductResponse status Code ${listProductResponse.statusCode}");
    print("ListProductResponse Data ${listProductResponse.body}");
    print(json.decode(listProductResponse.body));
    if (listProductResponse.statusCode == 200 ||
        listProductResponse.statusCode == 201) {
      CategoryModel categoryModel =
          CategoryModel.fromJson(json.decode(listProductResponse.body));
      //updateData(customerProfile);
      print(categoryModel);
      emit(CategorySuccessState(categoryModel)); // Emit success state with data
    } else if (listProductResponse.statusCode == 401) {
      emit(AccessTokenExpireState());
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

  FutureOr<void> listServiceEvent(
      ListServiceEvent event, Emitter<ProductState> emit) async {
    emit(ServiceLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
    try {
      var listServiceResponse = await appRepository.appGetRequest(
        '${AppApis.listService}?page=${event.page}&pageSize=${event.pageSize}&categoryId=${event.categoryId}',
        accessToken: accessToken,
      );
      // var listProductResponse = await appRepository.appGetRequest(
      //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}&categoryId=${event.categoryId}&serviceId=152d04b2-476c-45b3-bf39-4cb5faf43569',
      //   accessToken: accessToken,
      // );
      //print(listProductResponse.body);

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
        emit(ServiceSuccessState(serviceModel)); // Emit success state with data
      } else if (listServiceResponse.statusCode == 401) {
        emit(AccessTokenExpireState());
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


  FutureOr<void> purchaseProductEvent(PurchaseProductEvent event, Emitter<ProductState> emit)async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Processing purchase...');
        });

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
    try {
      Map<String,dynamic> data={
        "productId": "660bbd40-35c5-42c7-83b6-63f55e179e7d",//event.productId,
        "requiredFields": {
          "phone": event.phone,
          "amount": event.amount
        }
      };
      var purchaseResponse = await appRepository.appPostRequest(data,
        '${AppApis.purchaseProduct}',
        accessToken: accessToken,
        accessPIN: event.accessPIN,
      );
      Navigator.pop(event.context);
      print(purchaseResponse.body);

      print(
          "purchaseResponse status Code ${purchaseResponse.statusCode}");
      print("purchaseResponse Data ${purchaseResponse.body}");
      print(json.decode(purchaseResponse.body));
      if (purchaseResponse.statusCode == 200 ||
          purchaseResponse.statusCode == 201) {
        // ServiceModel serviceModel =
        // ServiceModel.fromJson(json.decode(listServiceResponse.body));
        // //updateData(customerProfile);
        // print(serviceModel);
        emit(PurchaseSuccess()); // Emit success state with data
      } else if (purchaseResponse.statusCode == 401) {
        emit(AccessTokenExpireState());
      } else {
        emit(PurchaseErrorState(AppUtils.convertString(
            json.decode(purchaseResponse.body)['message'])));
        print(json.decode(purchaseResponse.body));
      }
    } catch (e) {
      emit(PurchaseErrorState("An error occurred while fetching categories."));
      print(e);
    }
  }

  FutureOr<void> fetchProduct(FetchProduct event, Emitter<ProductState> emit
      ) async {
    emit(ProductLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString("access-token");
    // try {
    var listServiceResponse = await appRepository.appGetRequest(
      '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}&categoryId=${event.categoryId}&serviceId=${event.serviceId}',
      accessToken: accessToken,
    );
    // var listProductResponse = await appRepository.appGetRequest(
    //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}&categoryId=${event.categoryId}&serviceId=152d04b2-476c-45b3-bf39-4cb5faf43569',
    //   accessToken: accessToken,
    // );
    //print(listProductResponse.body);

    print(
        "productModel status Code ${listServiceResponse.statusCode}");
    print("productModel Data ${listServiceResponse.body}");
    print(json.decode(listServiceResponse.body));
    if (listServiceResponse.statusCode == 200 ||
        listServiceResponse.statusCode == 201) {
      ProductModel productModel =ProductModel.fromJson(json.decode(listServiceResponse.body));
      //updateData(customerProfile);
      print(productModel);
      emit(ProductSuccessState(productModel)); // Emit success state with data
    } else if (listServiceResponse.statusCode == 401) {
      emit(AccessTokenExpireState());
    } else {
      emit(ProductErrorState(AppUtils.convertString(
          json.decode(listServiceResponse.body)['message'])));
      print(json.decode(listServiceResponse.body));
    }
    // } catch (e) {
    //   emit(ProductErrorState("An error occurred while fetching categories."));
    //   print(e);
    // }
  }
}
