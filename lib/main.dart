import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/theme_view_model.dart';
import 'package:pos_apps/views/not_found_screen.dart';
import 'package:pos_apps/widgets/order_process/payment.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'routes/routes_constrants.dart';
import 'setup.dart';
import 'views/login_screen/login_by_mobile_pos.dart';
import 'views/screens/home/root_view.dart';
import 'views/startup.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await deleteUserInfo();
  createRouteBindings();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScopedModel(
        model: ThemeViewModel(),
        child: ScopedModelDescendant<ThemeViewModel>(
            builder: (context, builder, model) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Reso POS',
              themeMode: model.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              darkTheme: AppTheme.getThemeDark(model.colorIndex),
              theme: AppTheme.getThemeLight(model.colorIndex),
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case RouteHandler.LOGIN:
                    return CupertinoPageRoute(
                        builder: (context) => LogInScreen(),
                        settings: settings);
                  case RouteHandler.HOME:
                    return CupertinoPageRoute<bool>(
                        builder: (context) => RootScreen(), settings: settings);
                  case RouteHandler.NAV:
                    return CupertinoPageRoute(
                        builder: (context) => NotFoundScreen(),
                        settings: settings);

                  case RouteHandler.WELCOME:
                    return CupertinoPageRoute<bool>(
                        builder: (context) => StartUpView(),
                        settings: settings);
                  default:
                    return CupertinoPageRoute(
                        builder: (context) => NotFoundScreen(),
                        settings: settings);
                }
              },
              home: const StartUpView());
        }));
  }
}
