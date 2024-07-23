
import '../model/quick_access_model.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'app_images.dart';

class AppList {

  final List<Services> serviceItems = [
    Services("Airtime", AppIcons.airtime, AppColors.lightShadowGreenColor),
    Services("Data", AppIcons.data, AppColors.lightShadowAmber),
    Services("Cable TV", AppIcons.cable, AppColors.greyAccent),
    Services("Internet", AppIcons.internet, AppColors.greyAccent),
    Services("Electricity", AppIcons.electricity, AppColors.lightShadowPurple),
    Services("Betting", AppIcons.betting, AppColors.lightShadowAmber),
    Services("Gift Card", AppIcons.giftCard, AppColors.lightShadowGreenColor),
    Services("Flights", AppIcons.flight, AppColors.greyAccent),
    Services("Tickets", AppIcons.ticket, AppColors.lightShadowGreenColor),
    Services(
        "Airtime To Cash", AppIcons.conversion, AppColors.lightShadowPurple),
  ];
  final List<String> networkProviders = ["MTN", "Airtel", "9mobile", "Glo"];
  final List<String> networkProvidersImages = [
    AppImages.mtn,
    AppImages.airtel,
    AppImages.mobile,
    AppImages.glo
  ];
  final List<String> dataPlanList = [
    "5GB Weekly Plan for 7 Days\nN1,500.00",
    "66GB Weekly Plan for 7 Days\nN1,500.00",
    "7GB Weekly Plan for 7 Days\nN1,500.00",
    "8GB Weekly Plan for 7 Days\nN1,500.00",
    "9GB Weekly Plan for 7 Days\nN1,500.00",
    "10GB Weekly Plan for 7 Days\nN1,500.00",
  ];
}
