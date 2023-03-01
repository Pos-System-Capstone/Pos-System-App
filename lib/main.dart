import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/util/request.dart';
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
  await preferences.clear();
  HttpOverrides.global = MyHttpOverrides();
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
        darkTheme: AppTheme.darkTheme,
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
