import 'package:flutter/material.dart';
import 'package:teller_trust/repository/app_repository.dart';
import 'package:teller_trust/res/apis.dart';
import 'package:teller_trust/utills/app_navigator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../res/app_colors.dart';
import '../../../../model/quickpay_model.dart';
import '../../../../utills/shared_preferences.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/purchase_receipt.dart';
import '../purchase_receipt.dart';

class MakePayment extends StatefulWidget {
  final QuickPayModel quickPayModel;
  final String accessToken;

  MakePayment({
    Key? key,
    required this.quickPayModel,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  late WebViewController _webViewController;
  var loadingPercentage = 0;

  late String htmlString;

  void performGetRequest(
    String apiUrl,
  ) async {
    AppRepository appRepository = AppRepository();
    // String accessToken = await SharedPref.getString("access-token");
    var response = await appRepository.appGetRequest(
      apiUrl,
      accessToken: widget.accessToken,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Request completed with status code: ${response.statusCode}');
      print(
          'Request completed with status code: ${json.decode(response.body)}');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String status = responseData['data']['status'];

      if (status.toLowerCase() == 'pending') {
        print('Transaction status is pending. Retrying...');
        // Recursive call to retry the request
        performGetRequest(
          apiUrl,
        );
      } else {
        print('Request completed with status: $status');
      }

      //AppNavigator.pushAndStackPage(context, page: TransactionReceiptScreen());
    } else {
      print(
          'Request failed with status code: ${response.statusCode}. Retrying...');
      performGetRequest(
        apiUrl,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    performGetRequest(
        '${AppApis.appBaseUrl}/c/pay/conclude-checkout/${widget.quickPayModel.referenceCode}');
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
          // Call your API directly when payment is confirmed
          fetchPaymentCompletion();
        }
      });
    };

    function fetchPaymentCompletion() {
      fetch("https://api.tellatrust.com/c/pay/conclude-checkout/${widget.quickPayModel.referenceCode}", {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': '${widget.accessToken}', // Pass accessToken here
        },
      })
      .then(response => {
        if (response.ok) {
          return response.json(); // Parse response as JSON
        } else {
          throw new Error('Network response was not ok.');
        }
      })
      .then(data => {
        // Handle the response data as needed
        console.log('API Response:', data);
      })
      .catch(error => {
        console.error('Error fetching data:', error);
      });
    }

    payWithSafeHaven(); // Automatically trigger the payment on page load
  </script>
</body>
</html>
    """;
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
          WebView(
            initialUrl: '',
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              _loadHtmlFromAssets();
            },
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }

  void _loadHtmlFromAssets() {
    _webViewController.loadUrl(Uri.dataFromString(htmlString,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
