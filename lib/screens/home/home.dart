import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jlan/screens/home/views/list_admin.dart';
import 'package:jlan/screens/home/views/list_apartment.dart';
import 'package:jlan/screens/home/views/list_tenants.dart';

import '../../utils/constant/color.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int? _selectedIndex = 0;
  final pageController = PageController(initialPage: 0);
  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [ListTenants(), ListApartment(), ListAdmin()],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: devSize.width * 0.85,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorsRes.primary,
            borderRadius: BorderRadius.circular(80),
            border: Border.all(color: Colors.white)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            button(
                onTap: () => onTapped(0),
                flag: _selectedIndex == 0,
                activeIcon: CupertinoIcons.house_fill,
                inactiveIcon: CupertinoIcons.home,
                label: 'Tenants'),
            SizedBox(
              width: 22,
            ),
            button(
                onTap: () => onTapped(1),
                flag: _selectedIndex == 1,
                activeIcon: CupertinoIcons.person_3_fill,
                inactiveIcon: CupertinoIcons.person_3,
                label: 'Apartments'),
            SizedBox(
              width: 22,
            ),
            button(
                onTap: () => onTapped(2),
                flag: _selectedIndex == 2,
                activeIcon: Icons.settings,
                inactiveIcon: Icons.settings_outlined,
                label: 'Admins'),
          ],
        ),
      ),
    );
  }

  button(
      {required bool flag,
      required IconData activeIcon,
      required IconData inactiveIcon,
      required String label,
      required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            flag ? activeIcon : inactiveIcon,
            color: flag ? Colors.white : Colors.grey,
            size: 26,
          ),
          Text(
            label,
            style: TextStyle(
                color: flag ? Colors.white : Colors.grey,
                fontSize: flag ? 16 : 14),
          )
        ],
      ),
    );
  }
}
