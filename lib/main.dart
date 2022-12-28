import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/util/share_pref.dart';
// import 'package:pos_apps/Views/Flutter3Demo/marterialHome.dart';
import 'package:pos_apps/views/flutter3demo/typography.dart';
import 'package:pos_apps/views/login_screen/login_by_pos.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/root_view.dart';
import 'routes/routes_constrants.dart';
import 'theme/theme_color.dart';
import 'views/flutter3demo/color_palattes.dart';
import 'views/flutter3demo/component.dart';
import 'views/flutter3demo/elevation.dart';
import 'views/login_screen/login_by_mobile_pos.dart';
import 'views/home.dart';
import 'views/onboard.dart';
import 'views/startup.dart';
import 'setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  // HttpOverrides.global = new MyHttpOverrides();
  createRouteBindings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // initialRoute: RouteHandler.WELCOME,
        title: 'POS System',
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case RouteHandler.LOGIN:
              return CupertinoPageRoute(
                  builder: (context) => LogInScreen(), settings: settings);
            case RouteHandler.HOME:
              return CupertinoPageRoute<bool>(
                  builder: (context) => RootScreen(), settings: settings);
            case RouteHandler.NAV:
              return CupertinoPageRoute(
                  builder: (context) => HomeScreen(), settings: settings);
            case RouteHandler.ONBOARD:
              return CupertinoPageRoute(
                  builder: (context) => OnBoardScreen(), settings: settings);
            case RouteHandler.LOADING:
              return CupertinoPageRoute<bool>(
                  builder: (context) => LoadingScreen(
                        title: settings.arguments.toString() ?? "Đang xử lý...",
                      ),
                  settings: settings);
            // case RouteHandler.ONBOARD:
            //   return ScaleRoute(page: OnBoardScreen());
            // case RouteHandler.DESIGN:
            //   return CupertinoPageRoute<bool>(
            //       builder: (context) => MarterialHome(), settings: settings);
            case RouteHandler.WELCOME:
              return CupertinoPageRoute<bool>(
                  builder: (context) => StartUpView(), settings: settings);
            default:
              return CupertinoPageRoute(
                  builder: (context) => StartUpView(), settings: settings);
          }
        },
        home: const StartUpView());
  }
}
