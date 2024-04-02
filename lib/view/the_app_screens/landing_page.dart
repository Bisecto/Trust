import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teller_trust/res/app_icons.dart';
import 'package:teller_trust/res/app_list.dart';
import 'package:teller_trust/view/the_app_screens/send_page.dart';

import '../../model/user.dart';
import '../../res/app_colors.dart';
import '../../res/app_images.dart';
import 'bills_page.dart';
import 'card_page.dart';
import 'home_page.dart';
import 'more_page.dart';

class LandingPage extends StatefulWidget {
  User user;
   LandingPage({super.key, required this.user});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  List<Widget> landPageScreens = [];

  @override
  void initState() {
    // TODO: implement initState
  landPageScreens = [
    HomePage(user: widget.user,),
    const SendPage(),
    const BillsPage(),
    const CardPage(),
     MorePage(user: widget.user,)
  ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: IndexedStack(
        children: [

          landPageScreens[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
showUnselectedLabels: true,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.lightDivider,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.home,
              color: _currentIndex == 0 ? AppColors.green : AppColors.lightgrey,
            ), //Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppIcons.send,
                color:
                    _currentIndex == 1 ? AppColors.green : AppColors.lightgrey),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.bill,
              color: _currentIndex == 2 ? AppColors.green : AppColors.lightgrey,
            ), //Icon(Icons.home),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.card,
              color: _currentIndex == 3 ? AppColors.green : AppColors.lightgrey,
            ), //Icon(Icons.home),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.more,
              color: _currentIndex == 4 ? AppColors.green : AppColors.lightgrey,
            ), //Icon(Icons.home),
            label: 'More',
          ),
        ],
      ),
      // Stack(
      //   //   index: selectedIndex,
      //   children: <Widget>[
      //     _buildOffstageNavigator('Home'),
      //     _buildOffstageNavigator('History'),
      //     _buildOffstageNavigator('Account'),
      //   ],
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   showSelectedLabels: true,
      //   type: BottomNavigationBarType.fixed,
      //   showUnselectedLabels: true,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.home_outlined,
      //         //color: Colors.grey,
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.history,
      //         //color: Colors.grey,
      //       ),
      //       label: 'History',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.person_2_outlined,
      //         //color: Colors.grey,
      //       ),
      //       label: 'Account',
      //     ),
      //   ],
      //   currentIndex: currentIndex,
      //   unselectedItemColor: Colors.grey,
      //   selectedIconTheme: const IconThemeData(color: AppColors.green),
      //   selectedItemColor: AppColors.green,
      //   onTap: (int index) {
      //     _onItemTapped(pageyKeys[index], index);
      //   },
      // )),
    );
  }
}
