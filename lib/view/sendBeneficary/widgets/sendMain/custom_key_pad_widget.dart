import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teller_trust/res/app_colors.dart';

class CustomKeyPadWidget extends StatelessWidget {
  final String keyPadValue;
  final bool isKeyPadValueIcon;
  final VoidCallback keyPadCallback;
  const CustomKeyPadWidget({
    super.key,
    required this.keyPadValue,
    required this.keyPadCallback,
    this.isKeyPadValueIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: keyPadCallback,
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.only(
          bottom: 5.0,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              5.0,
            ),
          ),
          color: AppColors.white,
          child: Center(
            child: isKeyPadValueIcon
                ? SvgPicture.asset(keyPadValue)
                : Text(
                    keyPadValue,
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}
