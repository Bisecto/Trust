import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/pin_plus_keyboard.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../bloc/app_bloc/app_bloc.dart' as appBloc;
import '../../../bloc/bank_bloc/bank_bloc.dart' as bankBloc;
import '../../../repository/app_repository.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/enums/toast_mesage.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/form_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../../widgets/show_toast.dart';

class WithdrawalAccount extends StatefulWidget {
  const WithdrawalAccount({Key? key}) : super(key: key);

  @override
  State<WithdrawalAccount> createState() => _WithdrawalAccountState();
}

class _WithdrawalAccountState extends State<WithdrawalAccount> {
  final _bvmController = TextEditingController();
  final _accNumberController = TextEditingController();
  final _bankSelector = TextEditingController();
  String selectedBank = "Select Bank";
  String selectedBankCode = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<appBloc.AppBloc>(
        create: (context) => appBloc.AppBloc(),
    child:  Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const CustomAppBar(
                  title: AppIcons.withdrawalAccountAppbar,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hint: 'BVN',
                          label: '',
                          controller: _bvmController,
                          validator: AppValidator.validateTextfield,
                          widget: Icon(Icons.numbers),
                          textInputType: TextInputType.number,
                          borderColor: _bvmController.text.isNotEmpty
                              ? AppColors.green
                              : AppColors.grey,
                        ),
                        CustomTextFormField(
                          hint: 'Account Number',
                          label: '',
                          textInputType: TextInputType.number,
                          controller: _accNumberController,
                          validator: AppValidator.validateAccountNumberfield,
                          widget: Icon(Icons.numbers),
                          borderColor: _accNumberController.text.length == 10
                              ? AppColors.green
                              : AppColors.grey,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () {
                            modalSheet.showMaterialModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              context: context,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: BankPage(
                                  onBankSelected: (String bankName, String bankCode) {
                                    setState(() {
                                      selectedBank = bankName;
                                      selectedBankCode = bankCode;
                                    });
                                    Navigator.pop(context); // Close modal
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Row(
                                children: [
                                  Icon(Icons.money),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: CustomText(
                                      text: selectedBank,
                                      size: 14,
                                      color: selectedBank != "Select Bank"
                                          ? Colors.black
                                          : AppColors.lightDivider,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FormButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              modalSheet.showMaterialModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0),
                                  ),
                                ),
                                context: context,
                                builder: (context) => PinContinue(
                                  bankCode: selectedBankCode,
                                  bvn: _bvmController.text,
                                  accountNumber: _accNumberController.text, context: context,
                                  appBlo: BlocProvider.of<appBloc.AppBloc>(context), // Pass AppBloc here

                                ),
                              );
                            }
                          },
                          text: "Continue",
                          borderRadius: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )

    );
  }
}

class BankPage extends StatelessWidget {
  final Function(String, String) onBankSelected;

  const BankPage({Key? key, required this.onBankSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bankBloc.BankBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bank List'),
        ),
        body: BankList(onBankSelected: onBankSelected),
      ),
    );
  }
}

class BankList extends StatefulWidget {
  final Function(String, String) onBankSelected;

  const BankList({Key? key, required this.onBankSelected}) : super(key: key);

  @override
  _BankListState createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  final TextEditingController _searchController = TextEditingController();
  int page = 1; // Initialize page number to 1

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchBanks('', page);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          CustomTextFormField(
            hint: 'Search Bank Name',
            label: '',
            controller: _searchController,
            validator: AppValidator.validateAccountNumberfield,
            widget: Icon(Icons.search),
          ),
          BlocBuilder<bankBloc.BankBloc, bankBloc.BankState>(
            builder: (context, state) {
              if (state is bankBloc.LoadingState) {
                return CircularProgressIndicator();
              } else {
                if (state is bankBloc.SuccessState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.bankModel.banks.length,
                      itemBuilder: (context, index) {
                        final bank = state.bankModel.banks[index];
                        return ListTile(
                          onTap: () {
                            widget.onBankSelected(bank.bankName, bank.bankCode);
                          },
                          title: CustomText(
                            text: bank.bankName,
                            size: 14,
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is bankBloc.ErrorState) {
                  return Center(
                    child: Text(state.error),
                  );
                }
              }
              return Container(); // Placeholder, should never be reached
            },
          ),
        ],
      ),
    );
  }

  void _onSearchChanged() {
    page = 1; // Reset page number to 1 when search query changes
    _fetchBanks(_searchController.text, page);
  }

  void _fetchBanks(String query, int pageNo) {
    context.read<bankBloc.BankBloc>().add(bankBloc.FetchBanks(query, pageNo));
    page++; // Increment page number after making the request
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class PinContinue extends StatefulWidget {
  String bvn;
  String accountNumber;
  String bankCode;

  //Map<dynamic,String> data;
  BuildContext context;
   appBloc.AppBloc appBlo; // Receive AppBloc here


  PinContinue(
      {super.key,
      required this.context,
      required this.bankCode,
      required this.bvn,
      required this.accountNumber,    required this.appBlo,
      });

  @override
  State<PinContinue> createState() => _PinContinueState();
}

class _PinContinueState extends State<PinContinue> {
  PinInputController pinInputController = PinInputController(length: 4);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppUtils.deviceScreenSize(context).height / 1.3,
      child:BlocProvider<appBloc.AppBloc>(
        create: (context) => appBloc.AppBloc(),
        child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Please enter your PIN to change password.",
                          weight: FontWeight.bold,
                          size: 16,
                          maxLines: 3,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PinPlusKeyBoardPackage(
                          keyboardButtonShape: KeyboardButtonShape.defaultShape,
                          inputShape: InputShape.defaultShape,
                          keyboardMaxWidth:
                              AppUtils.deviceScreenSize(context).width,
                          inputHasBorder: true,
                          inputFillColor: AppColors.white,
                          inputHeight: 55,
                          inputWidth: 55,
                          keyboardBtnSize: 70,
                          cancelColor: AppColors.black,
                          inputBorderRadius: BorderRadius.circular(10),

                          keyoardBtnBorderRadius: BorderRadius.circular(10),
                          //inputElevation: 3,
                          buttonFillColor: AppColors.white,
                          btnTextColor: AppColors.black,
                          buttonBorderColor: AppColors.grey,
                          spacing:
                              AppUtils.deviceScreenSize(context).height * 0.06,
                          pinInputController: pinInputController,

                          onSubmit: () {
                            context.read<appBloc.AppBloc>().add(
                                appBloc.AddWithdrawalAccount(
                                    widget.accountNumber,
                                    widget.bankCode,
                                    widget.bvn,
                                    pinInputController.text,
                                    widget.context));
                            //Navigator.pop(context);
                            // widget.authBloc.add(ChangePasswordEvent(pinInputController.text,widget.data,widget.context));
                            //Navigator.pop(context);
                          },
                          keyboardFontFamily: '',
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),)
    );
  }
}
