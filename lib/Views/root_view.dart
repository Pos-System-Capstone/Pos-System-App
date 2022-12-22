import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pos_apps/views/home.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<Widget> views = const [
    HomeScreen(),
    Center(
      child: Text('Account'),
    ),
    Center(
      child: Text('Settings'),
    ),
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
              child: views.elementAt(_selectedIndex),
            )
          ],
        ),
      ),
    );
  }
}
