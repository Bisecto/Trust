import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../model/customer_account_model.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/app_custom_text.dart';

class AddFunds extends StatefulWidget {
  CustomerAccountModel? customerAccountModel;

  AddFunds({super.key, required this.customerAccountModel});

  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Container(
      height: AppUtils.deviceScreenSize(context).height,
      decoration: BoxDecoration(
          color: theme.isDark
              ? AppColors.darkModeBackgroundContainerColor
              : AppColors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   width: AppUtils.deviceScreenSize(context).width,
              //   height: 50,
              //   color: AppColors.darkGreen,
              //   child: const Padding(
              //     padding: EdgeInsets.all(15.0),
              //     child: Padding(
              //       padding: EdgeInsets.all(0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               // CustomText(
              //               //     text: orderNotification.customer,
              //               //     color: AppColors.white),
              //               // CustomText(
              //               //     text: orderNotification.size,
              //               //     color: AppColors.white)
              //             ],
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           // Container(
              //           //   height: 120,
              //           //   width: AppUtils.deviceScreenSize(context).width / 2,
              //           //   child: CustomText(
              //           //     text: orderNotification.location,
              //           //     color: AppColors.white,
              //           //     maxLines: 5,
              //           //   ),
              //           // )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  // color: !theme.isDark
                  //     ? AppColors.darkModeBackgroundContainerColor
                  //     : AppColors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppIcons.yourNgnAccount,
                        theme: const SvgTheme(
                          // currentColor: theme.isDark
                          //     ? AppColors.darkModeBackgroundColor
                          //     : AppColors.white
                        ),
                        // color: theme.isDark
                        //     ? AppColors.white
                        //     : AppColors.darkModeBackgroundMainTextColor,
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(AppIcons.cancel),
                      )
                    ],
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF3D5),
                        border: Border.all(color: const Color(0xFFFFBE62)),
                        // AppColors.lightOrange),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcons.info,height: 25,width: 25,),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width:AppUtils.deviceScreenSize(context).width/1.2,
                            child: const CustomText(
                              text:
                              "Money Transfers sent to this Bank account "
                                  "number will automatically top up your "
                                  "TellaTrust Wallet",
                              weight: FontWeight.bold,
                              maxLines: 3,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),

              infoContainer("Account Name",
                  widget.customerAccountModel!.dvaAccountName, theme),
              infoContainer("Account Number",
                  widget.customerAccountModel!.nuban, theme),
              infoContainer("Bank Name",
                  widget.customerAccountModel!.dvaBankName, theme)
            ],
          ),
        ),
      ),
    );
  }

  Widget infoContainer(name, detail, theme) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: name,
                    color: theme.isDark
                        ? AppColors.darkModeBackgroundMainTextColor
                        : AppColors.textColor),
                CustomText(
                  text: detail,
                  color: theme.isDark
                      ? AppColors.darkModeBackgroundMainTextColor
                      : AppColors.black,
                ),
              ],
            ),
            GestureDetector(
                onTap: () {
                  AppUtils().copyToClipboard(detail, context);

                  Navigator.pop(context);
                },
                child: SvgPicture.asset(AppIcons.copy))
          ],
        ),
      ),
    );
  }
}
