import 'dart:convert';
import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:teller_trust/res/apis.dart';
import 'package:teller_trust/res/app_colors.dart';
import 'package:teller_trust/res/app_images.dart';
import 'package:teller_trust/utills/app_utils.dart';
import 'package:teller_trust/view/widgets/app_custom_text.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teller_trust/model/transactionHistory.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/the_app_screens/landing_page.dart';
import 'package:teller_trust/view/widgets/form_button.dart';
import 'package:teller_trust/view/widgets/show_toast.dart';
import '../../bloc/product_bloc/product_bloc.dart';
import '../../repository/app_repository.dart';
import '../../res/sharedpref_key.dart';
import '../../utills/constants/loading_dialog.dart';
import '../../utills/custom_theme.dart';
import '../../utills/enums/toast_mesage.dart';
import '../../utills/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../auth/otp_pin_pages/confirm_with_otp.dart';
import '../auth/sign_in_with_access_pin_and_biometrics.dart';
import '../important_pages/dialog_box.dart';
import '../the_app_screens/sevices/build_payment_method.dart';
import '../the_app_screens/sevices/make_bank_transfer/bank_transfer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/pdf.dart' as pdfColo;
import 'package:pdf/widgets.dart' as pw;

class TransactionReceipt extends StatefulWidget {
  Transaction transaction;
  final bool isHome;

  TransactionReceipt(
      {super.key, required this.transaction, this.isHome = false});

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  bool isSharingPdf = false;
  ProductBloc purchaseProductBloc = ProductBloc();

  @override
  void initState() {
    // TODO: implement initState
    //_createAndSharePdf();
    getTransaction();
    print(widget.transaction.toJson());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.initState();
  }

