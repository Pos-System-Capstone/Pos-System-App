import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/product_attribute.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/theme/app_theme.dart';
import 'package:pos_apps/util/share_pref.dart';

import '../theme/theme_color.dart';
import 'base_view_model.dart';

class RootViewModel extends BaseViewModel {
  int numberOfTable = 20;
  bool isDarkMode = false;
  num defaultCashboxMoney = 1000000;
  int colorIndex = 0;
  List<Attribute> listAttribute = [];
  Attribute addAttributes = Attribute("", []);
  RootViewModel() {
    getTableNumber().then((value) => numberOfTable = value ?? 20);
    getCashboxMonney().then((value) => defaultCashboxMoney = value ?? 1000000);
    getAttributes().then((value) => listAttribute = value ?? []);
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

  void setCurrentAttributeName(
    String name,
  ) {
    addAttributes.name = name;
    print(addAttributes.name);
    print(addAttributes.options);
    notifyListeners();
  }

  void setCurrentAttributeOption(String value) {
    addAttributes.options?.add(value);
    print(addAttributes.name);
    print(addAttributes.options);
    notifyListeners();
  }

  void removeCurrentAttributeOption(String value) {
    addAttributes.options?.remove(value);
    print(addAttributes.name);
    print(addAttributes.options);
    notifyListeners();
  }

  void addAttribute() {
    listAttribute.add(addAttributes);
    setAttributes(listAttribute);
    addAttributes = Attribute("", []);
    notifyListeners();
  }

  void deleteAttribute(Attribute value) {
    listAttribute.remove(value);
    setAttributes(listAttribute);
    notifyListeners();
  }

  void deleteAttributeOptions(Attribute value, String option) {
    listAttribute
        .firstWhere((element) => element.name == value.name)
        .options
        ?.remove(option);
    setAttributes(listAttribute);
    notifyListeners();
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

  void setCashboxMoney(int value) {
    setState(ViewStatus.Loading);
    defaultCashboxMoney = value;
    setCashboxMonney(value);
    setState(ViewStatus.Completed);
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
