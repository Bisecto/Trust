import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/bloc/product_bloc/product_bloc.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/constants/loading_dialog.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime_purchase/airtime.dart';
import 'package:teller_trust/view/the_app_screens/sevices/airtime_to_cash_purchase/airtime_to_cash.dart';
import 'package:teller_trust/view/the_app_screens/sevices/cable_purchase/cable_purchase.dart';
import 'package:teller_trust/view/the_app_screens/sevices/data_purchase/data.dart';
import 'package:teller_trust/view/the_app_screens/sevices/electricity_purchase/electricity_purchase.dart';

import '../../bloc/app_bloc/app_bloc.dart';
import '../../model/category_model.dart';
import '../../res/app_colors.dart';
import '../../res/app_icons.dart';
import '../../utills/app_utils.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../widgets/app_custom_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

import '../widgets/show_toast.dart';

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
          backgroundColor: theme.isDark
              ? AppColors.darkModeBackgroundColor
              : AppColors.white,
          title: CustomText(
            text: "Services",
            size: 18,
            weight: FontWeight.bold,
            color: !theme.isDark
                ? AppColors.darkModeBackgroundColor
                : AppColors.white,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(AppIcons.notification),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  if (state is SuccessState) {
                    var walletInfo = state.customerProfile.walletInfo;
                    return Container(
                        //height: 210,
                        child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is CategorySuccessState) {
                          CategoryModel categoryModel = state.categoryModel;
                          List<Category> items = categoryModel.data.categories;
                          //Use user data here
                          return SizedBox(
                            height: 300,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
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
                                        selectedAction =
                                            items[index].name.toLowerCase();
                                      });
                                      switch (selectedAction) {
                                        case "airtime":
                                          modalSheet
                                              .showMaterialModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0)),
                                            ),
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100.0),
                                              child: AirtimePurchase(
                                                category: items[index],
                                                walletInfo: walletInfo,
                                              ),
                                            ),
                                          );
                                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                                          //     services: AppList().serviceItems[index]));
                                          return;
                                        case "airtime to cash":
                                          modalSheet
                                              .showMaterialModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0)),
                                            ),
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100.0),
                                              child: AirtimeToCash(
                                                category: items[index],
                                                walletInfo: walletInfo,
                                              ),
                                            ),
                                          );
                                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                                          //     services: AppList().serviceItems[index]));
                                          return;
                                        case "data":
                                          modalSheet
                                              .showMaterialModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0)),
                                            ),
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100.0),
                                              child: DataPurchase(
                                                category: items[index],
                                                walletInfo: walletInfo,
                                              ),
                                            ),
                                          );
                                          // AppNavigator.pushAndStackPage(context, page: DataPurchase(
                                          //     services: AppList().serviceItems[index]));
                                          return;
                                        case "electricity":
                                          modalSheet
                                              .showMaterialModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0)),
                                            ),
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100.0),
                                              child: ElectricityPurchase(
                                                category: items[index],
                                                walletInfo: walletInfo,
                                              ),
                                            ),
                                          );
                                          // AppNavigator.pushAndStackPage(context, page: AirtimePurchase(
                                          //     services: AppList().serviceItems[index]));
                                          return;
                                        case 'cable tv':
                                          modalSheet
                                              .showMaterialModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0)),
                                            ),
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100.0),
                                              child: CablePurchase(
                                                category: items[index],
                                                walletInfo: walletInfo,
                                              ),
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
                                        default:
                                          showToast(
                                              context: context,
                                              title: 'Info',
                                              subtitle:
                                                  'Oops! It looks like this service is still in the oven. We\'re baking up something great, so stay tuned! 🍰',
                                              type: ToastMessageType.info);
                                      }

                                      //showAirtimeModal(context, AppList().serviceItems[index]);
                                    },
                                    child: gridItem(
                                        items[index],
                                        theme,
                                        [
                                          'airtime',
                                          'data',
                                          'electricity',
                                          'cable tv',
                                          'airtime to cash'
                                        ].contains(
                                            items[index].name.toLowerCase())));
                              },
                            ),
                          );
                        } else {
                          return const CustomText(
                            text: "",
                            size: 15,
                            weight: FontWeight.bold,
                            color: AppColors.white,
                          ); // Show loading indicator or handle error state
                        }
                      },
                    ));
                  } else {
                    return const LoadingDialog(
                        ''); // Show loading indicator or handle error state
                  }
                },
              ),
              advertWidget(theme),
            ],
          ),
        ));
  }

  Widget gridItem(Category category, AdaptiveThemeMode theme, isPending) {
    return Column(
      children: [
        CircleAvatar(
          //radius: 24,
          //backgroundColor: service.backgroundColor,

          backgroundImage: NetworkImage(category.image),
          child: Align(
              alignment: Alignment.bottomRight,
              child: !isPending
                  ? const Icon(
                      Icons.access_time_outlined,
                      size: 10,
                      color: AppColors.yellow,
                    )
                  : const SizedBox()),
        ),
        const SizedBox(
          height: 5,
        ),
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

  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  final GlobalKey _sliderKey = GlobalKey();
  final List<String> advertImages = [
    AppImages.billCard1,
    AppImages.billCard2,
    AppImages.billCard3,
  ];

  Widget advertWidget(AdaptiveThemeMode theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: SizedBox(
        height: 250,
        child: CarouselSlider.builder(
          key: _sliderKey,
          unlimitedMode: true,
          autoSliderDelay: const Duration(seconds: 3),
          enableAutoSlider: true,
          controller: carouselSliderController,
          slideBuilder: (index) {
            return Center(
              child: SizedBox(
                height: 250,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: AppUtils.deviceScreenSize(context).width,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(advertImages[index]),
                        // Replace with your actual image file path
                        fit: BoxFit
                            .cover, // You can adjust the fit property to cover, contain, or others
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          slideTransform: const CubeTransform(),
          slideIndicator: SequentialFillIndicator(
            indicatorRadius: 5,
            itemSpacing: 20,

            // alignment: Alignment.topCenter,
            indicatorBackgroundColor: AppColors.grey,
            currentIndicatorColor: AppColors.green,
            padding: const EdgeInsets.only(bottom: 0),
          ),
          itemCount: advertImages.length,
          onSlideEnd: () {
            print("ended");
          },
        ),
      ),
    );
  }
}
