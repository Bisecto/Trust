import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class AddFunds extends StatefulWidget {
  const AddFunds({super.key});

  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: AppUtils.deviceScreenSize(context).height - 100,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
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
                  decoration: BoxDecoration(
                      color: AppColors.white,
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
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset(
                    AppIcons.moneyTfInfo,
                    height: 50,
                    width: AppUtils.deviceScreenSize(context).width,
                  ),
                ),

                infoContainer("Account Name", "Tella Trust/Ayodele Ajiri"),
                infoContainer("Account Number", "3054339045"),
                infoContainer("Bank Name", "Wema Bank")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoContainer(name, detail) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
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
                ),
                CustomText(
                  text: detail,
                  color: AppColors.black,
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                AppUtils().copyToClipboard(detail,context);
                Navigator.pop(context);


              },
                child: SvgPicture.asset(AppIcons.copy))
          ],
        ),
      ),
    );
  }
}
