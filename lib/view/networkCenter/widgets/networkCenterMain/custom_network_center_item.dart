import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_spacer.dart';

class CustomNetworkCenterItem extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final VoidCallback navigationCallback;
  const CustomNetworkCenterItem({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.navigationCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: navigationCallback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imagePath,
              height: 25.0,
              width: 25.0,
            ),
            const AppSpacer(
              width: 10.0,
            ),
            Text(itemName),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
