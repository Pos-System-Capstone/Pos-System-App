import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/views/home.dart';
import 'package:pos_apps/views/profile.dart';
import 'package:pos_apps/widgets/cart/cart_dialog.dart';
import 'package:pos_apps/widgets/header_footer/header.dart';
import 'dart:io' show Platform;

import '../Views/setting.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<Widget> views = [
    HomeScreen(),
    SettingsScreen(),
    Center(
      child: Text('Lish su'),
    ),
    ProfileScreen()
  ];
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      activeIcon: Icon(Icons.home_outlined),
      label: 'Đặt món',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      activeIcon: Icon(Icons.settings_outlined),
      label: 'Thiết lập',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      activeIcon: Icon(Icons.settings_outlined),
      label: 'Lịch sử',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      activeIcon: Icon(Icons.account_circle_outlined),
      label: 'Tài khoản',
    ),
  ];
  List<NavigationRailDestination> destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.home),
      selectedIcon: Icon(Icons.home_outlined),
      label: Text('Đặt món'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      selectedIcon: Icon(Icons.settings_outlined),
      label: Text('Thiết lập'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.history),
      selectedIcon: Icon(Icons.history_outlined),
      label: Text('Đơn hàng'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_circle),
      selectedIcon: Icon(Icons.account_circle_outlined),
      label: Text('Tài khoản'),
    ),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait) {
      return SafeArea(
          child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => showCartDialog(),
                child: Icon(Icons.shopping_cart),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  items: items),
              body: views[_selectedIndex]));
    }
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              leading: Icon(
                Icons.coffee_outlined,
                size: 56,
              ),
              // groupAlignment: -0.5,
              trailing: Column(
                children: const [
                  IconButton(
                    alignment: Alignment.bottomCenter,
                    tooltip: "Đăng xuất",
                    onPressed: null,
                    icon: Icon(
                      Icons.logout,
                      size: 40,
                    ),
                  ),
                  Text("Đăng xuất")
                ],
              ),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
            ),
            VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: Column(
                children: [
                  Platform.isWindows ? Header() : SizedBox(),
                  Expanded(
                    child: views.elementAt(_selectedIndex),
                  ),
                  // Footer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
