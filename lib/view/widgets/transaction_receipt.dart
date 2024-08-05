import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/sevices/card_request.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:disk_space_update/disk_space_update.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:teller_trust/model/transactionHistory.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/the_app_screens/landing_page.dart';
import 'package:teller_trust/view/widgets/form_button.dart';
import 'package:teller_trust/view/widgets/show_toast.dart';

import '../../repository/app_repository.dart';
import '../../res/apis.dart';
import '../../res/app_colors.dart';
import '../../utills/constants/loading_dialog.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../../utills/shared_preferences.dart';
import 'app_custom_text.dart';
import '../../model/transactionHistory.dart';
import '../../res/app_icons.dart';
import '../../res/app_images.dart';
import '../../utills/custom_theme.dart';
import '../widgets/form_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;

class TransactionReceipt extends StatefulWidget {
  final Transaction transaction;
  final bool isHome;

  TransactionReceipt(
      {super.key, required this.transaction, this.isHome = false});

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  bool isSharingPdf = false;
  ScreenshotController screenshotController = ScreenshotController();
  PdfDocument? document = PdfDocument();

  @override
  void initState() {
    // TODO: implement initState
    print(widget.transaction.toJson());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
      body: Container(
        height: AppUtils.deviceScreenSize(context).height,
        width: AppUtils.deviceScreenSize(context).width,
        color:
            theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 140,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF3FFEB),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: SvgPicture.asset(
                  AppIcons.looper1,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                    child: cardTopContainer(theme),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildReceiptDetails(theme),
                          Container(
                            height: 400,
                            color: theme.isDark
                                ? AppColors.darkModeBackgroundContainerColor
                                : Color(0xffF3FFEB),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                if (!isSharingPdf)
                                  buildActionButtons(
                                    widget.transaction.description,
                                    theme,
                                  ),
                                if (!isSharingPdf && widget.isHome)
                                  FormButton(
                                    onPressed: () {
                                      AppNavigator.pushAndRemovePreviousPages(
                                          context,
                                          page: LandingPage());
                                    },
                                    width: AppUtils.deviceScreenSize(context)
                                            .width /
                                        2,
                                    text: 'Homepage',
                                    iconWidget: Icons.arrow_forward,
                                    textColor: AppColors.white,
                                    isIcon: true,
                                    borderRadius: 20,
                                    bgColor: AppColors.green,
                                  ),
                                const SizedBox(height: 20),
                                buildFooter(
                                  theme,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardTopContainer(theme) {
    return SizedBox(
      height: 100,
      width: AppUtils.deviceScreenSize(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
          ),
          Column(
            children: [
              SvgPicture.asset(
                AppIcons.logoReceipt,
              ),
              SizedBox(
                height: 5,
              ),
              TextStyles.textHeadings(textValue: 'TellaTrust',textColor: AppColors.white),
              const CustomText(
                text: 'Transaction Receipt',
                color: AppColors.white,
              ),
            ],
          ),
          if (isSharingPdf)
            CircleAvatar(
              backgroundColor: Colors.transparent,
            ),
          if (!isSharingPdf)
            GestureDetector(
              onTap: () {
                if (widget.isHome) {
                  AppNavigator.pushAndRemovePreviousPages(context,
                      page: LandingPage());
                } else {
                  Navigator.pop(context);
                }
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      theme.isDark ? Brightness.light : Brightness.dark,
                ));
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset(AppIcons.cancel2),
              ),
            )
        ],
      ),
    );
  }

