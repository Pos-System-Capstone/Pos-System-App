import 'package:flutter/material.dart';
import 'package:pos_apps/theme/theme_color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorSchemeSeed: colorOptions[0],
    useMaterial3: true,
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    colorSchemeSeed: colorOptions[0],
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}
