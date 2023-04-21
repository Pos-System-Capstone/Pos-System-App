import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/view_model/theme_view_model.dart';
import 'package:pos_apps/views/screens/not_found_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'routes/routes_constrants.dart';
import 'setup.dart';
import 'views/screens/login_screen/login_by_mobile_pos.dart';
import 'views/screens/root_view.dart';
import 'views/screens/startup.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
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
            getPages: [
              GetPage(
                  name: RouteHandler.WELCOME,
                  page: () => StartUpView(),
                  transition: Transition.zoom),
              GetPage(name: RouteHandler.LOGIN, page: () => LogInScreen()),
              GetPage(name: RouteHandler.HOME, page: () => RootScreen()),
            ],
            initialRoute: RouteHandler.WELCOME,
            unknownRoute:
                GetPage(name: RouteHandler.NAV, page: () => NotFoundScreen()),
          );
        }));
  }
}
