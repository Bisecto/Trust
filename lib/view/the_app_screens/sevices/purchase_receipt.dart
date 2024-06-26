import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_icons.dart';

class PurchaseReceipt extends StatefulWidget {
  final Map<String, dynamic> responseData;

  const PurchaseReceipt({super.key, required this.responseData});

  @override
  State<PurchaseReceipt> createState() => _PurchaseReceiptState();
}

class _PurchaseReceiptState extends State<PurchaseReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD2F69E),
                Color(0xFFF3FFEB),
                Color(0xFFD2F69E),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppIcons.purchaseReceipt),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          AppIcons.squareCancel,
                          height: 27,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Purchase Receipt',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Message: ${widget.responseData['message']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Amount: ${widget.responseData['data']['amount']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Status: ${widget.responseData['data']['status']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Customer Name: ${widget.responseData['data']['customer']['firstName']} ${widget.responseData['data']['customer']['lastName']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  // Add more fields as necessary
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
