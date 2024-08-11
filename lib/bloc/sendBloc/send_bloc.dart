import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/domain/request/send_external_fund_request.dart';
import 'package:teller_trust/domain/request/send_internal_fund_request.dart';
import 'package:teller_trust/domain/request/tella_trust_customer_request.dart';
import 'package:teller_trust/domain/request/verify_receiptent_account_request.dart';
import 'package:teller_trust/model/bank_model.dart';
import 'package:teller_trust/model/bank_verified_account_model.dart';
import 'package:teller_trust/model/customer_profile.dart';
import 'package:teller_trust/model/success_model.dart';
import 'package:teller_trust/model/tella_trust_customer_model.dart';
import 'package:teller_trust/model/transactionHistory.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/res/apis.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/utills/shared_preferences.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  String mainValueEntered = '';
  String fractionValueEntered = '';

  AppRepository appRepository = AppRepository();

  final numberFormat = NumberFormat("#,###", "en_US");

  List<Bank> banks = [];

  SendBloc() : super(const InitialSendState()) {
    on<EnterAmountToSend>((event, emit) {
      if (event.isItForMainValue && !fractionValueEntered.contains('.')) {
        mainValueEntered = mainValueEntered.replaceAll(',', '');
        List mainValues = mainValueEntered.split('');
        if (mainValues.isEmpty) {
          if (event.value != '0' && event.value != '.') {
            mainValueEntered += event.value;
          }
        } else {
          mainValueEntered += event.value;
        }
      } else {
        List fractionValues = fractionValueEntered.split('');
        if (fractionValues.isEmpty) {
          fractionValueEntered += event.value;
        } else {
          if (event.value != '.') {
            fractionValueEntered += event.value;
          }
        }
      }
      mainValueEntered = numberFormat.format(int.parse(mainValueEntered));
      emit(
        CurrentAmountEntered(
          mainValue: mainValueEntered.isNotEmpty ? mainValueEntered : '0',
          fractionValue:
              fractionValueEntered.isNotEmpty && fractionValueEntered.length > 1
                  ? fractionValueEntered
                  : '.00',
        ),
      );
    });
    on<BackSpaceLastEnteredAmountToSend>((event, emit) {
      if (fractionValueEntered.isNotEmpty) {
        List<String> fractionValues = fractionValueEntered.split('');
        fractionValues.removeLast();
        fractionValueEntered = fractionValues.join('');
      } else {
        mainValueEntered = mainValueEntered.replaceAll(',', '');
        if (mainValueEntered.isNotEmpty) {
          List<String> mainValues = mainValueEntered.split('');
          if (mainValues.isNotEmpty) {
            mainValues.removeLast();
            mainValueEntered = mainValues.join('');
          }
        }
      }

      if (mainValueEntered.isNotEmpty && RegExp(r'^-?[0-9]+$').hasMatch(mainValueEntered)) {
        try {
          mainValueEntered = numberFormat.format(int.parse(mainValueEntered));
        } catch (e) {
          // Handle parsing error if needed
          mainValueEntered = '0';
        }
      } else {
        mainValueEntered = '0';
      }

      emit(
        CurrentAmountEntered(
          mainValue: mainValueEntered.isNotEmpty ? mainValueEntered : '0',
          fractionValue: fractionValueEntered.isNotEmpty && fractionValueEntered.length > 1
              ? fractionValueEntered
              : '.00',
        ),
      );
    });
    on<LoadSendToDetailsInitialState>((event, emit) {
      emit(const SendToDetailsInitialState());
    });
    on<LoadUserBalance>((event, emit) async {
      String accessToken = await SharedPref.getString("access-token");

      var profileResponse = await appRepository.appGetRequest(
        AppApis.userProfile,
        accessToken: accessToken,
      );
      debugPrint(
          'this is the balance of the user ${profileResponse.statusCode} ${profileResponse.body.toString()}');
      if (profileResponse.statusCode == 200 ||
          profileResponse.statusCode == 201) {
        CustomerProfile customerProfile =
            CustomerProfile.fromJson(json.decode(profileResponse.body)['data']);
        emit(
          UserBalance(balance: '${customerProfile.walletInfo.balance}'),
        );
      } else if (profileResponse.statusCode == 401) {
        // AppNavigator.pushAndReplacePage(context, page: page)
      } else {
        emit(
          ErrorStateForSendTo(
            errorMessage: AppUtils.convertString(
              json.decode(profileResponse.body)['message'],
            ),
          ),
        );
      }
    });
    on<SelectTxnOption>((event, emit) {
      emit(
        SelectedTxnOption(
          isItForTellaTrust: event.isTxnForTellaTrust,
          toggleOn: true,
        ),
      );
    });
    on<LoadBanksToTxnWith>((event, emit) async {
      emit(
        BanksToTxnWith(
          banksReadyForUse: false,
          loadingBanks: true,
          filteredAnyBank: false,
          banks: const [],
        ),
      );
      String accessToken = await SharedPref.getString("access-token");
      var availableBanks = await appRepository.appGetRequest(
        AppApis.banks,
        accessToken: accessToken,
      );
      if (availableBanks.statusCode == 200) {
        List remoteBanksData = SuccessModel.fromJson(
          jsonDecode(availableBanks.body),
        ).data['items'];
        banks = List<Bank>.from(
          remoteBanksData.map(
            (bank) {
              return Bank.fromJson(bank);
            },
          ),
        );
        emit(
          BanksToTxnWith(
            banksReadyForUse: true,
            loadingBanks: false,
            banks: banks,
            filteredAnyBank: false,
          ),
        );
      } else {
        emit(
          ErrorStateForSendTo(
            errorMessage: AppUtils.convertString(
              json.decode(availableBanks.body)['message'],
            ),
          ),
        );
      }
    });
    on<SearchForABank>((event, emit) {
      List<Bank> filteredSearchedBanks = [];
      String searchValue = event.searchValue;
      banks = event.banks;
      if (searchValue.isNotEmpty) {
        filteredSearchedBanks.clear();
        for (Bank bankElement in banks) {
          if (bankElement.bankName
              .toLowerCase()
              .contains(searchValue.toLowerCase())) {
            filteredSearchedBanks.add(bankElement);
          }
        }
        emit(
          BanksToTxnWith(
            banksReadyForUse: false,
            loadingBanks: false,
            filteredAnyBank: filteredSearchedBanks.isNotEmpty,
            banks: filteredSearchedBanks,
          ),
        );
        debugPrint(
            'this is the state of the bank search $state $searchValue $filteredSearchedBanks');
      } else {
        emit(
          BanksToTxnWith(
            banksReadyForUse: false,
            loadingBanks: false,
            filteredAnyBank: true,
            banks: banks,
          ),
        );
      }
    });
    on<LoadUserTransactions>((event, emit) {
      emit(
        UserTxns(
          loadingTxns: false,
          userTxnsReadyForUse: false,
          forTxnSearch: false,
          txns: const [],
        ),
      );
    });
    on<SearchUserTransactions>((event, emit) {
      emit(
        UserTxns(
          loadingTxns: false,
          userTxnsReadyForUse: true,
          forTxnSearch: true,
          txns: const [],
        ),
      );
    });
    on<EnterTellaTrustReceipentAcc>((event, emit) async {
      String tellaTrustReceiptentAcc = event.tellaTrustReceiptentAcc;
      bool isValueAnEmailAddress =
          emailAddressValidator(emailAddress: tellaTrustReceiptentAcc);
      bool isValueMobileNumber = isNumeric(value: tellaTrustReceiptentAcc) &&
          tellaTrustReceiptentAcc.length >= 11;

      if (tellaTrustReceiptentAcc.isNotEmpty) {
        if (isValueAnEmailAddress || isValueMobileNumber) {
          emit(
            TellaTrustCustomerVerification(
              requestInProgress: true,
              tellaTrustCustomerReceived: false,
            ),
          );
          String accessToken = await SharedPref.getString("access-token");
          var tellaTrustCustomer = await appRepository.appPostRequest(
            TellaTrustCustomerRequest(userData: tellaTrustReceiptentAcc)
                .toJson(),
            AppApis.tellaCustomerVerification,
            accessToken: accessToken,
          );

          if (tellaTrustCustomer.statusCode == 200 ||
              tellaTrustCustomer.statusCode == 201) {
            SuccessModel successState = SuccessModel.fromJson(
              jsonDecode(
                tellaTrustCustomer.body,
              ),
            );
            dynamic dataResponse = successState.data;
            emit(
              TellaTrustCustomerVerification(
                requestInProgress: false,
                tellaTrustCustomerReceived: dataResponse.isNotEmpty,
                tellaTrustCustomerModel: dataResponse.isNotEmpty
                    ? TellaTrustCustomerModel.fromJson(
                        dataResponse.first,
                      )
                    : null,
                message: dataResponse.isEmpty
                    ? 'User does not exist'
                    : 'User gotten',
              ),
            );
          } else {
            emit(
              SendFundToInternalOrExternalRecepitent(
                isPaymentSuccessful: false,
                processingPayment: false,
                statusMessage: SuccessModel.fromJson(
                  jsonDecode(tellaTrustCustomer.body),
                ).message,
              ),
            );
          }
        }
      }
    });
    on<SendInternalFundToReceiptent>((event, emit) async {
      if (event.amount > 0 &&
          event.narration.isNotEmpty &&
          event.receiverId.isNotEmpty) {
        emit(
          SendFundToInternalOrExternalRecepitent(
            isPaymentSuccessful: false,
            processingPayment: true,
            statusMessage: '',
          ),
        );
        String accessToken = await SharedPref.getString("access-token");
        var sendInternalFund = await appRepository.appPostRequest(
            SendInternalFundRequest(
              receiverId: event.receiverId,
              narration: event.narration,
              amount: event.amount,
            ).toJson(),
            AppApis.sendInternalFund,
            accessToken: accessToken,
            accessPIN: event.accessPin);

        if (sendInternalFund.statusCode == 200 ||
            sendInternalFund.statusCode == 201) {
          print(jsonDecode(sendInternalFund.body));
          emit(
            SendFundToInternalOrExternalRecepitent(
              isPaymentSuccessful: true,
              processingPayment: false,
              statusMessage: SuccessModel.fromJson(
                jsonDecode(sendInternalFund.body),
              ).message,
              transaction: Transaction.fromJson(jsonDecode(sendInternalFund.body)['data'])
            ),
          );
        } else {
          emit(
            SendFundToInternalOrExternalRecepitent(
              isPaymentSuccessful: false,
              processingPayment: false,
              statusMessage: SuccessModel.fromJson(
                jsonDecode(sendInternalFund.body),
              ).message,
            ),
          );
        }
      } else {
        emit(
          SendFundToInternalOrExternalRecepitent(
            isPaymentSuccessful: false,
            processingPayment: false,
            statusMessage: 'All fields are required',
          ),
        );
      }
    });
    on<SendExternalFundToReceiptent>((event, emit) async {
      if (event.accountNumber.isNotEmpty &&
          event.amount > 0 &&
          event.bankCode.isNotEmpty &&
          event.narration.isNotEmpty &&
          event.sessionId.isNotEmpty) {
        emit(
          SendFundToInternalOrExternalRecepitent(
            isPaymentSuccessful: false,
            processingPayment: true,
            statusMessage: '',
          ),
        );
        String accessToken = await SharedPref.getString("access-token");
        var sendExternalFund = await appRepository.appPostRequest(
          SendExternalFundRequest(
            narration: event.narration,
            amount: event.amount,
            accountNumber: event.accountNumber,
            bankCode: event.bankCode,
            sessionId: event.sessionId,
          ).toJson(),
          AppApis.sendExternalFund,
          accessPIN: event.txnId,
          accessToken: accessToken,
        );
        if (sendExternalFund.statusCode == 200 ||
            sendExternalFund.statusCode == 201) {

          emit(
            SendFundToInternalOrExternalRecepitent(
              isPaymentSuccessful: true,
              processingPayment: false,
              statusMessage: SuccessModel.fromJson(
                jsonDecode(sendExternalFund.body),
              ).message,
              transaction: Transaction.fromJson(jsonDecode(sendExternalFund.body)['data']),
            ),
          );
        } else {
          emit(
            SendFundToInternalOrExternalRecepitent(
              isPaymentSuccessful: false,
              processingPayment: false,
              statusMessage: SuccessModel.fromJson(
                jsonDecode(sendExternalFund.body),
              ).message,
            ),
          );
        }
      } else {
        emit(
          SendFundToInternalOrExternalRecepitent(
            isPaymentSuccessful: false,
            processingPayment: false,
            statusMessage: 'All fields are required',
          ),
        );
      }
    });
    on<VerifyRecepitentAccountNumber>((event, emit) async {
      String accountNumber = event.accountNumber;
      String bankCode = event.bankCode;
      if (accountNumber.isNotEmpty && bankCode.isNotEmpty) {
        emit(
          VerificationStateForBankAccountNumber(
            isDataReadyForUse: false,
            isRequestInProgress: true,
            statusMessage: '',
          ),
        );
        String accessToken = await SharedPref.getString("access-token");
        var verifyAccountNumber = await appRepository.appPostRequest(
          VerifyReceiptentAccountRequest(
            accountNumber: event.accountNumber,
            bankCode: event.bankCode,
          ).toJson(),
          AppApis.verifyAccount,
          accessToken: accessToken,
        );
        debugPrint(
            'this is the state of the transfer ${verifyAccountNumber.statusCode} ${verifyAccountNumber.body.toString()}');
        if (verifyAccountNumber.statusCode == 200 ||
            verifyAccountNumber.statusCode == 201) {
          emit(
            VerificationStateForBankAccountNumber(
              isDataReadyForUse: true,
              isRequestInProgress: false,
              statusMessage: SuccessModel.fromJson(
                jsonDecode(verifyAccountNumber.body),
              ).message,
              bankVerifiedAccount: BankVerifiedAccountModel.fromJson(
                SuccessModel.fromJson(
                  jsonDecode(verifyAccountNumber.body),
                ).data,
              ),
            ),
          );
        } else {
          emit(
            VerificationStateForBankAccountNumber(
              isDataReadyForUse: false,
              isRequestInProgress: false,
              statusMessage: SuccessModel.fromJson(
                jsonDecode(verifyAccountNumber.body),
              ).message,
              bankVerifiedAccount: BankVerifiedAccountModel.fromJson(
                SuccessModel.fromJson(
                  jsonDecode(verifyAccountNumber.body),
                ).data??{},
              ),
            ),
          );
        }
      } else {
        emit(
          VerificationStateForBankAccountNumber(
            isDataReadyForUse: false,
            isRequestInProgress: false,
            statusMessage: 'All fields are required',
          ),
        );
      }
    });
    on<UserNarationForPayment>((event, emit) {
      emit(
        PaymentNarration(
          narration: event.narration,
        ),
      );
    });
  }

  static bool emailAddressValidator({required String emailAddress}) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailAddress);
  }

  static bool isNumeric({required String value}) {
    return int.tryParse(value) != null;
  }
}
