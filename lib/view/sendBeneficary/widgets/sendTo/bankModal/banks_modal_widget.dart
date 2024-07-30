import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/bloc/sendBloc/event/send_event.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/model/bank_model.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/constants/general_constant.dart';

class BanksModalWidget extends StatefulWidget {
  final List<Bank> banks;
  const BanksModalWidget({
    super.key,
    required this.banks,
  });

  @override
  State<BanksModalWidget> createState() => _BanksModalWidgetState();
}

class _BanksModalWidgetState extends State<BanksModalWidget> {
  final TextEditingController bankSearchController = TextEditingController();

  late List<Bank> banks;

  @override
  void initState() {
    banks = widget.banks;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        if(state is BanksToTxnWith){
          banks = state.banks;
        }
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.only(
                  //   left: 10.0,
                  //   right: 10.0,
                  //   bottom: 20.0,
                  //   top: 10.0,
                  // ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/bankSearchHeader.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Banks',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: SvgPicture.asset(
                              'assets/icons/sendBeneficiary/bankModalCancel.svg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.bankSearchBgColor,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    bottom: 10.0,
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: SizedBox(
                    height: 40.0,
                    child: TextField(
                      controller: bankSearchController,
                      textInputAction: TextInputAction.search,
                      enabled: true,
                      cursorColor: AppColors.searchHintLabelTextColor,
                      style: GeneralConstant.sendToDefaultTextStyle,
                      decoration: InputDecoration(
                        fillColor: AppColors.bankSearchBgColor,
                        filled: true,
                        hintText: 'Search list',
                        hintStyle: GeneralConstant.normalTextStyle,
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(
                            right: 15.0,
                          ),
                          child: Icon(
                            Icons.search,
                            color: AppColors.bankSearchIconColor,
                          ),
                        ),
                        contentPadding:
                            GeneralConstant.sendToFormWidgetContentPadding,
                        border: GeneralConstant.bankListSearchErrorBorder,
                        errorBorder: GeneralConstant.bankSendSearchErrorBorder,
                        disabledBorder: GeneralConstant.bankListSearchBorder,
                        enabledBorder: GeneralConstant.bankListSearchBorder,
                        focusedBorder: GeneralConstant.bankListSearchBorder,
                      ),
                      onChanged: (value) {
                        BlocProvider.of<SendBloc>(context).add(
                          SearchForABank(
                            searchValue: value,
                            banks: banks,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 5.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(widget.banks.length, (index) {
                            Bank bank = widget.banks[index];
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context, bank);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 20.0,
                                        width: 20.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        // child: SvgPicture.asset(
                                        //   '',
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                      const AppSpacer(
                                        width: 3.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          bank.bankName,
                                          style: const TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const AppSpacer(
                                    height: 5.0,
                                  ),
                                  const Divider(
                                    color: AppColors.sendStrokeColor,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
