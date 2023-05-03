import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/screens/home/cart/cart_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/other_dialogs/dialog.dart';
import 'home/cart/cart.dart';
import 'orders/orders.dart';
import 'profile/profile.dart';
import 'settings/setting.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<Widget> views = [
    AddToCartScreen(),
    OrdersScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  List<Widget> portraitViews = [
    AddToCartScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      activeIcon: Icon(Icons.home_outlined),
      label: 'Đặt món',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      activeIcon: Icon(Icons.shopping_cart_outlined),
      label: 'Giỏ hàng',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long),
      activeIcon: Icon(Icons.receipt_long_outlined),
      label: 'Đơn hàng',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.store),
      activeIcon: Icon(Icons.store_outlined),
      label: 'Cửa hàng',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      activeIcon: Icon(Icons.settings_outlined),
      label: 'Thiết lập',
    ),
  ];
  List<NavigationRailDestination> destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.home),
      selectedIcon: Icon(Icons.home_outlined),
      label: Text('Đặt món'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.receipt_long),
      selectedIcon: Icon(Icons.receipt_long_outlined),
      label: Text('Đơn hàng'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.store),
      selectedIcon: Icon(Icons.store_outlined),
      label: Text('Cửa hàng'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      selectedIcon: Icon(Icons.settings_outlined),
      label: Text('Thiết lập'),
    ),
  ];
  int _selectedIndex = 0;
  @override
  void initState() {
    Get.find<MenuViewModel>().getMenuOfStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (context.isPortrait) {
      return SafeArea(
          child: ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant(
            builder: (context, child, OrderViewModel model) {
          return Scaffold(
              // floatingActionButton: ScopedModel<CartViewModel>(
              //   model: Get.find<CartViewModel>(),
              //   child: ScopedModelDescendant(
              //       builder: (context, child, CartViewModel model) {
              //     if (model.quantity == 0) {
              //       return FloatingActionButton(
              //         // Your actual Fab
              //         onPressed: () => showCartDialog(),
              //         child: Icon(Icons.shopping_cart),
              //       );
              //     }
              //     return FittedBox(
              //       child: Stack(
              //         alignment: Alignment(1.4, -1.5),
              //         children: [
              //           FloatingActionButton(
              //             // Your actual Fab
              //             onPressed: () => showCartDialog(),
              //             child: Icon(Icons.shopping_cart),
              //           ),
              //           Container(
              //             // This is your Badge
              //             padding: EdgeInsets.all(8),
              //             constraints:
              //                 BoxConstraints(minHeight: 32, minWidth: 32),
              //             decoration: BoxDecoration(
              //               // This controls the shadow
              //               boxShadow: [
              //                 BoxShadow(
              //                     spreadRadius: 1,
              //                     blurRadius: 5,
              //                     color: Colors.black.withAlpha(50))
              //               ],
              //               borderRadius: BorderRadius.circular(16),
              //               color: Get.theme.colorScheme
              //                   .secondary, // This would be color of the Badge
              //             ),
              //             // This is your Badge
              //             child: Center(
              //               // Here you can put whatever content you want inside your Badge
              //               child: Text(model.quantity.toString(),
              //                   style: TextStyle(color: Colors.white)),
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   }),
              // ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  items: items),
              body: portraitViews[_selectedIndex]);
        }),
      ));
    }
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              leading: Image.asset(
                "assets/images/logo.png",
                width: 60,
                height: 60,
              ),
              // groupAlignment: -0.5,
              trailing: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      alignment: Alignment.bottomCenter,
                      tooltip: "Cập nhật dữ liệu thực đơn",
                      onPressed: () =>
                          Get.find<MenuViewModel>().getMenuOfStore(),
                      icon: Icon(
                        Icons.browser_updated,
                        size: 32,
                      ),
                    ),
                    Text(
                      "Cập nhật",
                      style: Get.textTheme.labelMedium,
                    ),
                    Text(
                      "Menu ",
                      style: Get.textTheme.labelMedium,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    IconButton(
                      alignment: Alignment.bottomCenter,
                      tooltip: "Đăng xuất",
                      onPressed: () => {
                        showConfirmDialog(
                          title: "Đăng xuất",
                          content: "Bạn có muốn đăng xuất không?",
                        ).then((value) => {
                              if (value) Get.find<LoginViewModel>().logout(),
                            })
                      },
                      icon: Icon(
                        Icons.logout,
                        size: 32,
                      ),
                    ),
                    Text(
                      "Đăng xuất",
                      style: Get.textTheme.labelMedium,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
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
