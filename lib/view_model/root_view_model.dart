import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/util/share_pref.dart';

import '../theme/theme_color.dart';
import 'base_view_model.dart';

class RootViewModel extends BaseViewModel {
  int numberOfTable = 20;
  bool isDarkMode = false;
  int defaultCashboxMoney = 1000000;
  int colorIndex = 0;
  RootViewModel() {
    getTableNumber().then((value) => numberOfTable = value ?? 20);
    getCashboxMonney().then((value) => defaultCashboxMoney = value ?? 1000000);
  }
  void handleChangeTheme(bool isDarkMode) async {
    int index = await getThemeColor() ?? 0;
    if (isDarkMode) {
      print(isDarkMode);
      Get.changeTheme(AppTheme.getThemeLight(index));
      // Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeTheme(AppTheme.getThemeDark(index));
    }
  }

  void handleColorSelect(bool isDarkMode, int value) {
    setThemeColor(value);
    print(value);
    if (isDarkMode) {
      Get.changeTheme(AppTheme.getThemeDark(value));
    } else {
      Get.changeTheme(AppTheme.getThemeLight(value));
    }
    // Get.changeTheme(isDarkMode
    //     ? AppTheme.getThemeDark(value)
    //     : AppTheme.getThemeLight(value));

    colorIndex = value;
    notifyListeners();
  }

  void setCashboxMonney(int value) {
    defaultCashboxMoney = value;
    setCashboxMonney(defaultCashboxMoney);
    notifyListeners();
  }

  void increaseNumberOfTabele() {
    numberOfTable++;
    setTableNumber(numberOfTable);
    notifyListeners();
  }

  void decreaseNumberOfTabele() {
    numberOfTable--;
    setTableNumber(numberOfTable);
    notifyListeners();
  }
}
