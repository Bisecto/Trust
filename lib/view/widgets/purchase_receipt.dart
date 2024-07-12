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
  Item item;

  TransactionReceipt({super.key, required this.item});

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
              child: SingleChildScrollView(
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
                                          color: AppColors.textColor2,
                                          width: 2)),
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
                            text: widget.item.order.product.name,
                            size: 12,
                            color: AppColors.textColor2,
                          ),

                          CustomText(
                            text: 'N${widget.item.amount}',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: widget
                                    .item.order.requiredFields.phoneNumber,
                                size: 14,
                                color: AppColors.black,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    AppUtils().copyToClipboard(
                                        widget.item.order.requiredFields
                                            .phoneNumber,
                                        context);
                                  },
                                  child: SvgPicture.asset(AppIcons.copy2))
                            ],
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
                            text: widget.item.description,
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
                            color: AppColors.textColor2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:
                                    AppUtils.deviceScreenSize(context).width /
                                        1.5,
                                child: CustomText(
                                  text: widget.item.reference,
                                  size: 14,
                                  color: AppColors.black,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    AppUtils().copyToClipboard(
                                        widget.item.order.requiredFields
                                            .phoneNumber,
                                        context);
                                  },
                                  child: SvgPicture.asset(AppIcons.copy2))
                            ],
                          ),
                          SizedBox(height: 12),
                          CustomText(
                            text: 'Status',
                            size: 12,
                            color: AppColors.textColor2,
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
                          onTap: () {
                            pdfShare(context,widget.item.description);
                          },
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
                          onTap: () {                            pdfDownload(context,widget.item.description);
                          },
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
                    SizedBox(height: 50),
                    CustomText(
                      text: 'Thank You!',
                      textAlign: TextAlign.center,
                      size: 14,
                      //: Text//(fontSize: 16, color: Colors.grey),
                    ),
                    CustomText(
                      text: 'For Your Purchase',
                      textAlign: TextAlign.center,
                      size: 14,
                      //: Text//(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          color: AppColors.green,
                        ),
                        CustomText(
                          text: 'Secured by TellaTrust',
                          textAlign: TextAlign.center,
                          size: 14,
                          //: Text//(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
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

  Future<void> pdfShare(
      BuildContext context, String title) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (storageStatus == PermissionStatus.granted) {
      isSharingPdf = true;
      //stateSetter(() {});
      var freeSpace = await DiskSpace.getFreeDiskSpace;
      if (freeSpace != null && freeSpace > 10.00) {
        await screenshotController
            .capture(delay: const Duration(milliseconds: 5))
            .then((Uint8List? image) async {
          if (image != null) {
            // Download PDF
            var path = await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);

            final imagePath =
                await File('$path/${title + getCurrentDate()}.png').create();
            await imagePath.writeAsBytes(image);

            // Read image data
            final Uint8List imageData = File(imagePath.path).readAsBytesSync();
            // Load the image using PdfBitmap
            final PdfBitmap pdfBitmap = PdfBitmap(imageData);

            // Create a new PDF document
            final PdfDocument document = PdfDocument();

            // Add a page and draw the image
            document.pages
                .add()
                .graphics
                .drawImage(pdfBitmap, const Rect.fromLTWH(0, 20, 500, 500));

            // Save the document
            var pdfPath = '$path/${title + getCurrentDate()}.pdf';
            await File(pdfPath).writeAsBytes(await document.save());

            // Dispose the document
            document.dispose();

            // Delete the temporary image file
            final targetFile = File(imagePath.path);
            if (targetFile.existsSync()) {
              targetFile.deleteSync(recursive: true);
              print('Image file deleted.');
            }

            await Future.delayed(Duration.zero);

            // Share the PDF file
            await Share.shareXFiles([
              XFile(pdfPath,
                  mimeType: 'application/pdf',
                  name: '${title + getCurrentDate()}.pdf')
            ]);

            // Delete shared file
            final targetFile2 = File(pdfPath);
            if (targetFile2.existsSync()) {
              targetFile2.deleteSync(recursive: true);
              print('PDF file deleted.');
            }

            isSharingPdf = false;
            //stateSetter(() {});
          }
        });
      } else {
        isSharingPdf = false;
        //stateSetter(() {});
        showToast(
            context: context,
            title: 'Error occurred',
            subtitle: 'Inadequate space on disk',
            type: ToastMessageType.error);
      }
    } else {
      isSharingPdf = false;
      //stateSetter(() {});
      showToast(
          context: context,
          title: "Permission required",
          subtitle: 'Permission was denied',
          type: ToastMessageType.info);
    }
  }

  

  Future<void> pdfDownload(
      BuildContext context, String title,) async {
    try {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      final storageStatus = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
      if (storageStatus == PermissionStatus.granted) {
        isDownloadingPdf = true;

        var freeSpace = await DiskSpace.getFreeDiskSpace;
        if (freeSpace != null && freeSpace > 10.00) {
          await screenshotController
              .capture(delay: const Duration(milliseconds: 5))
              .then((Uint8List? image) async {
            if (image != null) {
              // Prepare the file paths
              var path = await ExternalPath.getExternalStoragePublicDirectory(
                  ExternalPath.DIRECTORY_DOWNLOADS);

              final imagePath =
                  await File('$path/${title + getCurrentDate()}.png').create();
              await imagePath.writeAsBytes(image);

              // Read image data
              final Uint8List imageData =
                  File(imagePath.path).readAsBytesSync();
              // Load the image using PdfBitmap
              final PdfBitmap pdfBitmap = PdfBitmap(imageData);

              // Create a new PDF document
              final PdfDocument document = PdfDocument();

              // Add a page and draw the image
              document.pages
                  .add()
                  .graphics
                  .drawImage(pdfBitmap, const Rect.fromLTWH(0, 20, 500, 500));

              // Save the document
              var pdfPath = '$path/${title + getCurrentDate()}.pdf';
              await File(pdfPath).writeAsBytes(await document.save());

              // Dispose of the document
              document.dispose();

              // Delete the temporary image file
              final targetFile = File(imagePath.path);
              if (targetFile.existsSync()) {
                targetFile.deleteSync(recursive: true);
                print('Image file deleted.');
              }

              isDownloadingPdf = false;
              showToast(
                  context: context,
                  title: 'Download Successful',
                  subtitle: 'View PDF in downloads',
                  type: ToastMessageType.success);
            }
          });
        } else {
          isDownloadingPdf = false;
          showToast(
              context: context,
              title: 'Error occurred',
              subtitle: 'Inadequate space on disk',
              type: ToastMessageType.error);
        }
      } else {
        isDownloadingPdf = false;
        showToast(
            context: context,
            title: "Permission required",
            subtitle: 'Permission was denied',
            type: ToastMessageType.info);
      }
    } catch (e) {
      isDownloadingPdf = false;
      print(e.toString());
      showToast(
          context: context,
          title: 'Error occurred',
          subtitle: 'An unexpected error has occurred, try again later',
          type: ToastMessageType.error);
    }
  }
}
