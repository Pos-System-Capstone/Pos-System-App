import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/theme/theme_color.dart';
import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes/routes_constrants.dart';
import 'setup.dart';
import 'views/home.dart';
import 'views/login_screen/login_by_mobile_pos.dart';
import 'views/onboard.dart';
import 'views/root_view.dart';
import 'views/startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await deleteUserInfo();
  HttpOverrides.global = MyHttpOverrides();
  int? colorInx = await getThemeColor();

  createRouteBindings();
  runApp(MyApp(colorInx ?? 0));
}

class MyApp extends StatefulWidget {
  int colorIdx = 0;
  MyApp(this.colorIdx, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int themeIndex;
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
        theme: AppTheme.getThemeLight(widget.colorIdx),
        darkTheme: AppTheme.getThemeDark(widget.colorIdx),
        themeMode: ThemeMode.system,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case RouteHandler.LOGIN:
              return CupertinoPageRoute(
                  builder: (context) => LogInScreen(), settings: settings);
            case RouteHandler.HOME:
              return CupertinoPageRoute<bool>(
                  builder: (context) => RootScreen(), settings: settings);
            case RouteHandler.PROFILE:
              return CupertinoPageRoute<bool>(
                  builder: (context) => ProfileScreen(), settings: settings);
            case RouteHandler.NAV:
              return CupertinoPageRoute(
                  builder: (context) => HomeScreen(), settings: settings);
            case RouteHandler.ONBOARD:
              return CupertinoPageRoute(
                  builder: (context) => OnBoardScreen(), settings: settings);
            case RouteHandler.LOADING:
              return CupertinoPageRoute<bool>(
                  builder: (context) => LoadingScreen(
                        title: settings.arguments.toString(),
                      ),
                  settings: settings);
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
