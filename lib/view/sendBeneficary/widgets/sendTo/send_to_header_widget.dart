import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_spacer.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'package:teller_trust/view/widgets/form_input.dart';

import '../../../../bloc/sendBloc/event/send_event.dart';
import '../../../../bloc/sendBloc/send_bloc.dart';
import '../../../../bloc/sendBloc/states/send_state.dart';
import '../../../../res/sharedpref_key.dart';
import '../../../../utills/custom_theme.dart';
import '../../../../utills/shared_preferences.dart';
import '../sendMain/send_main_form_widget.dart';
import '../sendMain/send_main_header_widget.dart';
import '../send_beneficiary_app_logo_body_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class SendToHeaderWidget extends StatefulWidget {
  //String amountTransferred;
  final String txnMadeToName;
  final String txnMadeToImage;
  final bool isTellaTrustTxn;
  final bool userForTxnConfirmed;
  final VoidCallback backNavCallBack;
  final Function(String) onAmountChanged; // Add this callback

  SendToHeaderWidget({
    super.key,

    ///required this.amountTransferred,
    required this.txnMadeToName,
    required this.txnMadeToImage,
    required this.isTellaTrustTxn,
    required this.userForTxnConfirmed,
    required this.backNavCallBack,
    required this.onAmountChanged,
  });

  @override
  State<SendToHeaderWidget> createState() => _SendToHeaderWidgetState();
}

class _SendToHeaderWidgetState extends State<SendToHeaderWidget> {
  String balance = '0';
  late VoidCallback backNavCallBack;
  TextEditingController controller = TextEditingController();
  bool isMoneyBlocked = false;

