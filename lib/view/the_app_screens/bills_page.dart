import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime.dart';
import 'package:teller_trust/view/the_app_screens/sevices/data.dart';
import 'package:teller_trust/view/the_app_screens/sevices/internet.dart';

import '../../model/category_model.dart';
import '../../model/quick_access_model.dart';
import '../../res/app_colors.dart';
import '../../res/app_icons.dart';
import '../../res/app_list.dart';
import '../../utills/app_utils.dart';
import '../../utills/custom_theme.dart';
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
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      appBar: AppBar(
        backgroundColor: theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
        title:  CustomText(
          text: "Services",
          size: 18,
          weight: FontWeight.bold,
          color: !theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
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
          child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is CategorySuccessState) {
            CategoryModel categoryModel = state.categoryModel;
            List<Category> items = categoryModel.data.categories;
            //Use user data here
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      String selectedAction = '';
                      setState(() {
                        selectedAction = items[index].name;
                      });
                      switch (selectedAction) {
                        case "Airtime":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: AirtimePurchase(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case "Data":
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: DataPurchase(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: DataPurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        case 'Cable TV':
                          modalSheet.showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0)),
                            ),
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: InternetPurchase(category: items[index]),
                            ),
                          );
                          // AppNavigator.pushAndStackPage(context, page: InternetPurchase(
                          //     services: AppList().serviceItems[index]));
                          return;
                        // case 'Electricity':
                        //   modalSheet.showMaterialModalBottomSheet(
                        //     backgroundColor: Colors.transparent,
                        //     shape: const RoundedRectangleBorder(
                        //       borderRadius:
                        //           BorderRadius.vertical(top: Radius.circular(20.0)),
                        //     ),
                        //     context: context,
                        //     builder: (context) => Padding(
                        //       padding: const EdgeInsets.only(top: 100.0),
                        //       child: Electricity(
                        //           services: AppList().serviceItems[index]),
                        //     ),
                        //   );
                        //   // AppNavigator.pushAndStackPage(context, page: InternetPurchase(
                        //   //     services: AppList().serviceItems[index]));
                        //   return;
                      }

                      //showAirtimeModal(context, AppList().serviceItems[index]);
                    },
                    child: gridItem(items[index],theme));
              },
            );
          } else {
            return const CustomText(
              text: "There",
              size: 15,
              weight: FontWeight.bold,
              color: AppColors.white,
            ); // Show loading indicator or handle error state
          }
        },
      )),
    );
  }

  Widget gridItem(Category category, AdaptiveThemeMode theme) {
    return Column(
      children: [
        CircleAvatar(
          //radius: 24,
          //backgroundColor: service.backgroundColor,

          child: Image.network(category.image,),
        ),
        const SizedBox(height: 5,),
        CustomText(
          text: category.name,
          color: theme.isDark
              ? AppColors.darkModeBackgroundSubTextColor
              : AppColors.textColor,
          size: 12,
        )
      ],
    );
  }
}
