import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/Views/Flutter3Demo/marterialHome.dart';
import 'package:pos_apps/Views/Flutter3Demo/typography.dart';
import 'package:pos_apps/Views/LoginScreen/login_by_pos.dart';

import 'Routes/routes_constrants.dart';
import 'Views/Flutter3Demo/color_palattes.dart';
import 'Views/Flutter3Demo/component.dart';
import 'Views/Flutter3Demo/elevation.dart';
import 'Views/home.dart';
import 'Views/onboard.dart';
import 'Views/startup.dart';
import 'setup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = new MyHttpOverrides();
  createRouteBindings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

const Color m3BaseColor = Color(0xff6750a4);
const List<Color> colorOptions = [
  m3BaseColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink
];
const List<String> colorText = <String>[
  "M3 Baseline",
  "Blue",
  "Teal",
  "Green",
  "Yellow",
  "Orange",
  "Pink",
];

class _MyAppState extends State<MyApp> {
  bool useLightMode = true;
  int colorSelected = 0;
  int screenIndex = 0;
  double narrowScreenWidthThreshold = 450;

  late ThemeData themeData;

  @override
  initState() {
    super.initState();
    themeData = updateThemes(colorSelected, useLightMode);
  }

  ThemeData updateThemes(int colorIndex, bool useLightMode) {
    return ThemeData(
        colorSchemeSeed: colorOptions[colorSelected],
        useMaterial3: true,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void handleBrightnessChange() {
    setState(() {
      useLightMode = !useLightMode;
      themeData = updateThemes(colorSelected, useLightMode);
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = value;
      themeData = updateThemes(colorSelected, useLightMode);
    });
  }

  Widget createScreenFor(int screenIndex, bool showNavBarExample) {
    switch (screenIndex) {
      case 0:
        return ComponentScreen(showNavBottomBar: showNavBarExample);
      case 1:
        return const ColorPalettesScreen();
      case 2:
        return const TypographyScreen();
      case 3:
        return const ElevationScreen();
      default:
        return ComponentScreen(showNavBottomBar: showNavBarExample);
    }
  }

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: const Text("Material 3"),
      actions: [
        IconButton(
          icon: useLightMode
              ? const Icon(Icons.wb_sunny_outlined)
              : const Icon(Icons.wb_sunny),
          onPressed: handleBrightnessChange,
          tooltip: "Toggle brightness",
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) {
            return List.generate(colorOptions.length, (index) {
              return PopupMenuItem(
                  value: index,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          index == colorSelected
                              ? Icons.color_lens
                              : Icons.color_lens_outlined,
                          color: colorOptions[index],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(colorText[index]))
                    ],
                  ));
            });
          },
          onSelected: handleColorSelect,
        ),
      ],
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        title: 'Flutter Demo',
        themeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
        theme: themeData,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case RouteHandler.LOGIN:
              return CupertinoPageRoute(
                  builder: (context) => LoginByPos(), settings: settings);
            case RouteHandler.HOME:
              return CupertinoPageRoute<bool>(
                  builder: (context) => HomeScreen(), settings: settings);
            // case RouteHandler.NAV:
            //   return CupertinoPageRoute(
            //       builder: (context) => RootScreen(
            //             initScreenIndex: settings.arguments ?? 0,
            //           ),
            //       settings: settings);
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
            case RouteHandler.DESIGN:
              return CupertinoPageRoute<bool>(
                  builder: (context) => MarterialHome(), settings: settings);
            default:
              return CupertinoPageRoute(
                  builder: (context) => MarterialHome(), settings: settings);
          }
        },
        home: const StartUpView());
  }
}
