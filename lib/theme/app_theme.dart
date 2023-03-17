import 'package:flutter/material.dart';
import 'package:pos_apps/theme/theme_color.dart';

class AppTheme {
  static ThemeData lightThemeM3BaseColor = ThemeData(
    colorSchemeSeed: ThemeColor.m3BaseColor,
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static ThemeData darkThemeM3BaseColor = ThemeData(
    colorSchemeSeed: ThemeColor.m3BaseColor,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
  static ThemeData lightThemeBlue = ThemeData(
    colorSchemeSeed: ThemeColor.blue,
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static ThemeData darkThemeBlue = ThemeData(
    colorSchemeSeed: ThemeColor.blue,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
  static ThemeData lightThemeTeal = ThemeData(
    colorSchemeSeed: ThemeColor.teal,
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static ThemeData darkThemeTeal = ThemeData(
    colorSchemeSeed: ThemeColor.teal,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
  static ThemeData lightThemeGreen = ThemeData(
    colorSchemeSeed: ThemeColor.green,
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static ThemeData darkThemeGreen = ThemeData(
    colorSchemeSeed: ThemeColor.green,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
  static ThemeData lightThemeYellow = ThemeData(
    colorSchemeSeed: ThemeColor.yellow,
    useMaterial3: true,
    brightness: Brightness.light,
  );
  static ThemeData darkThemeYellow = ThemeData(
    colorSchemeSeed: ThemeColor.yellow,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
  static ThemeData lightThemeOrange = ThemeData(
    colorSchemeSeed: ThemeColor.orange,
    useMaterial3: true,
    brightness: Brightness.light,
  );
  static ThemeData darkThemeOrange = ThemeData(
    colorSchemeSeed: ThemeColor.orange,
    useMaterial3: true,
    brightness: Brightness.dark,
  );
  static ThemeData lightThemePink = ThemeData(
    colorSchemeSeed: ThemeColor.pink,
    useMaterial3: true,
    brightness: Brightness.light,
  );
  static ThemeData darkThemePink = ThemeData(
    colorSchemeSeed: ThemeColor.pink,
    useMaterial3: true,
    brightness: Brightness.dark,
  );

  static ThemeData getThemeLight(int idx) {
    return ThemeData(
      colorSchemeSeed: colorOptions[idx],
      useMaterial3: true,
      brightness: Brightness.light,
    );
  }

  static ThemeData getThemeDark(int idx) {
    return ThemeData(
      colorSchemeSeed: colorOptions[idx],
      useMaterial3: true,
      brightness: Brightness.dark,
    );
  }
}
