import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/share_pref.dart';
import '../views/widgets/other_dialogs/dialog.dart';

class ThemeViewModel extends BaseViewModel {
  SharedPreferences? sharedPreferences;
  int? colorIndex;
  bool isDarkMode = false;
  ThemeViewModel() {
    loadCurrentTheme();
  }
  void toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    setThemeMode(Get.isDarkMode ? false : true);
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void loadCurrentTheme() async {
    colorIndex = await getThemeColor() ?? 2;
    isDarkMode = await getThemeMode() ?? false;

    notifyListeners();
  }

  void handleColorSelect(int value) {
    setThemeColor(value);

    colorIndex = value;

    notifyListeners();
    showAlertDialog(
      title: 'Đổi chủ đề thành công',
      content: 'Vui lòng khởi động lại ứng dụng để thay đổi chủ đề',
    );
  }
}
