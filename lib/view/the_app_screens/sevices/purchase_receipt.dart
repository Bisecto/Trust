import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_icons.dart';

import '../../../utills/app_navigator.dart';

class PurchaseReceipt extends StatefulWidget {
  const PurchaseReceipt({super.key});

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
                Color(0xD2F69E),
                Color(0xF3FFEB),
                Color(0xD2F69E),

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppIcons.purchaseReceipt),
                      GestureDetector(
                        onTap: (){
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