  Widget buildReceiptDetails(theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0), topRight: Radius.circular(0)),
        // boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow('Amount', theme, 'N${widget.transaction.amount}'),
          buildDetailRow(
            'Product Name',
            theme,
            widget.transaction.order?.product?.name ??
                (widget.transaction.type.toLowerCase().contains('credit')
                    ? 'Credit'
                    : 'Debit'),
          ),
          buildDetailRow('Amount', theme, 'N${widget.transaction.amount}'),
          if (widget.transaction.order != null) const SizedBox(height: 12),
          if (widget.transaction.order != null)
            buildDetailRow(
                'To',
                theme,
                widget.transaction.order?.requiredFields.meterNumber ??
                    widget.transaction.order?.requiredFields.cardNumber ??
                    widget.transaction.order?.requiredFields.phoneNumber ??
                    '',
                true),
          const SizedBox(height: 12),
          buildDetailRow('Description', theme, widget.transaction.description),
          if (widget.transaction.order?.response?.utilityToken != null &&
              widget.transaction.order!.response!.utilityToken.isNotEmpty &&
              widget.transaction.status.toLowerCase() == 'success') ...[
            const SizedBox(height: 12),
            buildDetailRow(
              'Utility Token',
              theme,
              widget.transaction.order!.response!.utilityToken,
              true,
            ),
          ],
          const SizedBox(height: 12),
          buildDetailRow(
              'Date',
              theme,
              AppUtils.formateSimpleDate(
                  dateTime: widget.transaction.createdAt.toString())),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          buildDetailRow('Transaction Reference', theme,
              widget.transaction.reference, true),
          const SizedBox(height: 12),
          buildDetailRow(
              'Status',
              theme,
              widget.transaction.status.toLowerCase() == 'success'
                  ? "SUCCESSFUL"
                  : widget.transaction.status.toUpperCase()),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, theme, String value,
      [bool isCopyable = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, size: 12, color: AppColors.textColor2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width:
                  //isCopyable

                  // ?
                  AppUtils.deviceScreenSize(context).width / 1.5,

              //  : null,
              child: CustomText(
                text: value,
                size: 14,
                color: theme.isDark ? AppColors.white : AppColors.black,
                maxLines: 2,
              ),
            ),
            if (isCopyable)
              if (!isSharingPdf)
                GestureDetector(
                  onTap: () {
                    AppUtils().copyToClipboard(value, context);
                  },
                  child: SvgPicture.asset(AppIcons.copy2),
                ),
          ],
        ),
      ],
    );
  }

  Widget buildActionButtons(String title, theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            pdfShare(context, title);
          },
          child: buildActionButton(
            'Share',
            AppIcons.send,
            pdfShare,
            theme,
          ),
        ),
        GestureDetector(
          onTap: () {
            pdfDownload(context, title);
          },
          child: buildActionButton(
            'Download',
            AppIcons.download,
            pdfDownload,
            theme,
          ),
        ),
        if (widget.transaction.status.toLowerCase() == 'success')
          GestureDetector(
            onTap: () {
              repeatTransaction(context, widget.transaction.id);
            },
            child: buildActionButton(
              'Repeat',
              AppIcons.reload,
              repeatTransaction,
              theme,
            ),
          ),
        buildActionButton(
          'Report',
          AppIcons.infoOutlined,
          () {},
          theme,
        ),
      ],
    );
  }

  Widget buildActionButton(String label, String icon, Function onTap, theme) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: theme.isDark
                ? AppColors.darkModeBackgroundColor
                : AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SvgPicture.asset(icon, color: AppColors.green),
          ),
        ),
        const SizedBox(height: 5),
        TextStyles.textSubHeadings(
            textValue: label, textColor: AppColors.green, textSize: 12),
        // CustomText(
        //   text: label,
        //   size: 13,
        //   color: AppColors.darkGreen,
        //   weight: FontWeight.bold,
        // ),
      ],
    );
  }

  Widget buildFooter(theme) {
    return Column(
      children: [
        TextStyles.textHeadings(
            textValue: 'Thank You!',
            textSize: 14,
            textColor: theme.isDark ? AppColors.white : AppColors.textColor2),
        // const CustomText(
        //   text: 'Thank You!',
        //   textAlign: TextAlign.center,
        //   size: 14,
        // ),
        CustomText(
          text: 'For Your Purchase',
          textAlign: TextAlign.center,
          color: theme.isDark ? AppColors.white : AppColors.textColor2,
          size: 14,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, color: AppColors.green),
            TextStyles.textHeadings(
                textValue: 'Secured by TellaTrust',
                textSize: 14,
                textColor: AppColors.textColor2),
          ],
        ),
      ],
    );
  }

  String getCurrentDate() {
    return DateFormat('_yyyyMMdd_kkmmss').format(DateTime.now());
  }

  Future<void> pdfShare(BuildContext context, String title) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const LoadingDialog('Preparing to share...'),
    );
    print(1);
    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
