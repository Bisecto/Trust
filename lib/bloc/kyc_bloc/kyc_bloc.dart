import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:teller_trust/bloc/auth_bloc/auth_bloc.dart';

import '../../repository/app_repository.dart';
import '../../res/apis.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  KycBloc() : super(KycInitial()) {
on<InitiateVerification>(initiateVerification);
    // on<KycEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> initiateVerification(InitiateVerification event, Emitter<KycState> emit) async {
    emit(LoadingState());
    AppRepository appRepository = AppRepository();
    try {
      Map<String,String> data={
        "identityType": event.identityType,
        "identityNumber": event.identityNumber
      };
      var verificationResponse = await appRepository.appPostRequest(data,
          AppApis.initiateVerification);
      print(verificationResponse.statusCode);
      print(verificationResponse.body);
      if (verificationResponse.statusCode == 200 || verificationResponse.statusCode == 201) {
        // BankModel bankModel =
        // BankModel.fromJson(json.decode(bankResponse.body)['data']);
        emit(RequestOtpState());
      } else {
        emit(ErrorState('Failed to fetch banks'));
      }
    } catch (e) {
      emit(ErrorState('Failed to fetch banks: $e'));
    }
  }
}