  getTransaction() async {
    AppRepository appRepository = AppRepository();
    String accessToken =
        await SharedPref.getString(SharedPrefKey.accessTokenKey);

    var response = await appRepository.appGetRequest(
      '${AppApis.getOneTransactionDetails}/${widget.transaction.id}',
      accessToken: accessToken,
    );

    print(response.statusCode);
    print(response.body);
    //print(widget.transaction.);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Transaction transaction =
          Transaction.fromJson(json.decode(response.body)['data']);
      setState(() {
        widget.transaction = transaction;
      });
    } else {
      MSG.infoSnackBar(
          context, 'There was a problem fetching transactiondetails');
    }
  }

  Future<void> _shareOrDownloadPdf(
      Transaction transaction, bool isShare) async {
    // Create a new PDF document
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const LoadingDialog(''),
    );
    final pdf = pw.Document();

    // Load the necessary images
    final ByteData lockIconBytes = await rootBundle.load(AppImages.lockIcon);
    final Uint8List lockIconImage = lockIconBytes.buffer.asUint8List();

    final ByteData qrCodeBytes = await rootBundle.load(AppImages.qrCode);
    final Uint8List qrCodeImage = qrCodeBytes.buffer.asUint8List();
    // final ByteData receiptBgBytes = await rootBundle.load(AppImages.receiptBg);
    // final Uint8List receiptBg = receiptBgBytes.buffer.asUint8List();

    final ByteData logoBytes = await rootBundle.load(AppImages.receiptLogo);
    final Uint8List logoImage = logoBytes.buffer.asUint8List();

    // final ByteData looperBytes = await rootBundle.load(AppImages.looperImage);
    // final Uint8List looperImage = looperBytes.buffer.asUint8List();

    pdfColo.PdfColor lightGreen = const pdfColo.PdfColor.fromInt(0xffE3FAD6);
    // pdfColo.PdfColor mainAppColor = const pdfColo.PdfColor.fromInt(0xff185C32);

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        // pageFormat: PdfPageFormat.letter,
        pageFormat: const PdfPageFormat(
            8.5 * PdfPageFormat.inch, 12 * PdfPageFormat.inch,
            marginAll: 0),
        build: (pw.Context context) => pw.Container(
          width: context.page.pageFormat.width,
          height: context.page.pageFormat.height,
          //color: PdfColors.red,
          child: pw.Stack(
            children: [
              // pw.Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   child: pw.Container(
              //     height: 110,
              //     decoration: pw.BoxDecoration(
              //       color: PdfColors.white,
              //       borderRadius: const pw.BorderRadius.vertical(
              //         bottom: pw.Radius.circular(30),
              //       ),
              //     ),
              //   ),
              // ),
              // pw.Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   child: pw.Container(
              //     height: 100,
              //     decoration: const pw.BoxDecoration(
              //       color: PdfColors.green900,
              //       borderRadius: pw.BorderRadius.only(
              //         bottomLeft: pw.Radius.circular(20),
              //         bottomRight: pw.Radius.circular(20),
              //       ),
              //     ),
              //     child: pw.Image(
              //       pw.MemoryImage(looperImage),
              //
              //       fit: pw.BoxFit.fill,
              //     ),
              //   ),
              // ),
              pw.Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pdfCardTopContainer(logoImage),
                    pw.Expanded(
                      child: pw.Container(
                        color: lightGreen,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            //pw.SizedBox(height: 10),
                            // Pass the dynamic transaction to the receipt details
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(0),
                              child: pw.Container(
                                //color: PdfColors.white,
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.white,
                                  borderRadius: pw.BorderRadius.circular(0),
                                ),
                                child: pw.Padding(
                                    padding:
                                        pw.EdgeInsets.fromLTRB(20, 30, 20, 0),
                                    child: pw.Container(
                                        decoration: pw.BoxDecoration(
                                          color: PdfColors.white,
//                                           image: pw.DecorationImage(
//                                             image: pw.MemoryImage(receiptBg),
// //dpi: 10,
//                                             // Your background image here
//                                             fit: pw.BoxFit
//                                                 .fill, // Set how the background image will fit
//                                           ),
                                        ),
                                        child: pw.Row(
                                            mainAxisAlignment: pw
                                                .MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pdfBuildReceiptDetails(
                                                  transaction),
                                              pdfBuildReceiptDetails2(
                                                  transaction)
                                            ]))),
                              ),
                            ),

                            //pdfBuildReceiptDetails(transaction),
                            pw.Container(
                              color: lightGreen,
                              child: pw.Column(
                                children: [
                                  pw.SizedBox(height: 10),
                                  pdfBuildFooter(qrCodeImage, lockIconImage),
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
      ),
    );

    // Save and share the PDF

    //Platform check: Android or iOS
    if (Platform.isAndroid) {
      if (isShare) {
        // Sharing the PDF on Android
        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename:
              'TELLATRUST_TRANSACTION_${transaction.order?.product?.name ?? "${transaction.type.toLowerCase().contains('credit') ? 'Credit' : 'Debit'}_${transaction.reference}"}.pdf',
        );
        Navigator.pop(context);
      } else {
        // Save the PDF to Downloads folder on Android
        //var status = await Permission.storage.request();

        if (await _requestStoragePermission()) {
          // Get the Downloads folder path on Android
          if (Platform.isAndroid && await _isAndroid13OrAbove()) {
            Navigator.pop(context);
            await savePdfWithIntent(pdf,
                'TELLATRUST_TRANSACTION_${transaction.order?.product?.name ?? "${transaction.type.toLowerCase().contains('credit') ? 'Credit' : 'Debit'}_${transaction.reference}"}.pdf');
            showToast(
              context: context,
              title: 'Download Successful',
              subtitle: 'View PDF in downloads',
              type: ToastMessageType.success,
            );
          } else {
            Navigator.pop(context);
            final downloadsDirectory =
                Directory('/storage/emulated/0/Download');
            if (!downloadsDirectory.existsSync()) {
              downloadsDirectory.createSync();
            }

            final file = File(
                '${downloadsDirectory.path}/TELLATRUST_TRANSACTION_${transaction.order?.product?.name ?? "${transaction.type.toLowerCase().contains('credit') ? 'Credit' : 'Debit'}_${transaction.reference}"}.pdf');
            await file.writeAsBytes(await pdf.save());
            showToast(
              context: context,
              title: 'Download Successful',
              subtitle: 'View PDF in downloads',
              type: ToastMessageType.success,
            );
            print('PDF saved to ${file.path}');
          }
        } else {
          Navigator.pop(context);
          showToast(
            context: context,
            title: 'Permission Denied',
            subtitle: 'Permission to access storage denied',
            type: ToastMessageType.error,
          );
          print('Permission to access storage denied');
        }
      }
    } else if (Platform.isIOS) {
      // On iOS, save the PDF to the app's Documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/TELLATRUST_TRANSACTION_${transaction.order?.product?.name ?? "${transaction.type.toLowerCase().contains('credit') ? 'Credit' : 'Debit'}_${transaction.reference}"}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (isShare) {
        // Share the PDF on iOS
        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename:
              'TELLATRUST_TRANSACTION_${transaction.order?.product?.name ?? "${transaction.type.toLowerCase().contains('credit') ? 'Credit' : 'Debit'}_${transaction.reference}"}.pdf',
        );
        Navigator.pop(context);
      } else {
        showToast(
          context: context,
          title: 'Download Successful',
          subtitle: 'View PDF in downloads',
          type: ToastMessageType.success,
        );
        // Provide a message to the user about accessing the file in the app's directory
        print(
            'PDF saved to ${file.path} (in-app Documents folder). You can access it via the Files app.');
      }
    }
  }

  Future<void> savePdfWithIntent(pw.Document pdf, String fileName) async {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.CREATE_DOCUMENT',
      type: 'application/pdf',
      arguments: <String, dynamic>{
        'android.intent.extra.TITLE': '$fileName.pdf',
      },
    );
    await intent.launch();
  }

  Future<bool> _isAndroid13OrAbove() async {
    if (Platform.isAndroid) {
      final version = int.parse(Platform.version.split(' ')[0].split('.')[0]);
      return version >= 33; // Android 13 is API level 33+
    }
    return false;
  }

