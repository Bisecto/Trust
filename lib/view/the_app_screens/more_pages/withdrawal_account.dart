import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_plus_keyboard/pin_plus_keyboard.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_button.dart';

import '../../../bloc/bank_bloc/bank_bloc.dart';
import '../../../repository/app_repository.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_validator.dart';
import '../../widgets/appBar_widget.dart';
import '../../widgets/form_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(
            title: AppIcons.withdrawalAccountAppbar,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomTextFormField(
                  hint: 'BVN',
                  label: '',
                  controller: _bvmController,
                  validator: AppValidator.validateTextfield,
                  icon: Icons.numbers,
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
                  icon: Icons.numbers,
                  borderColor: _accNumberController.text.length == 10
                      ? AppColors.green
                      : AppColors.grey,
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    modalSheet.showMaterialModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0)),
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
                        color: AppColors.grey, // Choose the color you want for the border
                        width: 1.0, // Choose the width you want for the border
                      ),
                      borderRadius:
                      BorderRadius.circular(10.0), // Choose the border radius you want
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Row(
                        children: [
                          Icon(Icons.money),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomText(
                              text: selectedBank,
                              color: selectedBank != "Select Bank" ? Colors.black : AppColors.lightDivider,
                            ),
                          ),
                          CustomText(
                            text: selectedBankCode,
                            color: selectedBank != "Select Bank" ? Colors.black : AppColors.lightDivider,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                FormButton(onPressed: (){},text: "Continue",borderRadius: 20,)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BankPage extends StatelessWidget {
  final Function(String, String) onBankSelected;

  const BankPage({Key? key, required this.onBankSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankBloc(),
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
            icon: Icons.search,
          ),
          BlocBuilder<BankBloc, BankState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return CircularProgressIndicator();
              } else if (state is SuccessState) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.bankModel.items.length,
                    itemBuilder: (context, index) {
                      final bank = state.bankModel.items[index];
                      return ListTile(
                        onTap: () {
                          widget.onBankSelected(bank.bankName, bank.bankCode);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: bank.bankName),
                            CustomText(text: bank.bankCode),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (state is ErrorState) {
                return Center(
                  child: Text(state.error),
                );
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
    context.read<BankBloc>().add(FetchBanks(query, pageNo));
    page++; // Increment page number after making the request
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
