import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/model/transactionHistory.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_images.dart';

import '../../res/app_colors.dart';
import 'app_custom_text.dart';

class TransactionReceipt extends StatefulWidget {
  Item item;
   TransactionReceipt({super.key,required this.item});

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xF4FCE3).withOpacity(1),
                const Color(0xFFE4AB).withOpacity(1),
                const Color(0xC2F6AE).withOpacity(1),
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
                        text: widget.item.order.product.name,
                        size: 12,
                        color: AppColors.textColor,
                      ),

                      CustomText(
                        text: 'N${widget.item.amount}',
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 12,),
                      CustomText(
                        text: 'To',
                        size: 12,
                        color: AppColors.textColor,
                      ),
                      CustomText(
                        text: widget.item.order.requiredFields.phoneNumber,
                        size: 14,
                        color: AppColors.black,
                      ),
                      // SizedBox(height: 12),
                      // CustomText(
                      //   text: 'Payment Method',
                      //   size: 12,
                      //   color: AppColors.textColor,
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
                        color: AppColors.textColor,
                      ),
                      CustomText(
                        text: widget.item.description,
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Date',
                        size: 12,
                        color: AppColors.textColor,
                      ),
                      CustomText(
                        text: widget.item.createdAt.toString(),
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Transaction Reference',
                        size: 12,
                        color: AppColors.textColor,
                      ),
                      CustomText(
                        text: widget.item.reference,
                        size: 14,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 12),
                      CustomText(
                        text: 'Status',
                        size: 12,
                        color: AppColors.textColor,
                      ),
                      CustomText(
                        text: widget.item.status.toUpperCase(),
                        size: 14,
                        color: AppColors.black,
                      ),
                      // SizedBox(height: 12),
                      // CustomText(
                      //   text: 'Session ID',
                      //   size: 12,
                      //   color: AppColors.textColor,
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
                              textColor: AppColors.textColor)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.green),
                      onPressed: () {
                        // Handle share action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.download, color: Colors.green),
                      onPressed: () {
                        // Handle download action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.green),
                      onPressed: () {
                        // Handle repeat action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.report, color: Colors.green),
                      onPressed: () {
                        // Handle report action
                      },
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