// Request storage permission for Android versions below Android 10
  Future<bool> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
      return false;
    }
  }

  pw.Widget pdfCardTopContainer(logoImage) {
    pdfColo.PdfColor mainAppColor = const pdfColo.PdfColor.fromInt(0xff185C32);

    return pw.Container(
      //height: 100,
      // width: context.page.pageFormat.width, // Full width
      color: mainAppColor,
      padding: pw.EdgeInsets.all(0),
      //color: PdfColors.white,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Column(
            children: [
              // pw.SizedBox(height: 10),

              pw.Image(pw.MemoryImage(logoImage),
                  //width: double.infinity,
                  //fit: pw.BoxFit.fill,
                  height: 50),
              //pw.SvgImage(svg: AppIcons.logoReceipt, height: 40),
              // Adjusted size
              pw.SizedBox(height: 10),
              pw.Text('TellaTrust',
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold)),
              pw.Text('Transaction Receipt',
                  style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

// Translated buildReceiptDetails for PDF
  pw.Widget pdfBuildReceiptDetails(Transaction transaction) {
    return pw.Container(
      //width: AppUtils.deviceScreenSize(context),
      padding: const pw.EdgeInsets.all(0),
      decoration: const pw.BoxDecoration(
        borderRadius: pw.BorderRadius.only(
          topLeft: pw.Radius.circular(0),
          topRight: pw.Radius.circular(0),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pdfBuildDetailRow('Amount', 'N${transaction.amount}'),
          if (transaction.payInfo == null)
            pdfBuildDetailRow(
              'Product Name',
              transaction.order?.product?.name ??
                  (transaction.type.toLowerCase().contains('credit')
                      ? 'Credit'
                      : 'Debit'),
            ),
          if (transaction.payInfo != null)
            pdfBuildDetailRow('Type', transaction.payInfo!.cardType),
          if (transaction.order != null) pw.SizedBox(height: 12),
          if (transaction.order != null &&
              (transaction.order?.requiredFields.meterNumber ??
                      transaction.order?.requiredFields.cardNumber ??
                      transaction.order?.requiredFields.phoneNumber ??
                      '')
                  .isNotEmpty) ...[
            pdfBuildDetailRow(
              'To',
              transaction.order?.requiredFields.meterNumber ??
                  transaction.order?.requiredFields.cardNumber ??
                  transaction.order?.requiredFields.phoneNumber ??
                  '',
            ),
          ],
          pdfBuildDetailRow('Description', transaction.description),
          if (transaction.order?.response?.utilityToken != null &&
              transaction.order!.response!.utilityToken.isNotEmpty &&
              transaction.status.toLowerCase() == 'success') ...[
            pw.SizedBox(height: 12),
            pdfBuildDetailRow(
              'Utility Token',
              transaction.order!.response!.utilityToken,
            ),
          ],
          pdfBuildDetailRow(
            'Date',
            AppUtils.formateSimpleDate(
              dateTime: transaction.createdAt.toString(),
            ),
          ),
          pdfBuildDetailRow('Transaction Reference', transaction.reference),
          pdfBuildDetailRow(
            'Status',
            transaction.status.toLowerCase() == 'success'
                ? "SUCCESSFUL"
                : transaction.status.toUpperCase(),
          ),
          if (transaction.payInfo != null) ...[
            pdfBuildDetailRow(
                'Sender Account Name', transaction.payInfo!.senderAccountName),
            pdfBuildDetailRow('Sender Bank',
                "${transaction.payInfo!.senderBank.split(' ')[0]} ${transaction.payInfo!.senderBank.split(' ')[1]}"),
            pdfBuildDetailRow(
                'Receiver Bank', transaction.payInfo!.receiverBank),
          ]
        ],
      ),
    );
  }

  pw.Widget pdfBuildReceiptDetails2(Transaction transaction) {
    return pw.Container(
      //width: AppUtils.deviceScreenSize(context),
      padding: const pw.EdgeInsets.all(0),
      decoration: const pw.BoxDecoration(
        borderRadius: pw.BorderRadius.only(
          topLeft: pw.Radius.circular(0),
          topRight: pw.Radius.circular(0),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (transaction.payInfo != null) ...[
            // pw.Divider(),
            //  pdfBuildDetailRow('PayInfo ID', transaction.payInfo!.id),
            //   pdfBuildDetailRow('Provider', transaction.payInfo!.provider),

            //   pdfBuildDetailRow('Channel', transaction.payInfo!.channel),
            pdfBuildDetailRow(
                'Paid At',
                transaction.payInfo!.paidAt != null
                    ? AppUtils.formateSimpleDate(
                        dateTime: transaction.payInfo!.paidAt!.toString())
                    : 'N/A'),
            //   pdfBuildDetailRow('Authorization Code', transaction.payInfo!.authorizationCode),
            pdfBuildDetailRow('Card Type', transaction.payInfo!.cardType),
          ],
        ],
      ),
    );
  }

//   pw.Widget pdfBuildReceiptDetails(Transaction transaction) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.all(0),
//       decoration: const pw.BoxDecoration(
//         //color: PdfColors.white,
//         borderRadius: pw.BorderRadius.only(
//           topLeft: pw.Radius.circular(0),
//           topRight: pw.Radius.circular(0),
//         ),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pdfBuildDetailRow('Amount', 'N${transaction.amount}'),
//           pdfBuildDetailRow(
//               'Product Name',
//               widget.transaction.order?.product?.name ??
//                   (widget.transaction.type.toLowerCase().contains('credit')
//                       ? 'Credit'
//                       : 'Debit')),
//           if (widget.transaction.order != null) pw.SizedBox(height: 12),
//           if (widget.transaction.order != null &&
//               (widget.transaction.order?.requiredFields.meterNumber ??
//                       widget.transaction.order?.requiredFields.cardNumber ??
//                       widget.transaction.order?.requiredFields.phoneNumber ??
//                       '')
//                   .isNotEmpty) ...[
//             pdfBuildDetailRow(
//                 'To',
//                 widget.transaction.order?.requiredFields.meterNumber ??
//                     widget.transaction.order?.requiredFields.cardNumber ??
//                     widget.transaction.order?.requiredFields.phoneNumber ??
//                     ''),
//           ],
//           // pdfBuildDetailRow(
//           //     'To', transaction.order?.requiredFields.meterNumber ?? 'N/A'),
//           pdfBuildDetailRow('Description', transaction.description),
//           if (widget.transaction.order?.response?.utilityToken != null &&
//               widget.transaction.order!.response!.utilityToken.isNotEmpty &&
//               widget.transaction.status.toLowerCase() == 'success') ...[
//             pw.SizedBox(height: 12),
//             pdfBuildDetailRow(
//               'Utility Token',
//               widget.transaction.order!.response!.utilityToken,
//             ),
//           ],
//           pdfBuildDetailRow(
//               'Date',
//               AppUtils.formateSimpleDate(
//                   dateTime: widget.transaction.createdAt.toString())),
//           //pw.Divider(),
//           pdfBuildDetailRow('Transaction Reference', transaction.reference),
//           pdfBuildDetailRow(
//               'Status',
//               widget.transaction.status.toLowerCase() == 'success'
//                   ? "SUCCESSFUL"
//                   : widget.transaction.status.toUpperCase()),
//           pw.SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

// Translated buildDetailRow for PDF
  pw.Widget pdfBuildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label,
              style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey)),
          pw.SizedBox(
            height: 3,
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.SizedBox(
                width: 200, // Limit width for wrapping text
                child: pw.Text(value, style: const pw.TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Translated buildFooter for PDF
  pw.Widget pdfBuildFooter(qrCodeImage, lockmage) {
    return pw.Column(
      children: [
        pw.Text('Thank You!',
            style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black)),
        pw.Text('For Your Purchase',
            style: const pw.TextStyle(fontSize: 16, color: PdfColors.black)),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Text(
              'Want to save money on transfers and recharge cards? Download TellaTrust today! Plus, enjoy a referral bonus when you share the love with your friends. Don\'t miss out!',
              style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey),
              textAlign: pw.TextAlign.center,
              maxLines: 2),
        ),
        // pw.SizedBox(height: 20),
        pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Image(pw.MemoryImage(qrCodeImage),
              //width: double.infinity,
              //fit: pw.BoxFit.fill,
              height: 100),
          pw.SizedBox(height: 10),
          pw.Text('Scan to Download App  ',
              style: const pw.TextStyle(fontSize: 14, color: PdfColors.black)),
        ]),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Image(
                pw.MemoryImage(
                  lockmage,
                ),
                height: 24,
                width: 24),
            pw.Text(' Secured by TellaTrust',
                style:
                    const pw.TextStyle(fontSize: 14, color: PdfColors.black)),
          ],
        ),
        //pw.SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor: theme.isDark
          ? AppColors.darkModeBackgroundColor
          : const Color(0xffF3FFEB),
      body: BlocConsumer<ProductBloc, ProductState>(
          bloc: purchaseProductBloc,
          listenWhen: (previous, current) => current is! ProductInitial,
          listener: (context, state) async {
            print(state);
            if (state is PurchaseSuccess) {
              // AppNavigator.pushAndStackPage(context,
              //     page: TransactionReceipt(
              //         transaction: state.transaction));

              showToast(
                  context: context,
                  title: 'Success',
                  subtitle: 'Purchase was successful',
                  type: ToastMessageType.info);
              //refresh();
              //MSG.snackBar(context, state.msg);

              // AppNavigator.pushAndRemovePreviousPages(context,
              //     page: LandingPage(studentProfile: state.studentProfile));
            } else if (state is QuickPayInitiated) {
              String accessToken =
                  await SharedPref.getString(SharedPrefKey.accessTokenKey);

              AppNavigator.pushAndStackPage(context,
                  page: MakePayment(
                    quickPayModel: state.quickPayModel,
                    accessToken: accessToken,
                  ));
            } else if (state is AccessTokenExpireState) {
              // showToast(
              //     context: context,
              //     title: 'Token expired',
              //     subtitle: 'Login again.',
              //     type: ToastMessageType.error);

              //MSG.warningSnackBar(context, state.error);

              String firstame =
                  await SharedPref.getString(SharedPrefKey.firstNameKey);

              AppNavigator.pushAndRemovePreviousPages(context,
                  page: SignInWIthAccessPinBiometrics(
                    userName: firstame,
                  ));
            } else if (state is PurchaseErrorState) {
              showToast(
                  context: context,
                  title: 'Info',
                  subtitle: state.error,
                  type: ToastMessageType.error);

              //MSG.warningSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            return Container(
              height: AppUtils.deviceScreenSize(context).height,
              width: AppUtils.deviceScreenSize(context).width,
              color: theme.isDark
                  ? AppColors.darkModeBackgroundColor
                  : const Color(0xffF3FFEB),
              child: SizedBox(
                width: double.maxFinite,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 130,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffF3FFEB),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30)),
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
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30)),
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
                                    //height: isSharingPdf ? 400 : 400,
                                    color: theme.isDark
                                        ? AppColors
                                            .darkModeBackgroundContainerColor
                                        : const Color(0xffF3FFEB),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (!isSharingPdf)
                                          buildActionButtons(
                                            widget.transaction.description,
                                            theme,
                                          ),
                                        if (!isSharingPdf && widget.isHome)
                                          FormButton(
                                            onPressed: () {
                                              AppNavigator
                                                  .pushAndRemovePreviousPages(
                                                      context,
                                                      page:
                                                          const LandingPage());
                                            },
                                            width: AppUtils.deviceScreenSize(
                                                        context)
                                                    .width /
                                                2,
                                            text: 'Homepage',
                                            iconWidget: Icons.arrow_forward,
                                            textColor: AppColors.white,
                                            isIcon: true,
                                            borderRadius: 20,
                                            bgColor: AppColors.green,
                                          ),
                                        const SizedBox(height: 10),
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
          }),
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
          const CircleAvatar(
            backgroundColor: Colors.transparent,
          ),
          Column(
            children: [
              SvgPicture.asset(
                AppIcons.logoReceipt,
              ),
              const SizedBox(
                height: 5,
              ),
              TextStyles.textHeadings(
                  textValue: 'TellaTrust', textColor: AppColors.white),
              const CustomText(
                text: 'Transaction Receipt',
                color: AppColors.white,
              ),
            ],
          ),
          if (!isSharingPdf)
            GestureDetector(
              onTap: () {
                if (widget.isHome) {
                  AppNavigator.pushAndRemovePreviousPages(context,
                      page: const LandingPage());
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
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0), topRight: Radius.circular(0)),
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
          // Additional Transfer Parameters from payInfo
          if (widget.transaction.payInfo != null) ...[
            //const SizedBox(height: 12),
            buildDetailRow(
                'Provider', theme, widget.transaction.payInfo!.provider),
            buildDetailRow(
                'Channel', theme, widget.transaction.payInfo!.channel),
            buildDetailRow('Sender Account', theme,
                widget.transaction.payInfo!.senderAccountName),
            buildDetailRow(
                'Sender Bank', theme, widget.transaction.payInfo!.senderBank),
            buildDetailRow('Receiver Account', theme,
                widget.transaction.payInfo!.receiverNuban),
            buildDetailRow('Receiver Bank', theme,
                widget.transaction.payInfo!.receiverBank),
            // buildDetailRow('Authorization Code', theme,
            //     widget.transaction.payInfo!.authorizationCode),
            buildDetailRow(
              'Transaction Status',
              theme,
              widget.transaction.payInfo!.status.toUpperCase(),
            ),
          ],

          // Transaction Metadata
          //const SizedBox(height: 12),
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
                : widget.transaction.status.toUpperCase(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget buildReceiptDetails(theme) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color:
  //           theme.isDark ? AppColors.darkModeBackgroundColor : AppColors.white,
  //       borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(0), topRight: Radius.circular(0)),
  //       // boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         buildDetailRow('Amount', theme, 'N${widget.transaction.amount}'),
  //         buildDetailRow(
  //           'Product Name',
  //           theme,
  //           widget.transaction.order?.product?.name ??
  //               (widget.transaction.type.toLowerCase().contains('credit')
  //                   ? 'Credit'
  //                   : 'Debit'),
  //         ),
  //         buildDetailRow('Amount', theme, 'N${widget.transaction.amount}'),
  //         if (widget.transaction.order != null) const SizedBox(height: 12),
  //         if (widget.transaction.order != null &&
  //             (widget.transaction.order?.requiredFields.meterNumber ??
  //                     widget.transaction.order?.requiredFields.cardNumber ??
  //                     widget.transaction.order?.requiredFields.phoneNumber ??
  //                     '')
  //                 .isNotEmpty) ...[
  //           buildDetailRow(
  //               'To',
  //               theme,
  //               widget.transaction.order?.requiredFields.meterNumber ??
  //                   widget.transaction.order?.requiredFields.cardNumber ??
  //                   widget.transaction.order?.requiredFields.phoneNumber ??
  //                   '',
  //               true),
  //           const SizedBox(height: 12),
  //         ],
  //         buildDetailRow('Description', theme, widget.transaction.description),
  //         if (widget.transaction.order?.response?.utilityToken != null &&
  //             widget.transaction.order!.response!.utilityToken.isNotEmpty &&
  //             widget.transaction.status.toLowerCase() == 'success') ...[
  //           const SizedBox(height: 12),
  //           buildDetailRow(
  //             'Utility Token',
  //             theme,
  //             widget.transaction.order!.response!.utilityToken,
  //             true,
  //           ),
  //         ],
  //         const SizedBox(height: 12),
  //         buildDetailRow(
  //             'Date',
  //             theme,
  //             AppUtils.formateSimpleDate(
  //                 dateTime: widget.transaction.createdAt.toString())),
  //         const SizedBox(height: 20),
  //         const Divider(),
  //         const SizedBox(height: 12),
  //         buildDetailRow('Transaction Reference', theme,
  //             widget.transaction.reference, true),
  //         const SizedBox(height: 12),
  //         buildDetailRow(
  //             'Status',
  //             theme,
  //             widget.transaction.status.toLowerCase() == 'success'
  //                 ? "SUCCESSFUL"
  //                 : widget.transaction.status.toUpperCase()),
  //         const SizedBox(height: 20),
  //       ],
  //     ),
  //   );
  // }

  Widget buildDetailRow(String label, theme, String value,
      [bool isCopyable = false]) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
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
      ),
    );
  }

  Widget buildActionButtons(String title, theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            _shareOrDownloadPdf(widget.transaction, true);
            //imageShare(context, title, theme);
          },
          child: buildActionButton(
            'Share',
            AppIcons.send,
            _shareOrDownloadPdf,
            theme,
          ),
        ),
        GestureDetector(
          onTap: () {
            _shareOrDownloadPdf(widget.transaction, false);

            //imageDownload(context, title);
          },
          child: buildActionButton(
            'Download',
            AppIcons.download,
            _shareOrDownloadPdf,
            theme,
          ),
        ),
        if (widget.transaction.status.toLowerCase() == 'success' &&
            widget.transaction.order != null)
          GestureDetector(
            onTap: () {
              // print(widget.transaction.order);
              repeatTransaction(context, widget.transaction, theme);
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
        if (isSharingPdf) ...[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomText(
              text: 'Want to save money on transfers and recharge cards? '
                  'Download TellaTrust today! Plus, enjoy a referral '
                  'bonus when you share the love with your friends.'
                  ' Don\'t miss out!',
              textAlign: TextAlign.center,
              color: theme.isDark ? AppColors.white : AppColors.textColor2,
              size: 14,
              maxLines: 5,
            ),
          ),
          TextStyles.textHeadings(
              textValue: 'Scan to Download App',
              textSize: 14,
              textColor: theme.isDark ? AppColors.white : AppColors.textColor2),
          SvgPicture.asset(AppIcons.appQrCode),
        ],
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, color: AppColors.green),
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

  String _selectedPaymentMethod = 'wallet';
  bool isPaymentAllowed = false;

  Future<void> repeatTransaction(
      BuildContext context, Transaction transaction, theme) async {
    AppRepository appRepository = AppRepository();
    bool isCancelled = false; // Flag to track if cancel icon was clicked

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: theme.isDark
                  ? AppColors.darkModeBackgroundColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      isCancelled = true; // Set the flag to true
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.cancel,
                          size: 30,
                        )),
                  ),
                  PaymentMethodScreen(
                    amtToPay: transaction.amount.toString(),
                    onPaymentMethodSelected: (method) {
                      Future.microtask(() {
                        if (mounted) {
                          setState(() {
                            _selectedPaymentMethod = method;
                          });
                        }
                      });
                    },
                    ispaymentAllowed: (allowed) {
                      Future.microtask(() {
                        if (mounted) {
                          setState(() {
                            isPaymentAllowed = allowed;
                          });
                        }
                      });
                    },
                  ),
                  FormButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Continue',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Check if the cancel icon was clicked, if so, stop further execution
    if (isCancelled) return;

    // Proceed to show the modal sheet for transaction pin
    var transactionPin = await modalSheet.showMaterialModalBottomSheet(
            backgroundColor: Colors.transparent,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            context: context,
            builder: (context) => Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: ConfirmWithPin(
                    context: context,
                    title: 'Input your transaction pin to continue',
                  ),
                )) ??
        '';

    // If the transaction pin is not empty, trigger the purchase event
    if (transactionPin != '') {
      purchaseProductBloc.add(PurchaseProductEvent(
          context,
          transaction.order!.requiredFields,
          transaction.order!.product!.id,
          transactionPin,
          _selectedPaymentMethod == 'wallet' ? false : true,
          false,
          ''));
    }
  }

