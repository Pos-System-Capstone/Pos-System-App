import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';

import '../theme/theme_color.dart';
import 'base_view_model.dart';

class RootViewModel extends BaseViewModel {
  int numberOfTable = 20;
  void handleChangeTheme() {
    if (Get.isDarkMode) {
      Get.changeTheme(AppTheme.lightTheme);
    } else {
      Get.changeTheme(AppTheme.darkTheme);
    }
    notifyListeners();
  }

  void handleColorSelect(int value) {
    if (Get.isDarkMode) {
      ThemeData darkTheme = ThemeData(
        colorSchemeSeed: colorOptions[value],
        useMaterial3: true,
        brightness: Brightness.dark,
      );
      Get.changeTheme(darkTheme);
    } else {
      ThemeData lightTheme = ThemeData(
        colorSchemeSeed: colorOptions[value],
        useMaterial3: true,
        brightness: Brightness.light,
      );
      Get.changeTheme(lightTheme);
    }
    notifyListeners();
  }

  void increaseNumberOfTabele() {
    numberOfTable++;
    notifyListeners();
  }

  void decreaseNumberOfTabele() {
    numberOfTable--;
    notifyListeners();
  }
}
