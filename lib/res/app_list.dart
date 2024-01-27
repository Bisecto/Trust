import 'package:flutter/material.dart';
import 'package:teller_trust/view/the_app_screens/bills_page.dart';
import 'package:teller_trust/view/the_app_screens/card_page.dart';
import 'package:teller_trust/view/the_app_screens/home_page.dart';
import 'package:teller_trust/view/the_app_screens/more_page.dart';

import '../view/the_app_screens/send_page.dart';

class AppList {
  List<Widget> landPageScreens = [
    const HomePage(),
    const SendPage(),
    const BillsPage(),
    const CardPage(),
    const MorePage()
  ];
}
