import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_spacer.dart';

import '../../../../utills/custom_theme.dart';

class SendToHeaderWidget extends StatelessWidget {
  final String amountTransferred;
  final String txnMadeToName;
  final String txnMadeToImage;
  final bool isTellaTrustTxn;
  final bool userForTxnConfirmed;

  const SendToHeaderWidget({
    super.key,
    required this.amountTransferred,
    required this.txnMadeToName,
    required this.txnMadeToImage,
    required this.isTellaTrustTxn,
    required this.userForTxnConfirmed,
  });

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
                        theme.isDark?
                        'assets/images/sendToBgHeader.png':
                        'assets/images/sendToBgHeaderLightMode.png',
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
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundColor
                                : AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/sendBeneficiary/back.svg',
                              color: theme.isDark ? AppColors.white : null,
                            ),
                          ),
                        ),
                      ),
                      const AppSpacer(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  ? AppColors.darkModeBackgroundContainerColor
                                  : AppColors.sendToAmountBgColor,
                            ),
                            child: Center(
                              child: Text(
                                'AMOUNT',
                                style: TextStyle(
                                  color: theme.isDark
                                      ? AppColors
                                          .darkModeBackgroundMainTextColor
                                      : AppColors.sendToAmountTxtColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Text(
                                amountTransferred,
                                style: TextStyle(
                                  color: theme.isDark
                                      ? AppColors
                                          .darkModeBackgroundMainTextColor
                                      : AppColors.sendToAmountTxtColor,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
      ],
    );
  }
}