// Future<void> pdfShare(BuildContext context, String title, theme) async {
//   final plugin = DeviceInfoPlugin();
//   final deviceInfo = await plugin.deviceInfo;
//   bool isAndroid = deviceInfo is AndroidDeviceInfo;
//
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (_) => const LoadingDialog('Preparing to share...'),
//   );
//
//   final storageStatus = isAndroid
//       ? deviceInfo.version.sdkInt < 33
//           ? (await Permission.storage.request())
//           : PermissionStatus.granted
//       : PermissionStatus.granted;
//   print(storageStatus);
//   if (storageStatus == PermissionStatus.granted) {
//     setState(() {
//       isSharingPdf = true;
//     });
//
//     var freeSpace = await DiskSpace.getFreeDiskSpace;
//     if (freeSpace != null && freeSpace > 10.00) {
//       try {
//         Uint8List? image = await screenshotController.capture(
//             delay: const Duration(milliseconds: 5));
//
//         if (image != null) {
//           var path = isAndroid
//               ? await ExternalPath.getExternalStoragePublicDirectory(
//                   ExternalPath.DIRECTORY_DOWNLOADS)
//               : (await getApplicationDocumentsDirectory()).path;
//
//           final directory = Directory(path);
//           if (!directory.existsSync()) {
//             directory.createSync(recursive: true);
//           }
//
//           final imagePath =
//               await File('$path/${title + getCurrentDate()}.png')
//                   .create(recursive: true);
//           await imagePath.writeAsBytes(image);
//
//           final Uint8List imageData = File(imagePath.path).readAsBytesSync();
//           final PdfBitmap pdfBitmap = PdfBitmap(imageData);
//
//           final PdfDocument document = PdfDocument();
//           final PdfPage page = document.pages.add();
//           final Size pageSize = page.getClientSize();
//
//           page.graphics.drawImage(pdfBitmap,
//               Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
//
//           var pdfPath = '$path/${title + getCurrentDate()}.pdf';
//           await File(pdfPath).writeAsBytes(await document.save());
//           document.dispose();
//
//           final targetFile = File(imagePath.path);
//           if (targetFile.existsSync()) {
//             targetFile.deleteSync(recursive: true);
//           }
//
//           await Share.shareXFiles([
//             XFile(pdfPath,
//                 mimeType: 'application/pdf',
//                 name: '${title + getCurrentDate()}.pdf')
//           ]);
//
//           final targetFile2 = File(pdfPath);
//           if (targetFile2.existsSync()) {
//             targetFile2.deleteSync(recursive: true);
//           }
//
//           setState(() {
//             Navigator.pop(context);
//             isSharingPdf = false;
//           });
//         } else {
//           setState(() {
//             Navigator.pop(context);
//             isSharingPdf = false;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           Navigator.pop(context);
//           isSharingPdf = false;
//         });
//         showToast(
//           context: context,
//           title: 'Error occurred',
//           subtitle: 'An error occurred while preparing the PDF',
//           type: ToastMessageType.error,
//         );
//       }
//     } else {
//       Navigator.pop(context);
//       setState(() {
//         isSharingPdf = false;
//       });
//       await Permission.storage.request();
//       // showToast(
//       //   context: context,
//       //   title: 'Error occurred',
//       //   subtitle: 'Inadequate space on disk',
//       //   type: ToastMessageType.error,
//       // );
//     }
//   } else {
//     Navigator.pop(context);
//     setState(() {
//       isSharingPdf = false;
//     });
//     await Permission.storage.request();
//     // showToast(
//     //   context: context,
//     //   title: "Permission required",
//     //   subtitle: 'Permission was denied',
//     //   type: ToastMessageType.info,
//     // );
//   }
// }
//
// Future<void> pdfDownload(BuildContext context, String title) async {
//   try {
//     setState(() {
//       isSharingPdf = true;
//     });
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (_) => const LoadingDialog('Preparing to download...'),
//     );
//
//     final plugin = DeviceInfoPlugin();
//     final deviceInfo = await plugin.deviceInfo;
//     bool isAndroid = deviceInfo is AndroidDeviceInfo;
//
//     final storageStatus = isAndroid
//         ? deviceInfo.version.sdkInt < 33
//             ? (await Permission.storage.request())
//             : PermissionStatus.granted
//         : PermissionStatus.granted;
//
//     if (storageStatus == PermissionStatus.granted) {
//       setState(() {
//         isSharingPdf = true;
//       });
//
//       var freeSpace = await DiskSpace.getFreeDiskSpace;
//       if (freeSpace != null && freeSpace > 10.00) {
//         try {
//           Uint8List? image = await screenshotController.capture(
//               delay: const Duration(milliseconds: 5));
//           if (image != null) {
//             var path = isAndroid
//                 ? await ExternalPath.getExternalStoragePublicDirectory(
//                     ExternalPath.DIRECTORY_DOWNLOADS)
//                 : (await getApplicationDocumentsDirectory()).path;
//
//             final directory = Directory(path);
//             if (!directory.existsSync()) {
//               directory.createSync(recursive: true);
//             }
//
//             final imagePath =
//                 await File('$path/${title + getCurrentDate()}.png')
//                     .create(recursive: true);
//             await imagePath.writeAsBytes(image);
//
//             final Uint8List imageData =
//                 File(imagePath.path).readAsBytesSync();
//             final PdfBitmap pdfBitmap = PdfBitmap(imageData);
//
//             final PdfDocument document = PdfDocument();
//             final PdfPage page = document.pages.add();
//             final Size pageSize = page.getClientSize();
//             page.graphics.drawImage(pdfBitmap,
//                 Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
//
//             var pdfPath = '$path/${title + getCurrentDate()}.pdf';
//             await File(pdfPath).writeAsBytes(await document.save());
//             document.dispose();
//
//             final targetFile = File(imagePath.path);
//             if (targetFile.existsSync()) {
//               targetFile.deleteSync(recursive: true);
//             }
//
//             setState(() {
//               isSharingPdf = false;
//               Navigator.pop(context);
//             });
//             showToast(
//               context: context,
//               title: 'Download Successful',
//               subtitle: 'View PDF in downloads',
//               type: ToastMessageType.success,
//             );
//           }
//         } catch (e) {
//           setState(() {
//             isSharingPdf = false;
//             Navigator.pop(context);
//           });
//           showToast(
//             context: context,
//             title: 'Error occurred',
//             subtitle: 'An error occurred while preparing the PDF',
//             type: ToastMessageType.error,
//           );
//         }
//       } else {
//         setState(() {
//           isSharingPdf = false;
//           Navigator.pop(context);
//         });
//         showToast(
//           context: context,
//           title: 'Error occurred',
//           subtitle: 'Inadequate space on disk',
//           type: ToastMessageType.error,
//         );
//       }
//     } else {
//       setState(() {
//         isSharingPdf = false;
//         Navigator.pop(context);
//       });
//       showToast(
//         context: context,
//         title: "Permission required",
//         subtitle: 'Permission was denied',
//         type: ToastMessageType.info,
//       );
//     }
//   } catch (e) {
//     setState(() {
//       isSharingPdf = false;
//       Navigator.pop(context);
//     });
//     showToast(
//       context: context,
//       title: 'Error occurred',
//       subtitle: 'An unexpected error has occurred, try again later',
//       type: ToastMessageType.error,
//     );
//   }
// }

