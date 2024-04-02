import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/app_custom_text.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Lottie.asset('assets/lottie_files/not_found.json'),
        //     const SizedBox(height: 20,),
        //
        //     const CustomText(
        //       text: "NOT FOUND",
        //       size: 20,
        //     )
        //   ],
        // ),
      ),
    );
  }
}
