import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/model/quick_pay_transaction_history.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../widgets/app_custom_text.dart';

class Receipt extends StatefulWidget {
  PaymentReceipt paymentReceipt;

  Receipt({super.key, required this.paymentReceipt});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xF4FCE3).withOpacity(1),
                const Color(0xFFE4AB).withOpacity(1),
                //const Color(0xC2F6AE).withOpacity(1),
                const Color(0xC2F6AE).withOpacity(1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.textColor2, width: 2)),
                              child: Center(
                                  child: CustomText(
                                text: "x",
                                weight: FontWeight.bold,
                                color: AppColors.textColor2,
                              )),
                            ),
                          )
                        ],
                      ),
                      SvgPicture.asset(AppIcons.logoReceipt),
                      CustomText(
                        text: 'Transaction Receipt',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.paymentReceipt.data.description,
                        size: 12,
                        color: AppColors.textColor2,
                      ),

                      CustomText(
                        text: 'N${widget.paymentReceipt.data.amount}',
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CustomText(
                        text: 'To',
                        size: 12,
                        color: AppColors.textColor2,
                      ),
                      CustomText(
                        text: widget.paymentReceipt.data.order.requiredFields
                            .phoneNumber,
                        size: 14,
                        color: AppColors.black,
                      ),
                      // SizedBox(height: 12),
                      // CustomText(
                      //   text: 'Payment Method',
                      //   size: 12,
                      //   color: AppColors.textColor2,
                      // ),
                      // CustomText(
                      //   text: 'Wallet Balance',
                      //   size: 14,
                      //   color: AppColors.black,
                      // ),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Description',
                        size: 12,
                        color: AppColors.textColor2,
                      ),
                      CustomText(
                        text: widget.paymentReceipt.data.description,
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Date',
                        size: 12,
                        color: AppColors.textColor2,
                      ),
                      CustomText(
                        text: widget.paymentReceipt.data.createdAt.toString(),
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Transaction Reference',
                        size: 12,
                        color: AppColors.textColor2,
                      ),
                      CustomText(
                        text: widget.paymentReceipt.data.reference,
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Status',
                        size: 12,
                        color: AppColors.textColor2,
                      ),
                      CustomText(
                        text: widget.paymentReceipt.data.status.toUpperCase(),
                        size: 14,
                        color: AppColors.black,
                      ),
                      // SizedBox(height: 12),
                      // CustomText(
                      //   text: 'Session ID',
                      //   size: 12,
                      //   color: AppColors.textColor2,
                      // ),
                      // CustomText(
                      //   text: '47240240248745340248480280',
                      //   size: 14,
                      //   color: AppColors.black,
                      // ),
                      SizedBox(height: 20),
                      Center(
                          child: TextStyles.textHeadings(
                              textValue: 'Tellatrust',
                              textColor: AppColors.textColor2)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xffF3FFEB),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: SvgPicture.asset(
                              AppIcons.send,
                              color: AppColors.darkGreen,
                            )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            text: "Share",
                            size: 12,
                            color: AppColors.darkGreen,
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xffF3FFEB),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: SvgPicture.asset(
                              AppIcons.download,
                              color: AppColors.darkGreen,
                            )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            text: "Download",
                            size: 12,
                            color: AppColors.darkGreen,
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xffF3FFEB),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: SvgPicture.asset(
                              AppIcons.reload,
                              color: AppColors.darkGreen,
                            )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            text: "Repeat",
                            size: 12,
                            color: AppColors.darkGreen,
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xffF3FFEB),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: SvgPicture.asset(
                              AppIcons.infoOutlined,
                              color: AppColors.darkGreen,
                            )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            text: "Report",
                            size: 12,
                            color: AppColors.darkGreen,
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0),
                CustomText(
                  text: 'Thank You!',
                  textAlign: TextAlign.center,
                  size: 14,
                  //: Text//(fontSize: 16, color: Colors.grey),
                ),
                CustomText(
                  text: 'For Your Purchase',
                  textAlign: TextAlign.center,
                  size: 12,
                  //: Text//(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                CustomText(
                  text: 'Secured by Tella Trust',
                  textAlign: TextAlign.center,
                  size: 14,
                  //: Text//(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          )),
    );
  }
}
