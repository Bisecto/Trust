import 'package:flutter/material.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/res/apis.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:teller_trust/view/the_app_screens/sevices/payment_receipt.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

import '../../../../../res/app_colors.dart';
import '../../../../model/quick_pay_transaction_history.dart';
import '../../../../model/quickpay_model.dart';
import '../../../widgets/app_custom_text.dart';

class MakePayment extends StatefulWidget {
  final QuickPayModel quickPayModel;
  final String accessToken;

  const MakePayment({
    Key? key,
    required this.quickPayModel,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
 // late final WebViewController _webViewController;
  var loadingPercentage = 0;
  bool isLoading = true;

  late String htmlString;

  void performGetRequest(String apiUrl) async {
    AppRepository appRepository = AppRepository();
    var response = await appRepository.appGetRequest(
      apiUrl,
      accessToken: widget.accessToken,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Request completed with status code: ${response.statusCode}');
      print('Request completed with status code: ${json.decode(response.body)}');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String status = responseData['data']['status'];

      if (status.toLowerCase() == 'pending' || status.toLowerCase() == 'failed') {
        print('Transaction status is pending. Retrying...');
        performGetRequest(apiUrl);
      } else {
        print('Request completed with status: $status');
        PaymentReceipt paymentReceipt = PaymentReceipt.fromJson(jsonDecode(response.body));
        AppNavigator.pushAndStackPage(context, page: Receipt(paymentReceipt: paymentReceipt));
      }
    } else {
      print('Request failed with status code: ${response.statusCode}. Retrying...');
      performGetRequest(apiUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    // Generate the HTML string with data from quickPayModel
    htmlString = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SafeHaven Checkout</title>
</head>
<body>
  <div class="container">
    <!-- Your content here -->
  </div>

  <script src="https://checkout.safehavenmfb.com/assets/checkout.min.js"></script>
  <script type="text/javascript">
    let payWithSafeHaven = () => {
      console.log("payWithSafeHaven called");
      let checkOut = SafeHavenCheckout({
        environment: "${widget.quickPayModel.environment}",
        clientId: "${widget.quickPayModel.clientId}",
        referenceCode: "${widget.quickPayModel.referenceCode}",
        customer: {
          firstName: "${widget.quickPayModel.customer.firstName}",
          lastName: "${widget.quickPayModel.customer.lastName}",
          emailAddress: "${widget.quickPayModel.customer.emailAddress}",
          phoneNumber: "${widget.quickPayModel.customer.phoneNumber}"
        },
        currency: "${widget.quickPayModel.currency}",
        amount: ${widget.quickPayModel.amount},
        settlementAccount: {
          bankCode: "090286",
          accountNumber: "${widget.quickPayModel.settlementAccount.accountNumber}"
        },
        customIconUrl: "https://tellatrust-assets.s3.eu-west-2.amazonaws.com/tellalogo.png",
        webhookUrl: "${widget.quickPayModel.webhookUrl}",
        onClose: () => { 
          console.log("Checkout Closed");
        },
        callback: (response) => { 
          console.log(response);
          window.flutter_inappwebview?.callHandler?.('paymentCompleted', response) || window.Flutter.postMessage(JSON.stringify(response));
        }
      });
    };

    payWithSafeHaven(); // Automatically trigger the payment on page load
  </script>
</body>
</html>
    """;

    // Initialize WebViewController in a more modern way
    // _webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onPageStarted: (String url) {
    //         setState(() {
    //           isLoading = true;
    //         });
    //       },
    //       onPageFinished: (String url) {
    //         setState(() {
    //           isLoading = false;
    //         });
    //         print('Page finished loading: $url');
    //       },
    //       onProgress: (int progress) {
    //         setState(() {
    //           loadingPercentage = progress;
    //         });
    //       },
    //     ),
    //   )
    //   ..addJavaScriptChannel(
    //     'Flutter',
    //     onMessageReceived: (JavaScriptMessage message) {
    //       String apiUrl = "${AppApis.appBaseUrl}/c/pay/conclude-checkout/${widget.quickPayModel.referenceCode}";
    //       performGetRequest(apiUrl);
    //     },
    //   )
    //   ..loadHtmlString(htmlString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.darkGreen,
        title: const CustomText(
          text: 'Quick pay',
          color: AppColors.white,
          size: 16,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
         // WebViewWidget(controller: _webViewController),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}