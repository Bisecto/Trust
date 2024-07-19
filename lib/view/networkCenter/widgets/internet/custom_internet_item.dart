import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teller_trust/res/app_spacer.dart';

class CustomInternetItem extends StatelessWidget {
  final double progressPercent;
  final String internetItemName;
  final VoidCallback navigationFunctionality;
  const CustomInternetItem({
    super.key,
    required this.internetItemName,
    required this.navigationFunctionality,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: navigationFunctionality,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 25.0,
              lineWidth: 5.0,
              percent: progressPercent / 100,
              center: Text(
                "$progressPercent%",
                style: const TextStyle(
                  fontSize: 10.0,
                ),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black,
              progressColor: Colors.green,
            ),
            const AppSpacer(
              width: 7.0,
            ),
            Text(
              internetItemName,
              style: const TextStyle(
                fontSize: 17.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
