import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:disk_space/disk_space.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:teller_trust/model/transactionHistory.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/show_toast.dart';

import '../../res/app_colors.dart';
import '../../utills/enums/toast_mesage.dart';
import 'app_custom_text.dart';

class TransactionReceipt extends StatefulWidget {
  Transaction transaction;

  TransactionReceipt({super.key, required this.transaction});

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          height: AppUtils.deviceScreenSize(context).height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xF4FCE3).withOpacity(1),
                const Color(0xFFE4AB).withOpacity(1),
                const Color(0xC2F6AE).withOpacity(1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  buildHeader(context),
                  SizedBox(height: 20),
                  buildReceiptDetails(),
                  SizedBox(height: 20),
                  if(!isDownloadingPdf||!isSharingPdf)

                    buildActionButtons(widget.transaction.description),
                  SizedBox(height: 50),
                  buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(!isDownloadingPdf||!isSharingPdf)

                GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.textColor2, width: 2),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "x",
                      weight: FontWeight.bold,
                      color: AppColors.textColor2,
                    ),
                  ),
                ),
              )
            ],
          ),
          SvgPicture.asset(AppIcons.logoReceipt),
          CustomText(text: 'Transaction Receipt'),
        ],
      ),
    );
  }

  Widget buildReceiptDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow('Product Name',
              widget.transaction.order?.product.name ?? (widget.transaction.type
                  .toLowerCase()
                  .contains('credit')
                  ? 'Credit'
                  : 'Debit')),
          buildDetailRow('Amount', 'N${widget.transaction.amount}'),
          SizedBox(height: 12),
          buildDetailRow(
              'To',
              widget.transaction.order?.requiredFields.phoneNumber ??
                  '',
              true),
          SizedBox(height: 12),
          buildDetailRow('Description', widget.transaction.description),
          SizedBox(height: 12),
          buildDetailRow('Date', widget.transaction.createdAt.toString()),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 12),
          buildDetailRow('Transaction Reference', widget.transaction.reference,true),
          SizedBox(height: 12),
          buildDetailRow('Status', widget.transaction.status.toUpperCase()),
          SizedBox(height: 20),
          Center(
            child: TextStyles.textHeadings(
              textValue: 'Tellatrust',
              textColor: AppColors.textColor2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value, [bool isCopyable = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, size: 12, color: AppColors.textColor2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: isCopyable
                  ? AppUtils.deviceScreenSize(context).width / 1.5
                  : null,
              child: CustomText(
                text: value,
                size: 14,
                color: AppColors.black,
                maxLines: 2,
              ),
            ),
            if (isCopyable)
              if(!isDownloadingPdf||!isSharingPdf)
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

  Widget buildActionButtons(title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: (){
            pdfShare(context, title);
          },
            child: buildActionButton('Share', AppIcons.send, pdfShare)),
        GestureDetector( onTap: (){
          pdfDownload(context, title);
        },child: buildActionButton('Download', AppIcons.download, pdfDownload)),
        buildActionButton('Repeat', AppIcons.reload, () {}),
        buildActionButton('Report', AppIcons.infoOutlined, () {}),
      ],
    );
  }

  Widget buildActionButton(String label, String icon, Function onTap) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Color(0xffF3FFEB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SvgPicture.asset(icon, color: AppColors.darkGreen),
          ),
        ),
        SizedBox(height: 5),
        CustomText(
          text: label,
          size: 12,
          color: AppColors.darkGreen,
          weight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget buildFooter() {
    return Column(
      children: [
        if(!isDownloadingPdf||!isSharingPdf)
        CustomText(
          text: 'Thank You!',
          textAlign: TextAlign.center,
          size: 14,
        ),
        if(!isDownloadingPdf||!isSharingPdf)

          CustomText(
          text: 'For Your Purchase',
          textAlign: TextAlign.center,
          size: 14,
        ),
        if(!isDownloadingPdf||!isSharingPdf)

          SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, color: AppColors.green),
            CustomText(
              text: 'Secured by TellaTrust',
              textAlign: TextAlign.center,
              size: 14,
            ),
          ],
        ),
      ],
    );
  }

  getCurrentDate() {
    return DateFormat('_yyyyMMdd_kkmmss').format(DateTime.now());
  }

  bool isDownloadingPdf = false;
  bool isSharingPdf = false;
  ScreenshotController screenshotController = ScreenshotController();

  //Create a new PDF document.
  PdfDocument? document = PdfDocument();

  Future<void> pdfShare(BuildContext context, String title) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (storageStatus == PermissionStatus.granted) {
      setState(() {
        isSharingPdf = true;

      });      var freeSpace = await DiskSpace.getFreeDiskSpace;
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

            final Uint8List imageData = File(imagePath.path).readAsBytesSync();
            final PdfBitmap pdfBitmap = PdfBitmap(imageData);

            final PdfDocument document = PdfDocument();
            final PdfPage page = document.pages.add();

            // Get the page size
            final Size pageSize = page.getClientSize();

            // Draw the image to fill the whole page
            page.graphics.drawImage(pdfBitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

            var pdfPath = '$path/${title + getCurrentDate()}.pdf';
            await File(pdfPath).writeAsBytes(await document.save());
            document.dispose();

            final targetFile = File(imagePath.path);
            if (targetFile.existsSync()) {
              targetFile.deleteSync(recursive: true);
              print('Image file deleted.');
            }

            await Future.delayed(Duration.zero);

            await Share.shareXFiles([
              XFile(pdfPath,
                  mimeType: 'application/pdf',
                  name: '${title + getCurrentDate()}.pdf')
            ]);

            final targetFile2 = File(pdfPath);
            if (targetFile2.existsSync()) {
              targetFile2.deleteSync(recursive: true);
              print('PDF file deleted.');
            }

            setState(() {
              isSharingPdf = false;

            });          }
        });
      } else {
        setState(() {
          isSharingPdf = false;

        });        showToast(
            context: context,
            title: 'Error occurred',
            subtitle: 'Inadequate space on disk',
            type: ToastMessageType.error);
      }
    } else {
      setState(() {
        isSharingPdf = false;

      });
      showToast(
          context: context,
          title: "Permission required",
          subtitle: 'Permission was denied',
          type: ToastMessageType.info);
    }
  }

  Future<void> pdfDownload(
      BuildContext context,
      String title,
      ) async {
    try {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      final storageStatus = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
      if (storageStatus == PermissionStatus.granted) {
        setState(() {
          isDownloadingPdf = true;

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

              final Uint8List imageData = File(imagePath.path).readAsBytesSync();
              final PdfBitmap pdfBitmap = PdfBitmap(imageData);

              final PdfDocument document = PdfDocument();
              final PdfPage page = document.pages.add();

              // Get the page size
              final Size pageSize = page.getClientSize();

              // Draw the image to fill the whole page
              page.graphics.drawImage(pdfBitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

              var pdfPath = '$path/${title + getCurrentDate()}.pdf';
              await File(pdfPath).writeAsBytes(await document.save());
              document.dispose();

              final targetFile = File(imagePath.path);
              if (targetFile.existsSync()) {
                targetFile.deleteSync(recursive: true);
                print('Image file deleted.');
              }

              setState(() {
                isDownloadingPdf = false;

              });
              showToast(
                  context: context,
                  title: 'Download Successful',
                  subtitle: 'View PDF in downloads',
                  type: ToastMessageType.success);
            }
          });
        } else {
          setState(() {
            isDownloadingPdf = false;

          });
          showToast(
              context: context,
              title: 'Error occurred',
              subtitle: 'Inadequate space on disk',
              type: ToastMessageType.error);
        }
      } else {
        setState(() {
          isDownloadingPdf = false;

        });        showToast(
            context: context,
            title: "Permission required",
            subtitle: 'Permission was denied',
            type: ToastMessageType.info);
      }
    } catch (e) {
      setState(() {
        isDownloadingPdf = false;

      });      print(e.toString());
      showToast(
          context: context,
          title: 'Error occurred',
          subtitle: 'An unexpected error has occurred, try again later',
          type: ToastMessageType.error);
    }
  }

}
