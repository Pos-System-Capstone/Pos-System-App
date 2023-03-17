import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/views/home.dart';
import 'package:pos_apps/views/login_screen/login_by_mobile_pos.dart';
import 'package:pos_apps/views/startup.dart';

import '../Views/root_view.dart';
import '../helper/responsive_helper.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = "/login";
  static getInitialRoute() => '$initial';
  static getSplashRoute() => '$splash';
  static getHomeRoute(String name) => '$home?name=$name';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => StartUpView()),
    GetPage(name: splash, page: () => StartUpView()),
    GetPage(
      name: login,
      page: () => LogInScreen(),
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => RootScreen(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 300),
    ),
  ];

  // static void openDialog(BuildContext context, Widget child,
  //     {bool isDismissible = true}) {
  //   !ResponsiveHelper.isTab()
  //       ? Get.bottomSheet(
  //           isDismissible: isDismissible,
  //           child,
  //           backgroundColor: Colors.transparent,
  //           enterBottomSheetDuration: Duration(milliseconds: 100),
  //           isScrollControlled: true,
  //         )
  //       :
  //       // Get.dialog(
  //       //   useSafeArea: true,
  //       //
  //       //   transitionDuration: Duration(milliseconds: 300),
  //       //   Dialog(backgroundColor: Colors.transparent, child:  child,),
  //       // );
  //       showAnimatedDialog(
  //           context: context,
  //           duration: Duration(milliseconds: 200),
  //           barrierDismissible: isDismissible,
  //           builder: (BuildContext context) {
  //             return Dialog(
  //               backgroundColor: Colors.transparent,
  //               child: child,
  //             );
  //           },
  //           animationType: DialogTransitionType.slideFromBottomFade,
  //         );
  // }
}
