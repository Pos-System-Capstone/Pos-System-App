import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/views/screens/not_found_screen.dart';
import 'routes/routes_constraints.dart';
import 'setup.dart';
import 'views/screens/login_screen/login_by_mobile_pos.dart';
import 'views/screens/root_view.dart';
import 'views/screens/startup.dart';

Future<void> main() async {
  if (!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();
  int colorIndex = 2;
  bool isDarkMode = false;
  await getThemeColor().then((value) => colorIndex = value ?? 1);
  await getThemeMode().then((value) => isDarkMode = value ?? false);
  createRouteBindings();
  runApp(MyApp(
    colorIndex: colorIndex,
    isDarkMode: isDarkMode,
  ));
}

class MyApp extends StatefulWidget {
  int colorIndex;
  bool isDarkMode;
  MyApp({super.key, required this.colorIndex, required this.isDarkMode});

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reso POS',
      themeMode: widget.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.getThemeLight(widget.colorIndex),
      darkTheme: AppTheme.getThemeDark(widget.colorIndex),
      getPages: [
        GetPage(
            name: RouteHandler.WELCOME,
            page: () => StartUpView(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.LOGIN,
            page: () => LogInScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.HOME,
            page: () => RootScreen(),
            transition: Transition.cupertino),
      ],
      initialRoute: RouteHandler.WELCOME,
      unknownRoute:
          GetPage(name: RouteHandler.NAV, page: () => NotFoundScreen()),
    );
  }
}