// Future<void> imageShare(BuildContext context, String title, theme) async {
//   final plugin = DeviceInfoPlugin();
//   final deviceInfo = await plugin.deviceInfo;
//   bool isAndroid = deviceInfo is AndroidDeviceInfo;
//
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (_) => const LoadingDialog('Preparing to share...'),
//   );
//
//   final storageStatus = isAndroid
//       ? deviceInfo.version.sdkInt < 33
//           ? (await Permission.storage.request())
//           : PermissionStatus.granted
//       : PermissionStatus.granted;
//   print(storageStatus);
//   if (storageStatus == PermissionStatus.granted) {
//     setState(() {
//       isSharingPdf = true;
//     });
//
//     var freeSpace = await DiskSpace.getFreeDiskSpace;
//     if (freeSpace != null && freeSpace > 10.00) {
//       try {
//         Uint8List? image = await screenshotController.capture(
//             delay: const Duration(milliseconds: 5));
//
//         if (image != null) {
//           var path = isAndroid
//               ? await ExternalPath.getExternalStoragePublicDirectory(
//                   ExternalPath.DIRECTORY_DOWNLOADS)
//               : (await getApplicationDocumentsDirectory()).path;
//
//           final directory = Directory(path);
//           if (!directory.existsSync()) {
//             directory.createSync(recursive: true);
//           }
//
//           final imagePath =
//               await File('$path/${title + getCurrentDate()}.png')
//                   .create(recursive: true);
//           await imagePath.writeAsBytes(image);
//
//           await Share.shareXFiles([
//             XFile(imagePath.path,
//                 mimeType: 'image/png',
//                 name: '${title + getCurrentDate()}.png')
//           ]);
//
//           final targetFile = File(imagePath.path);
//           if (targetFile.existsSync()) {
//             targetFile.deleteSync(recursive: true);
//           }
//
//           setState(() {
//             Navigator.pop(context);
//             isSharingPdf = false;
//           });
//         } else {
//           setState(() {
//             Navigator.pop(context);
//             isSharingPdf = false;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           Navigator.pop(context);
//           isSharingPdf = false;
//         });
//         showToast(
//           context: context,
//           title: 'Error occurred',
//           subtitle: 'An error occurred while preparing the image',
//           type: ToastMessageType.error,
//         );
//       }
//     } else {
//       Navigator.pop(context);
//       setState(() {
//         isSharingPdf = false;
//       });
//       await Permission.storage.request();
//     }
//   } else {
//     Navigator.pop(context);
//     setState(() {
//       isSharingPdf = false;
//     });
//     await Permission.storage.request();
//   }
// }
//
// Future<void> imageDownload(BuildContext context, String title) async {
//   try {
//     setState(() {
//       isSharingPdf = true;
//     });
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (_) => const LoadingDialog('Preparing to download...'),
//     );
//
//     final plugin = DeviceInfoPlugin();
//     final deviceInfo = await plugin.deviceInfo;
//     bool isAndroid = deviceInfo is AndroidDeviceInfo;
//
//     final storageStatus = isAndroid
//         ? deviceInfo.version.sdkInt < 33
//             ? (await Permission.storage.request())
//             : PermissionStatus.granted
//         : PermissionStatus.granted;
//
//     if (storageStatus == PermissionStatus.granted) {
//       setState(() {
//         isSharingPdf = true;
//       });
//
//       var freeSpace = await DiskSpace.getFreeDiskSpace;
//       if (freeSpace != null && freeSpace > 10.00) {
//         try {
//           Uint8List? image = await screenshotController.capture(
//               delay: const Duration(milliseconds: 5));
//           if (image != null) {
//             var path = isAndroid
//                 ? await ExternalPath.getExternalStoragePublicDirectory(
//                     ExternalPath.DIRECTORY_DOWNLOADS)
//                 : (await getApplicationDocumentsDirectory()).path;
//
//             final directory = Directory(path);
//             if (!directory.existsSync()) {
//               directory.createSync(recursive: true);
//             }
//
//             final imagePath =
//                 await File('$path/${title + getCurrentDate()}.png')
//                     .create(recursive: true);
//             await imagePath.writeAsBytes(image);
//
//             setState(() {
//               isSharingPdf = false;
//               Navigator.pop(context);
//             });
//             showToast(
//               context: context,
//               title: 'Download Successful',
//               subtitle: 'View image in downloads',
//               type: ToastMessageType.success,
//             );
//           }
//         } catch (e) {
//           setState(() {
//             isSharingPdf = false;
//             Navigator.pop(context);
//           });
//           showToast(
//             context: context,
//             title: 'Error occurred',
//             subtitle: 'An error occurred while preparing the image',
//             type: ToastMessageType.error,
//           );
//         }
//       } else {
//         setState(() {
//           isSharingPdf = false;
//           Navigator.pop(context);
//         });
//         showToast(
//           context: context,
//           title: 'Error occurred',
//           subtitle: 'Inadequate space on disk',
//           type: ToastMessageType.error,
//         );
//       }
//     } else {
//       setState(() {
//         isSharingPdf = false;
//         Navigator.pop(context);
//       });
//       showToast(
//         context: context,
//         title: "Permission required",
//         subtitle: 'Permission was denied',
//         type: ToastMessageType.info,
//       );
//     }
//   } catch (e) {
//     setState(() {
//       isSharingPdf = false;
//       Navigator.pop(context);
//     });
//     showToast(
//       context: context,
//       title: 'Error occurred',
//       subtitle: 'An unexpected error has occurred, try again later',
//       type: ToastMessageType.error,
//     );
//   }
// }
}