  Future<void> getIfMoneyIsBlocked() async {
    isMoneyBlocked = await SharedPref.getBool(SharedPrefKey.isMoneyBlockedKey) ?? false;
    print('Initial isMoneyBlocked: $isMoneyBlocked');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    backNavCallBack = widget.backNavCallBack;
    controller.text = '';
    getIfMoneyIsBlocked();
    BlocProvider.of<SendBloc>(context).add(
      const LoadUserBalance(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.isDark
                ? AppColors.darkModeBackgroundColor
                : AppColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2.0,
                margin: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 30.0,
                    bottom: 10.0,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 9.0,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        theme.isDark
                            ? 'assets/images/sendToBgHeader.png'
                            : 'assets/images/sendToBgHeaderLightMode.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundColor
                        : AppColors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<SendBloc, SendState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is UserBalance) {
                            balance = state.balance;
                          }
                          return SendBeneficiaryAppLogoBodyWidget(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const AppSpacer(
                                //   height: 20.0,
                                // ),
                                SendMainHeaderWidget(
                                  balance: balance,
                                  backNavCallBack: backNavCallBack,
                                ),
                                const AppSpacer(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 5.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        color: theme.isDark
                                            ? AppColors
                                                .darkModeBackgroundContainerColor
                                            : AppColors.sendToAmountBgColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'BALANCE',
                                          style: TextStyle(
                                            color: theme.isDark
                                                ? AppColors
                                                    .darkModeBackgroundMainTextColor
                                                : AppColors
                                                    .sendToAmountTxtColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.naira,
                                          color: AppColors.darkGreen,
                                          height: 25,
                                          width: 25,
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: TextStyles.textHeadings(
                                                textValue: !isMoneyBlocked
                                                    ? balance
                                                    : "*****",
                                                textColor: theme.isDark
                                                    ? AppColors
                                                        .darkModeBackgroundMainTextColor
                                                    : AppColors
                                                        .sendToAmountTxtColor,
                                                textSize: 24)
                                            // Text(
                                            //
                                            //   !isMoneyBlocked? balance:"*****",
                                            //   //widget.amountTransferred,
                                            //   style: TextStyle(
                                            //     color: theme.isDark
                                            //         ? AppColors
                                            //         .darkModeBackgroundMainTextColor
                                            //         : AppColors.sendToAmountTxtColor,
                                            //     fontSize: 24.0,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            ),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              isMoneyBlocked = !isMoneyBlocked;
                                            });
                                            await SharedPref.putBool(
                                                SharedPrefKey.isMoneyBlockedKey,
                                                isMoneyBlocked);
                                            print(
                                                'Saved isMoneyBlocked: $isMoneyBlocked');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Icon(
                                                isMoneyBlocked
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: theme.isDark
                                                    ? AppColors.white
                                                    : AppColors.black,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )

                                // const AppSpacer(
                                //   height: 30.0,
                                // ),
                                // Expanded(
                                //   child: SingleChildScrollView(
                                //     child: SendMainFormWidget(
                                //       balance: balance,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        },
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       color: theme.isDark
                      //           ? AppColors.darkModeBackgroundColor
                      //           : AppColors.white,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: Center(
                      //       child: SvgPicture.asset(
                      //         'assets/icons/sendBeneficiary/back.svg',
                      //         color: theme.isDark ? AppColors.white : null,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              // if (isTellaTrustTxn && userForTxnConfirmed)
              //   Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const AppSpacer(
              //         height: 10.0,
              //       ),
              //       Align(
              //         alignment: AlignmentDirectional.topCenter,
              //         child: Container(
              //           height: 7,
              //           width: 80,
              //           decoration: BoxDecoration(
              //             color:theme.isDark?AppColors.darkModeBackgroundContainerColor:  AppColors.sendStrokeColor,
              //             borderRadius: BorderRadius.circular(
              //               5.0,
              //             ),
              //           ),
              //         ),
              //       ),
              //       const AppSpacer(
              //         height: 30.0,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 15.0,
              //           vertical: 20.0,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Container(
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 10.0,
              //                 vertical: 7.0,
              //               ),
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(
              //                   10.0,
              //                 ),
              //                 color: AppColors.sendToDetailsLabelSendBgColor,
              //               ),
              //               child:  Center(
              //                 child: Text(
              //                   'SEND TO',
              //                   style: TextStyle(
              //                     color:
              //                     theme.isDark?AppColors.darkModeBackgroundMainTextColor: AppColors.sendToDetailsLabelSendTxtColor,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                   textAlign: TextAlign.center,
              //                 ),
              //               ),
              //             ),
              //             Expanded(
              //               child: Align(
              //                 alignment: AlignmentDirectional.topEnd,
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     Container(
              //                       height: 40,
              //                       width: 40,
              //                       decoration: BoxDecoration(
              //                         shape: BoxShape.circle,
              //                         image: txnMadeToImage.isNotEmpty
              //                             ? DecorationImage(
              //                                 image: NetworkImage(
              //                                   txnMadeToImage,
              //                                 ),
              //                               )
              //                             : null,
              //                       ),
              //                     ),
              //                     Text(
              //                       txnMadeToName,
              //                       style:  TextStyle(
              //                         color:
              //                         theme.isDark?AppColors.darkModeBackgroundMainTextColor: AppColors.sendToAmountTxtColor,
              //
              //                         fontSize: 16.0,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
            ],
          ),
        ),
        const AppSpacer(
          height: 15.0,
        ),
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: Container(
            height: 7,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.sendStrokeColor,
              borderRadius: BorderRadius.circular(
                5.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            print(controller.text);
            if(balance!='0'){
            var enteredAmount = '0';
            enteredAmount = await modalSheet.showMaterialModalBottomSheet(
                  backgroundColor: theme.isDark
                      ? AppColors.darkModeBackgroundColor
                      : AppColors.white,
                  // isDismissible: false,
                  // enableDrag: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                  ),
                  context: context,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: BlocProvider(
                        create: (context) => SendBloc(),
                        child: SingleChildScrollView(
                            child: SendMainFormWidget(
                          balance: balance,
                          previousAmtInputed: controller.text,
                        )),
                      )),
                ) ??
                '0';

            print(enteredAmount);
            if (enteredAmount != '0') {
              setState(() {
                controller.text = enteredAmount;
                //onChanged: (value) {
                widget
                    .onAmountChanged(enteredAmount); // Notify the parent widget
                // },
                //widget.amountTransferred = enteredAmount;
              });
            } else {}
          }},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomTextFormField(
              controller: controller,
              hint: 'Enter amount',
              label: 'Amount',
              enabled: false,
              widget: SvgPicture.asset(
                AppIcons.naira,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
