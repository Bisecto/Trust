import 'package:flutter/material.dart';
import 'package:teller_trust/res/app_list.dart';

import '../../res/app_colors.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          AppList().landPageScreens[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.green,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
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
