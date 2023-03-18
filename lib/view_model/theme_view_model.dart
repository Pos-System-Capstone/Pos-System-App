import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import '../util/app_constants.dart';
import '../util/share_pref.dart';

class ThemeViewModel extends BaseViewModel {
  SharedPreferences? sharedPreferences;
  int colorIndex = 0;
  bool isDarkMode = false;
  ThemeViewModel() {
    _loadCurrentTheme();
  }
  void toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    setThemeMode(Get.isDarkMode ? false : true);
    isDarkMode = !isDarkMode;
    print("IsDarkMode");
    print(isDarkMode);
    notifyListeners();
  }

  void _loadCurrentTheme() async {
    colorIndex = await getThemeColor() ?? 0;
    isDarkMode = await getThemeMode() ?? false;
    print("colorIndex");
    print(colorIndex);
    print("IsDarkMode");
    print(isDarkMode);
    notifyListeners();
  }

  void handleColorSelect(int value) {
    setThemeColor(value);

    colorIndex = value;

    notifyListeners();
    showAlertDialog(
      title: 'Change Theme',
      content: 'Please restart app to apply new theme',
    );
  }
}
