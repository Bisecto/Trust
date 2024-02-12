import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime.dart';
import 'package:teller_trust/view/the_app_screens/sevices/data.dart';
import 'package:teller_trust/view/the_app_screens/sevices/internet.dart';

import '../../model/quick_access_model.dart';
import '../../res/app_colors.dart';
import '../../res/app_icons.dart';
import '../../res/app_list.dart';
import '../../utills/app_utils.dart';
import '../widgets/app_custom_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: CustomText(
          text: "Services",
          size: 18,
          weight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(AppIcons.notification),
          )
        ],
      ),
      body: Container(
        //height: 210,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: AppList().serviceItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      modalSheet.showMaterialModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: AirtimePurchase(
                              services: AppList().serviceItems[index]),
                        ),
                      );
                      // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                      //     services: AppList().serviceItems[index]));
                      return;
                    case 1:
                      modalSheet.showMaterialModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: DataPurchase(
                              services: AppList().serviceItems[index]),
                        ),
                      );
                      // AppNavigator.pushAndStackPage(context, page: DataPurchase(
                      //     services: AppList().serviceItems[index]));
                      return;
                    case 3:
                      modalSheet.showMaterialModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: InternetPurchase(
                              services: AppList().serviceItems[index]),
                        ),
                      );
                      // AppNavigator.pushAndStackPage(context, page: InternetPurchase(
                      //     services: AppList().serviceItems[index]));
                      return;
                  }

                  //showAirtimeModal(context, AppList().serviceItems[index]);
                },
                child: gridItem(AppList().serviceItems[index]));
          },
        ),
      ),
    );
  }

  Widget gridItem(Services service) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: service.backgroundColor,
          child: SvgPicture.asset(service.image),
        ),
        SizedBox(
          height: 10,
        ),
        CustomText(
          text: service.title,
          color: AppColors.black,
          size: 15,
        )
      ],
    );
  }
}
