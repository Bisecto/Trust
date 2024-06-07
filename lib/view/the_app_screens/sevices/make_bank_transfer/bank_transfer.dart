import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../res/app_colors.dart';
import '../../../widgets/app_custom_text.dart';

class MakePayment extends StatefulWidget {
  MakePayment({super.key});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  late final WebViewController _webViewController;
  var loadingPercentage = 0;

  String htmlString = """
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>SafeHaven Checkout Demo</title>
  </head>
  <body>
    <h1>Checkout Demo</h1>
    <button onclick="payWithSafeHaven()">Click Me!</button>
    
    <script src="https://checkout.safehavenmfb.com/assets/checkout.min.js"></script>
    <script type="text/javascript">
    	let payWithSafeHaven = () => {
            console.log("payWithSafeHaven called");
            let checkOut = SafeHavenCheckout({
                environment: "production", //sandbox || production
                clientId: "YOUR_OAUTH2_CLIENT_ID",
                referenceCode: ''+Math.floor((Math.random() * 1000000000) + 1),
                customer: {
                    firstName: "John",
                    lastName: "Doe",
                    emailAddress: "johndoe@example.com",
                    phoneNumber: "+2348032273616"
                },
                currency: "NGN", // Must be NGN
                amount: 100,
  	            //feeBearer: "account", // account = We charge you, customer = We charge the customer
                settlementAccount: {
                    bankCode: "090286", // 999240 = Sandbox || 090286 = Production
                    accountNumber: "YOUR_10_DIGITS_ACCOUNT_NUMBER"
                },
	              //webhookUrl: "",
                //customIconUrl: "https://safehavenmfb.com/assets/images/logo1.svg",
              	//metadata: { "foo": "bar" },
              	onClose: () => { console.log("Checkout Closed") },
              	callback: (response) => { console.log(response) }
            });
        }
    </script>
  </body>
</html>
  """;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlString)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
            _webViewController.runJavaScript('console.log("Page finished loading");');
          },
          onUrlChange: (url) {
            print('URL changed: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) async {
            print('Navigating to: ${request.url}');
            if (request.url.toLowerCase().contains('callback')) {
              Navigator.of(context).pop(); // Close webview on specific URL
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CustomText(
          text: 'Make payment',
          color: AppColors.white,
          size: 16,
        ),
        backgroundColor: AppColors.appBarMainColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
