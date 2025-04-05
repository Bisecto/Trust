import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teller_trust/model/electricity_verify_model.dart';
import 'package:teller_trust/model/product_model.dart';
import 'package:teller_trust/model/transactionHistory.dart';

import '../../model/a2c/a2c_create_transaction_model.dart';
import '../../model/a2c/a2c_detail_model.dart';
import '../../model/beneficiary_model.dart';
import '../../model/category_model.dart';
import '../../model/quickpay_model.dart';
import '../../model/required_field_model.dart';
import '../../model/service_model.dart';
import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/app_utils.dart';
import '../../utills/constants/loading_dialog.dart';
import '../../utills/shared_preferences.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ListCategoryEvent>(listCategoryEvent);
    on<ListServiceEvent>(listServiceEvent);
    on<ListGiftCardProducts>(listGiftCardProducts);
    on<FetchProduct>(fetchProduct);
    on<PurchaseProductEvent>(purchaseProductEvent);
    on<GetA2CDetailsEvent>(getA2CDetailsEvent);
    on<CreateA2CDetailsEvent>(createA2CDetailsEvent);
    on<ReportTransferEvent>(reportTransferEvent);
    on<VerifyEntityNumberEvent>(verifyEntityNumberEvent);
    on<GetProductBeneficiaryEvent>(getProductBeneficiaryEvent);
    on<DeleteBeneficiaryEvent>(deleteBeneficiaryEvent);
    // on<ProductEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  Future<FutureOr<void>> listCategoryEvent(
      ListCategoryEvent event, Emitter<ProductState> emit) async {
    emit(
        CategoryLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
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
      print(json.decode(listProductResponse.body)['data']['items'][0]);
      print(json.decode(listProductResponse.body)['data']['items'][1]);
      print(json.decode(listProductResponse.body)['data']['items'][2]);
      print(json.decode(listProductResponse.body)['data']['items'][3]);
      print(json.decode(listProductResponse.body)['data']['items'][4]);
      print(json.decode(listProductResponse.body)['data']['items'][5]);
      CategoryModel categoryModel =
          CategoryModel.fromJson(json.decode(listProductResponse.body));

      //updateData(customerProfile);
      print(categoryModel);
      emit(CategorySuccessState(categoryModel)); // Emit success state with data
    } else if (json.decode(listProductResponse.body)['errorCode'] == "N404") {
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
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
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
      } else if (json.decode(listServiceResponse.body)['errorCode'] == "N404") {
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

  FutureOr<void> purchaseProductEvent(
      PurchaseProductEvent event, Emitter<ProductState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('Processing purchase...');
        });

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
    //try {
    Map<String, dynamic> data = {
      "productId": event.productId,
      //"660bbd40-35c5-42c7-83b6-63f55e179e7d",//event.productId,
      "requiredFields": event.requiredFields.toJson()
    };
    var purchaseResponse = await appRepository.appPostRequest(
      data,
      event.isQuickPay ? AppApis.quickPay : AppApis.purchaseProduct,
      accessToken: accessToken,
      accessPIN: event.accessPIN,
    );
    if (event.isSaveAsBeneficiarySelected) {
      Map<String, dynamic> beneficiarydData = {
        "productId": event.productId,
        "fullName": event.beneficiaryName,
        "requiredFields": event.requiredFields.toJson()
      };
      var response = await appRepository.appPostRequest(
        beneficiarydData,
        event.isQuickPay ? AppApis.quickPay : AppApis.createBeneficiary,
        accessToken: accessToken,
        accessPIN: event.accessPIN,
      );
      print(json.decode(response.body));
      print((response.statusCode));
    }
    Navigator.pop(event.context);
    print(purchaseResponse.body);

    print("purchaseResponse status Code ${purchaseResponse.statusCode}");
    print("purchaseResponse Data ${purchaseResponse.body}");
    print(json.decode(purchaseResponse.body));
    if (purchaseResponse.statusCode == 200 ||
        purchaseResponse.statusCode == 201) {
      // ServiceModel serviceModel =
      // ServiceModel.fromJson(json.decode(listServiceResponse.body));
      // //updateData(customerProfile);
      // print(serviceModel);
      if (event.isQuickPay) {
        QuickPayModel quickPayModel =
            QuickPayModel.fromJson(json.decode(purchaseResponse.body)['data']);
        emit(QuickPayInitiated(quickPayModel));
      } else {
        Transaction transaction =
            Transaction.fromJson(json.decode(purchaseResponse.body)['data']);
        emit(PurchaseSuccess(transaction));
      } // Emit success state with data
    } else if (json.decode(purchaseResponse.body)['errorCode'] == "N404") {
      emit(AccessTokenExpireState());
    } else {
      emit(PurchaseErrorState(AppUtils.convertString(
          json.decode(purchaseResponse.body)['message'])));
      print(json.decode(purchaseResponse.body));
    }
    // } catch (e) {
    //   emit(PurchaseErrorState("An error occurred while fetching categories."));
    //   print(e);
    // }
  }

  FutureOr<void> fetchProduct(
      FetchProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
    try {
      var listServiceResponse = await appRepository.appGetRequest(
        '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}&categoryId=${event.categoryId}&serviceId=${event.serviceId}',
        accessToken: accessToken,
      );
      // var listProductResponse = await appRepository.appGetRequest(
      //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}&categoryId=${event.categoryId}&serviceId=152d04b2-476c-45b3-bf39-4cb5faf43569',
      //   accessToken: accessToken,
      // );
      //print(listProductResponse.body);

      print("productModel status Code ${listServiceResponse.statusCode}");
      print("productModel Data ${listServiceResponse.body}");
      print(json.decode(listServiceResponse.body));
      if (listServiceResponse.statusCode == 200 ||
          listServiceResponse.statusCode == 201) {
        ProductModel productModel =
            ProductModel.fromJson(json.decode(listServiceResponse.body));
        //updateData(customerProfile);
        print(productModel);
        emit(ProductSuccessState(productModel)); // Emit success state with data
      } else if (json.decode(listServiceResponse.body)['errorCode'] == "N404") {
        emit(AccessTokenExpireState());
      } else {
        emit(ProductErrorState(AppUtils.convertString(
            json.decode(listServiceResponse.body)['message'])));
        print(json.decode(listServiceResponse.body));
      }
    } catch (e) {
      emit(ProductErrorState("An error occurred while fetching categories."));
      print(e);
    }
  }

  FutureOr<void> verifyEntityNumberEvent(
      VerifyEntityNumberEvent event, Emitter<ProductState> emit) async {
    emit(EntityNumberLoadingState());
    AppRepository appRepository = AppRepository();

    try {
      // Map<dynamic, String> data = {
      //   "phone": event.phone,
      //   "network_id": event.networkId,
      //   "amount": event.amount,
      //   "transactionPin": event.transactionPin,
      // };
      AppRepository appRepository = AppRepository();
      String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
      // try {
      Map<String, dynamic> data = {
        "productId": event.producId,
        "entityNumber": event.entityNumber
      };
      print(data);
      var entityNumberResponse = await appRepository.appPostRequest(
        data,
        AppApis.verifyEntityNumber,
        accessToken: accessToken,
      );
      print(entityNumberResponse.body);
      if (entityNumberResponse.statusCode == 200 ||
          entityNumberResponse.statusCode == 201) {
        ElectricityVerifiedData electricityVerifiedData =
            ElectricityVerifiedData.fromJson(
                json.decode(entityNumberResponse.body)['data']);
        if (json.decode(entityNumberResponse.body)['data']['statusCode']==null
            // ==
            //     200 ||
            // json.decode(entityNumberResponse.body)['data']['statusCode'] ==
            //     201
        ) {
          emit(EntityNumberSuccessState(electricityVerifiedData));
        } else {
          emit(EntityNumberErrorState(AppUtils.convertString(
              json.decode(entityNumberResponse.body)['data']['message'])));
        }
        // if(electricityVerifiedData.)
        // BillPaymentModel billPaymentModel = BillPaymentModel.fromJson(
        //     jsonDecode(response.body)['data']['data']);

        // String customerName = json.decode(response.body)['data']['data']
        // ['customer_name'] ??
        //     "No user found";
      } else {
        emit(EntityNumberErrorState(AppUtils.convertString(
            json.decode(entityNumberResponse.body)['message'])));
      }
    } catch (e) {
      emit(EntityNumberErrorState(AppUtils.convertString(e.toString())));
    }
  }

  FutureOr<void> getProductBeneficiaryEvent(
      GetProductBeneficiaryEvent event, Emitter<ProductState> emit) async {
    emit(BeneficiaryLoadingState());
    AppRepository appRepository = AppRepository();

    try {
      String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);

      var response = await appRepository.appGetRequest(
          accessToken: accessToken,
          "${AppApis.listBeneficiary}?productId=${event.productId}");
      print(response.statusCode);
      print(response.body);
      print(json.decode(response.body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        BeneficiaryModel beneficiaryModel =
            BeneficiaryModel.fromJson(json.decode(response.body)['data']);

        emit(GetBeneficiarySuccessState(beneficiaryModel));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
      }
    } on SocketException {
      emit(ErrorState(
          'Network error: Unable to connect. Please check your internet connection.'));
    } on HttpException {
      emit(ErrorState('Server error: Unable to communicate with the server.'));
    } on FormatException {
      emit(ErrorState('Data error: Received data is in an unexpected format.'));
    } catch (e) {
      emit(ErrorState(AppUtils.convertString(e.toString())));
    }
  }

  FutureOr<void> deleteBeneficiaryEvent(
      DeleteBeneficiaryEvent event, Emitter<ProductState> emit) async {
    emit(BeneficiaryLoadingState());
    AppRepository appRepository = AppRepository();

    try {
      String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);

      var response2 = await appRepository.appDeleteRequest(
          accessToken: accessToken,
          "${AppApis.deleteBeneficiary}/${event.beneficiaryId}");
      var response = await appRepository.appGetRequest(
          accessToken: accessToken,
          "${AppApis.listBeneficiary}?productId=${event.productId}");
      print(response2.statusCode);
      print(response2.body);
      print(response.statusCode);
      print(response.body);
      print(json.decode(response.body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        BeneficiaryModel beneficiaryModel =
            BeneficiaryModel.fromJson(json.decode(response.body)['data']);

        emit(GetBeneficiarySuccessState(beneficiaryModel));
      } else {
        emit(ErrorState(
            AppUtils.convertString(json.decode(response.body)['message'])));
      }
    } on SocketException {
      emit(ErrorState(
          'Network error: Unable to connect. Please check your internet connection.'));
    } on HttpException {
      emit(ErrorState('Server error: Unable to communicate with the server.'));
    } on FormatException {
      emit(ErrorState('Data error: Received data is in an unexpected format.'));
    } catch (e) {
      emit(ErrorState(AppUtils.convertString(e.toString())));
    }
  }

  FutureOr<void> getA2CDetailsEvent(
      GetA2CDetailsEvent event, Emitter<ProductState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('');
        });

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
    //try {
    Map<String, dynamic> data = {
      "productId": event.productId,
      "amount": event.amount
    };
    var a2cDetailResponse = await appRepository.appPostRequest(
      data,
      AppApis.a2cDetails,
      accessToken: accessToken,
      accessPIN: event.accessPIN,
    );

    Navigator.pop(event.context);
    print(a2cDetailResponse.body);

    print("getA2CDetailsEvent status Code ${a2cDetailResponse.statusCode}");
    print("getA2CDetailsEvent Data ${a2cDetailResponse.body}");
    print(json.decode(a2cDetailResponse.body));
    if (a2cDetailResponse.statusCode == 200 ||
        a2cDetailResponse.statusCode == 201) {
      A2CDetailModel a2cDetailModel =
          A2CDetailModel.fromJson(json.decode(a2cDetailResponse.body));
      emit(A2cDetailSuccess(a2cDetailModel));
    } else if (json.decode(a2cDetailResponse.body)['errorCode'] == "N404") {
      emit(AccessTokenExpireState());
    } else {
      emit(PurchaseErrorState(AppUtils.convertString(
          json.decode(a2cDetailResponse.body)['message'])));
      print(json.decode(a2cDetailResponse.body));
    }
    // } catch (e) {
    //   emit(a2cDetailErrorState("An error occurred while fetching categories."));
    //   print(e);
    // }
  }

  FutureOr<void> createA2CDetailsEvent(
      CreateA2CDetailsEvent event, Emitter<ProductState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('');
        });

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
    //try {
    Map<String, dynamic> data = {
      "productId": event.productId,
      "amount": event.amount
    };
    var createA2cResponse = await appRepository.appPostRequest(
      data,
      AppApis.createA2c,
      accessToken: accessToken,
      accessPIN: event.accessPIN,
    );

    Navigator.pop(event.context);
    print(createA2cResponse.body);

    print("getA2CDetailsEvent status Code ${createA2cResponse.statusCode}");
    print("getA2CDetailsEvent Data ${createA2cResponse.body}");
    print(json.decode(createA2cResponse.body));
    if (createA2cResponse.statusCode == 200 ||
        createA2cResponse.statusCode == 201) {
      A2CCreateTransactionModel a2cCreateTransactionModel=A2CCreateTransactionModel.fromJson(json.decode(createA2cResponse.body)['data']);
      emit(CreateA2cSuccess(a2cCreateTransactionModel));
    } else if (json.decode(createA2cResponse.body)['errorCode'] == "N404") {
      emit(AccessTokenExpireState());
    } else {
      emit(PurchaseErrorState(AppUtils.convertString(
          json.decode(createA2cResponse.body)['message'])));
      print(json.decode(createA2cResponse.body));
    }
    // } catch (e) {
    //   emit(a2cDetailErrorState("An error occurred while fetching categories."));
    //   print(e);
    // }
  }

  FutureOr<void> reportTransferEvent(
      ReportTransferEvent event, Emitter<ProductState> emit) async {
    showDialog(
        barrierDismissible: false,
        context: event.context,
        builder: (_) {
          return const LoadingDialog('');
        });

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
    //try {

    var reportA2cResponse = await appRepository.appPostRequestWithSingleImages(
      {},
      '${AppApis.reportA2c}/${event.transactionId}',event.proofImage,
      accessToken: accessToken,
      accessPIN: event.accessPIN,
    );

    Navigator.pop(event.context);
    print(reportA2cResponse.body);

    print("getA2CDetailsEvent status Code ${reportA2cResponse.statusCode}");
    print("getA2CDetailsEvent Data ${reportA2cResponse.body}");
    print(json.decode(reportA2cResponse.body));
    if (reportA2cResponse.statusCode == 200 ||
        reportA2cResponse.statusCode == 201) {
//Transaction transaction=Transaction.
      emit(A2CPurchaseSuccess());
    } else if (json.decode(reportA2cResponse.body)['errorCode'] == "N404") {
      emit(AccessTokenExpireState());
    } else {
      emit(PurchaseErrorState(AppUtils.convertString(
          json.decode(reportA2cResponse.body)['message'])));
      print(json.decode(reportA2cResponse.body));
    }
    // } catch (e) {
    //   emit(a2cDetailErrorState("An error occurred while fetching categories."));
    //   print(e);
    // }
  }

  FutureOr<void> listGiftCardProducts(ListGiftCardProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString(SharedPrefKey.accessTokenKey);
    try {
      var listServiceResponse = await appRepository.appGetRequest(
        AppApis.getGiftCardProduct,
        accessToken: accessToken,
      );


      print("productModel status Code ${listServiceResponse.statusCode}");
      print("productModel Data ${listServiceResponse.body}");
      print(json.decode(listServiceResponse.body));
      if (listServiceResponse.statusCode == 200 ||
          listServiceResponse.statusCode == 201) {
        ProductModel productModel =
        ProductModel.fromJson(json.decode(listServiceResponse.body));
        //updateData(customerProfile);
        print(productModel);
        emit(ProductSuccessState(productModel)); // Emit success state with data
      } else if (json.decode(listServiceResponse.body)['errorCode'] == "N404") {
        emit(AccessTokenExpireState());
      } else {
        emit(ProductErrorState(AppUtils.convertString(
            json.decode(listServiceResponse.body)['message'])));
        print(json.decode(listServiceResponse.body));
      }
    } catch (e) {
      emit(ProductErrorState("An error occurred while fetching categories."));
      print(e);
    }
  }
}
