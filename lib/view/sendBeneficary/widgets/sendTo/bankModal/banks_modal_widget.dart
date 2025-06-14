import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/sendBloc/send_bloc.dart';
import 'package:teller_trust/bloc/sendBloc/states/send_state.dart';
import 'package:teller_trust/model/bank_model.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/utills/constants/general_constant.dart';

import '../../../../../res/app_icons.dart';
import '../../../../../utills/custom_theme.dart';
import '../../../../widgets/app_custom_text.dart';

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
  late List<Bank> originalBanks;
  late List<Bank> filteredBanks;

  @override
  void initState() {
    super.initState();
    originalBanks = widget.banks;
    filteredBanks = List.from(originalBanks);
    debugPrint('this is the state of the bank search ${originalBanks.toString()}');
  }

  void _filterBanks(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredBanks = List.from(originalBanks);
      });
    } else {
      setState(() {
        filteredBanks = originalBanks
            .where((bank) => bank.bankName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
        if (state is BanksToTxnWith && state.filteredAnyBank) {
          filteredBanks = state.banks;
          debugPrint('this is the state of the bank search filtered');
        }

        return SizedBox(
          width: AppUtils.deviceScreenSize(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundColor
                        : AppColors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          AppIcons.billTopBackground,
                          height: 60,
                          width: AppUtils.deviceScreenSize(context).width,
                          color: AppColors.darkGreen,
                          placeholderBuilder: (context) {
                            return Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextStyles.textHeadings(
                              textValue: 'Banks',
                              textColor: AppColors.darkGreen,
                              textSize: 14,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
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
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(
                          Icons.search,
                          color: AppColors.bankSearchIconColor,
                        ),
                      ),
                      contentPadding: GeneralConstant.sendToFormWidgetContentPadding,
                      border: GeneralConstant.bankListSearchErrorBorder,
                      errorBorder: GeneralConstant.bankSendSearchErrorBorder,
                      disabledBorder: GeneralConstant.bankListSearchBorder,
                      enabledBorder: GeneralConstant.bankListSearchBorder,
                      focusedBorder: GeneralConstant.bankListSearchBorder,
                    ),
                    onChanged: (value) {
                      _filterBanks(value);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 5.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(filteredBanks.length, (index) {
                          Bank bank = filteredBanks[index];
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 20.0,
                                      width: 20.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const AppSpacer(width: 3.0),
                                    Expanded(
                                      child: Text(
                                        bank.bankName,
                                        style: TextStyle(
                                          color: theme.isDark ? AppColors.white : AppColors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                                const AppSpacer(height: 5.0),
                                const Divider(color: AppColors.sendStrokeColor),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