print(2);
    if (storageStatus == PermissionStatus.granted) {
      setState(() {
        isSharingPdf = true;
      });
print(3);
      var freeSpace = await DiskSpace.getFreeDiskSpace;
      if (freeSpace != null && freeSpace > 10.00) {
        print(4);
        await screenshotController
            .capture(delay: const Duration(milliseconds: 5))
            .then((Uint8List? image) async {
          if (image != null) {
            var path = await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);
            print(5);

            // Ensure directory exists
            final directory = Directory(path);
            if (!directory.existsSync()) {
              directory.createSync(recursive: true);
              print(6);

            }
            print(7);

            final imagePath =
                await File('$path/${title + getCurrentDate()}.png')
                    .create(recursive: true);
            await imagePath.writeAsBytes(image);
            print(8);

            final Uint8List imageData = File(imagePath.path).readAsBytesSync();
            final PdfBitmap pdfBitmap = PdfBitmap(imageData);
            print(9);

            final PdfDocument document = PdfDocument();
            final PdfPage page = document.pages.add();
            final Size pageSize = page.getClientSize();
            page.graphics.drawImage(pdfBitmap,
                Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

            var pdfPath = '$path/${title + getCurrentDate()}.pdf';
            await File(pdfPath).writeAsBytes(await document.save());
            document.dispose();

            final targetFile = File(imagePath.path);
            if (targetFile.existsSync()) {
              targetFile.deleteSync(recursive: true);
            }

            await Share.shareXFiles([
              XFile(pdfPath,
                  mimeType: 'application/pdf',
                  name: '${title + getCurrentDate()}.pdf')
            ]);

            final targetFile2 = File(pdfPath);
            if (targetFile2.existsSync()) {
              targetFile2.deleteSync(recursive: true);
            }

            setState(() {
              Navigator.pop(context);
              isSharingPdf = false;
            });
          }
        });
      } else {
        Navigator.pop(context);
        setState(() {
          isSharingPdf = false;
        });
        showToast(
          context: context,
          title: 'Error occurred',
          subtitle: 'Inadequate space on disk',
          type: ToastMessageType.error,
        );
      }
    } else {
      Navigator.pop(context);
      setState(() {
        isSharingPdf = false;
      });
      showToast(
        context: context,
        title: "Permission required",
        subtitle: 'Permission was denied',
        type: ToastMessageType.info,
      );
    }
  }

  Future<void> repeatTransaction(
      BuildContext context, String transactionId) async {
    AppRepository appRepository = AppRepository();

    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => const LoadingDialog('Preparing to repeat...'),
      );
      String accessToken = await SharedPref.getString("access-token");

      var response = await appRepository.appGetRequest(
          accessToken: accessToken,
          "${AppApis.getOneTransactionDetails}/$transactionId");
      print(response.statusCode);
      print(response.body);
      print(json.decode(response.body));
    } catch (e) {
      setState(() {
        isSharingPdf = false;
        Navigator.pop(context);
      });
      showToast(
        context: context,
        title: 'Error occurred',
        subtitle: 'An unexpected error has occurred, try again later',
        type: ToastMessageType.error,
      );
    }
  }

  Future<void> pdfDownload(BuildContext context, String title) async {
    try {
      setState(() {
        isSharingPdf = true;
      });
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => const LoadingDialog('Preparing to download...'),
      );
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      final storageStatus = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
      if (storageStatus == PermissionStatus.granted) {
        setState(() {
          isSharingPdf = true;
        });

        var freeSpace = await DiskSpace.getFreeDiskSpace;
        if (freeSpace != null && freeSpace > 10.00) {
          await screenshotController
              .capture(delay: const Duration(milliseconds: 5))
              .then((Uint8List? image) async {
            if (image != null) {
              var path = await ExternalPath.getExternalStoragePublicDirectory(
                  ExternalPath.DIRECTORY_DOWNLOADS);

              final imagePath =
                  await File('$path/${title + getCurrentDate()}.png').create();
              await imagePath.writeAsBytes(image);

              final Uint8List imageData =
                  File(imagePath.path).readAsBytesSync();
              final PdfBitmap pdfBitmap = PdfBitmap(imageData);

              final PdfDocument document = PdfDocument();
              final PdfPage page = document.pages.add();
              final Size pageSize = page.getClientSize();
              page.graphics.drawImage(pdfBitmap,
                  Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

              var pdfPath = '$path/${title + getCurrentDate()}.pdf';
              await File(pdfPath).writeAsBytes(await document.save());
              document.dispose();

              final targetFile = File(imagePath.path);
              if (targetFile.existsSync()) {
                targetFile.deleteSync(recursive: true);
              }

              setState(() {
                isSharingPdf = false;
                Navigator.pop(context);
              });
              showToast(
                context: context,
                title: 'Download Successful',
                subtitle: 'View PDF in downloads',
                type: ToastMessageType.success,
              );
            }
          });
        } else {
          setState(() {
            isSharingPdf = false;
            Navigator.pop(context);
          });
          showToast(
            context: context,
            title: 'Error occurred',
            subtitle: 'Inadequate space on disk',
            type: ToastMessageType.error,
          );
        }
      } else {
        setState(() {
          isSharingPdf = false;
          Navigator.pop(context);
        });
        showToast(
          context: context,
          title: "Permission required",
          subtitle: 'Permission was denied',
          type: ToastMessageType.info,
        );
      }
    } catch (e) {
      setState(() {
        isSharingPdf = false;
        Navigator.pop(context);
      });
      showToast(
        context: context,
        title: 'Error occurred',
        subtitle: 'An unexpected error has occurred, try again later',
        type: ToastMessageType.error,
      );
    }
  }
}
